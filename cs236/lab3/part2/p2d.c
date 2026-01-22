#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

void handler(int sig) {
  printf("You can't stop me hehe, signal number is %d, kill %d\n", sig, getpid());
}

int main(int argc, char *argv[]) {
  /* TODO: implement logic here */
  int f = fork();
  signal(SIGINT, handler);
  while(1) ;
  return 0;
}