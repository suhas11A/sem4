// shell.c (minimal)
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/wait.h>

#define MAX_INPUT_SIZE 1024
#define MAX_NUM_TOKENS 128
#define MAX_PIPE_CMDS  16
#define MAX_BG_PROCS   64

static pid_t bg[MAX_BG_PROCS];
static int bg_n = 0;

static void reap_bg(void) {
    int st;
    while (1) {
        pid_t p = waitpid(-1, &st, WNOHANG);
        if (p <= 0) {
            if (p < 0 && errno == EINTR) continue;
            break;
        }
        for (int i = 0; i < bg_n; i++) {
            if (bg[i] == p) {
                printf("Background process finished: %d\n", p);
                for (int j = i; j + 1 < bg_n; j++) bg[j] = bg[j + 1];
                bg_n--;
                break;
            }
        }
    }
}

static void add_bg(pid_t p) {
    if (bg_n < MAX_BG_PROCS) bg[bg_n++] = p;
    else fprintf(stderr, "too many background processes\n");
}

static char** tokenize(const char *line) {
    char **toks = calloc(MAX_NUM_TOKENS + 1, sizeof(char*));
    int t = 0, i = 0;

    while (line[i]) {
        while (line[i] == ' ' || line[i] == '\t' || line[i] == '\n') i++;
        if (!line[i]) break;
        if (t >= MAX_NUM_TOKENS) break;

        if (line[i] == '|' || line[i] == '<' || line[i] == '&') {
            toks[t] = calloc(2, 1);
            toks[t][0] = line[i++];
            t++;
            continue;
        }
        if (line[i] == '>') {
            if (line[i+1] == '>') {
                toks[t] = calloc(3, 1);
                toks[t][0] = '>'; toks[t][1] = '>';
                i += 2;
            } else {
                toks[t] = calloc(2, 1);
                toks[t][0] = '>';
                i += 1;
            }
            t++;
            continue;
        }

        int start = i;
        while (line[i] && !strchr(" \t\n|<>&>", line[i])) i++;
        int len = i - start;
        toks[t] = malloc(len + 1);
        memcpy(toks[t], line + start, len);
        toks[t][len] = 0;
        t++;
    }
    toks[t] = NULL;
    return toks;
}

static void free_tokens(char **toks) {
    if (!toks) return;
    for (int i = 0; toks[i]; i++) free(toks[i]);
    free(toks);
}

static int has_tok(char **t, const char *s) {
    for (int i = 0; t && t[i]; i++) if (!strcmp(t[i], s)) return 1;
    return 0;
}

static int last_is_amp(char **t) {
    int n = 0; while (t && t[n]) n++;
    return n > 0 && !strcmp(t[n-1], "&");
}

static void exec_simple(char **argv, int bgflag) {
    pid_t p = fork();
    if (p < 0) { perror("fork"); return; }
    if (p == 0) {
        execvp(argv[0], argv);
        fprintf(stderr, "command not found: %s\n", argv[0]);
        _exit(127);
    }
    if (bgflag) { add_bg(p); return; }
    while (waitpid(p, NULL, 0) < 0 && errno == EINTR) {}
}

static int exec_redir(char **t) {
    int op = -1; // index of <, >, >>
    for (int i = 0; t[i]; i++) {
        if (!strcmp(t[i], "<") || !strcmp(t[i], ">") || !strcmp(t[i], ">>")) {
            if (op != -1) { fprintf(stderr, "only one redirection supported\n"); return 1; }
            op = i;
        }
    }
    if (op == -1) return 0;

    if (op == 0 || !t[op+1] || t[op+2]) { fprintf(stderr, "bad redirection\n"); return 1; }

    char *argv[MAX_NUM_TOKENS];
    int k = 0;
    for (int i = 0; i < op; i++) argv[k++] = t[i];
    argv[k] = NULL;

    const char *file = t[op+1];
    pid_t p = fork();
    if (p < 0) { perror("fork"); return 1; }
    if (p == 0) {
        int fd;
        if (!strcmp(t[op], "<")) {
            fd = open(file, O_RDONLY);
            if (fd < 0) { perror("open"); _exit(1); }
            dup2(fd, STDIN_FILENO);
        } else if (!strcmp(t[op], ">")) {
            fd = open(file, O_WRONLY|O_CREAT|O_TRUNC, 0644);
            if (fd < 0) { perror("open"); _exit(1); }
            dup2(fd, STDOUT_FILENO);
        } else {
            fd = open(file, O_WRONLY|O_CREAT|O_APPEND, 0644);
            if (fd < 0) { perror("open"); _exit(1); }
            dup2(fd, STDOUT_FILENO);
        }
        close(fd);
        execvp(argv[0], argv);
        fprintf(stderr, "command not found: %s\n", argv[0]);
        _exit(127);
    }
    while (waitpid(p, NULL, 0) < 0 && errno == EINTR) {}
    return 1;
}

static int exec_pipe(char **t) {
    if (!has_tok(t, "|")) return 0;

    char *cmds[MAX_PIPE_CMDS][MAX_NUM_TOKENS];
    int C = 0, i = 0;

    while (t[i]) {
        if (C >= MAX_PIPE_CMDS) { fprintf(stderr, "too many pipe commands\n"); return 1; }
        int k = 0;
        while (t[i] && strcmp(t[i], "|")) cmds[C][k++] = t[i++];
        if (k == 0) { fprintf(stderr, "empty pipe segment\n"); return 1; }
        cmds[C][k] = NULL;
        C++;
        if (t[i] && !strcmp(t[i], "|")) i++;
    }
    if (C < 2) { fprintf(stderr, "pipe needs 2+ commands\n"); return 1; }

    int pipes[MAX_PIPE_CMDS-1][2];
    for (int p = 0; p < C-1; p++) if (pipe(pipes[p]) < 0) { perror("pipe"); return 1; }

    pid_t pids[MAX_PIPE_CMDS];
    for (int c = 0; c < C; c++) {
        pid_t p = fork();
        if (p < 0) { perror("fork"); return 1; }
        if (p == 0) {
            if (c > 0)  dup2(pipes[c-1][0], STDIN_FILENO);
            if (c < C-1) dup2(pipes[c][1], STDOUT_FILENO);
            for (int q = 0; q < C-1; q++) { close(pipes[q][0]); close(pipes[q][1]); }
            execvp(cmds[c][0], cmds[c]);
            fprintf(stderr, "command not found: %s\n", cmds[c][0]);
            _exit(127);
        }
        pids[c] = p;
    }
    for (int q = 0; q < C-1; q++) { close(pipes[q][0]); close(pipes[q][1]); }
    for (int c = 0; c < C; c++) while (waitpid(pids[c], NULL, 0) < 0 && errno == EINTR) {}
    return 1;
}

int main(void) {
    char line[MAX_INPUT_SIZE];

    while (1) {
        reap_bg();
        printf("$ ");
        fflush(stdout);

        if (!fgets(line, sizeof(line), stdin)) break;

        char **t = tokenize(line);
        if (!t || !t[0]) { free_tokens(t); continue; }

        if (!strcmp(t[0], "exit")) { free_tokens(t); break; }

        if (!strcmp(t[0], "cd")) {
            if (!t[1] || t[2]) fprintf(stderr, "usage: cd <dir>\n");
            else if (chdir(t[1]) != 0) perror("cd");
            free_tokens(t);
            continue;
        }

        if (exec_pipe(t)) { free_tokens(t); continue; }
        if (exec_redir(t)) { free_tokens(t); continue; }

        int bgflag = 0;
        if (last_is_amp(t)) {
            bgflag = 1;
            int n = 0; while (t[n]) n++;
            free(t[n-1]);
            t[n-1] = NULL;
            if (!t[0]) { fprintf(stderr, "bad &: no command\n"); free_tokens(t); continue; }
        }

        exec_simple(t, bgflag);
        free_tokens(t);
    }

    reap_bg();
    return 0;
}