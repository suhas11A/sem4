#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if (argc != 3) {
    printf("Usage: p2b <path> <exit status> <arg>\n");
    exit(1);
  }

  pause(1);
  
  printf("[pid %d] Child: %s\n", getpid(), argv[2]);

  exit(atoi(argv[1]));
}
