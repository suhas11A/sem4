#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

int child_done=0;
int f;

void handler(int sig) {
  printf("child %d sent me signal fuck youuuu\n", f);
  child_done = 1;
}

int main(int argc, char *argv[]) {
  /* TODO: implement logic here */
  f=fork();
  if (f==0) {
    sleep(3);
    exit(0);
  }
  else {
    signal(SIGCHLD, handler);
    while(!child_done) ;
  }
  return 0;
}
