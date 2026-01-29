#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>


int main(int argc, char *argv[]) {
  /* TODO: implement logic here */
  int f=fork();
  if (f==0) {
    sleep(2);
    exit(0);
  }
  else {
    int ff=fork();
    if (ff==0) {
      sleep(2);
      exit(0);
    }
    else {
      sleep(5);
      while(1) ;
    }
  }
  return 0;
}
