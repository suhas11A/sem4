#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

int child_done=0;
int f;

void handler(int sig, siginfo_t *info, void *ucontext) {
  double user_s = (double)info->si_utime / 100;
  double sys_s  = (double)info->si_stime / 100;
  printf("System time: %.6fs, User time:  %.6fs\nExit code: %d\n", sys_s, user_s, info->si_status);
  child_done = 1;
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    fprintf(stderr, "usage: %s <command>\n", argv[0]);
    return 1;
  }
  struct sigaction sg;
  sg.sa_flags=SA_SIGINFO;
  sg.sa_sigaction=handler;
  sigaction(SIGCHLD, &sg, NULL); //idk lol its supposed to be sig_atomic_t
  f=fork();
  if (f==0) {
    printf("Command: ");
    for (int i = 1; i < argc; i++) {
        printf("%s%s", argv[i], (i + 1 < argc) ? " " : "\n");
    }
    execvp(argv[1], &argv[1]);
    perror("execvp");
  }
  else {
    while(!child_done) ;
  }
  return 0;
}
