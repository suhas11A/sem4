#include <unistd.h>     // fork, execvp, close
#include <fcntl.h>      // open
#include <sys/wait.h>   // waitpid
#include <stdio.h>      // perror
#include <stdlib.h>     // exit

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <inputfile>\n", argv[0]);
        return 1;
    }

    pid_t pid = fork();

    if (pid == 0) {
        close(STDIN_FILENO);
        int fd = open(argv[1], O_RDONLY);
        char *args[] = {"cat", NULL};
        execvp("cat", args);
    } else {
        int status = 0;
        waitpid(pid, &status, 0);
        return WIFEXITED(status) ? WEXITSTATUS(status) : 1;
    }
}

