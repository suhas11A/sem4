#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char* argv[]) {
  printf("[pid %d] Parent: Calling spawn(0, 0)\n", getpid());
  int ret = -1;
  ret = spawn(0, 0); // Uncomment this after implementing spawn
  if (ret == 0) {
    printf("[pid %d] Child: hello.\n", getpid());
    exit(0);
  }
  ret = wait(0);
  printf("[pid %d] Parent: goodbye. Reaped process with pid %d.\n", getpid(), ret);
}
