#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char* argv[]) {
  if (argc < 2) {
    printf("Usage: p2a <path> <args>\n");
    exit(1);
  }
  for (int i = 1; i < argc; i++) {
    argv[i - 1] = argv[i];
  }
  argv[argc - 1] = 0;
  int pid = -1;
  pid = spawn(argv[0], argv); // Uncomment this after implementing spawn
  if (pid <= 0) {
    printf("Spawn failed\n");
    exit(pid);
  }
  printf("[pid %d] Parent: spawning child %s with pid %d\n", getpid(), argv[0],
         pid);
  int status = 0;
  int wpid = 0;
  do {
    wpid = wait(&status);
    if (wpid < 0) exit(wpid);
  } while (wpid != pid);

  printf("[pid %d] Parent: child %s with pid %d terminated with status %d\n",
         getpid(), argv[0], pid, status);

  exit(0);
}
