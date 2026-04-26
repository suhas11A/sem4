#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define PGSIZE 4096  // bytes per page
#define MAXVA (1L << (9 + 9 + 9 + 12 - 1))
#define TRAMPOLINE (MAXVA - PGSIZE)
#define TRAPFRAME (TRAMPOLINE - PGSIZE)
#define FASTUPTIME_PAGE (TRAPFRAME - PGSIZE)

int main(int argc, char* argv[]) {
  if (argc != 2) {
    printf("Usage: %s <num_processes>\n", argv[0]);
    exit(1);
  }
  int numprocs = atoi(argv[1]);

  printf("[Parent] Creating %d processes...\n", numprocs);
  
  // Uncomment this line after you implement fastuptime
  printf("[Parent] uptime() = %u\tfastuptime() = %u\n", uptime(), fastuptime());
  for (int p = 0; p < numprocs; p++) {
    int sleep_dur = 4 * (p + 1);
    printf("[Parent] Child-%d will sleep for %d ticks\n", p + 1, sleep_dur);
  }
  for (int p = 0; p < numprocs; p++) {
    int pid = fork();

    if (pid < 0) {
      printf("fork failed\n");
      exit(1);
    }

    if (pid == 0) {
      // Uncomment these after you implement fastuptime
      int sleep_dur = 4 * (p + 1);
      pause(sleep_dur);
      printf("[Child %d] woke up! uptime() = %u\tfastuptime() = %u\n", p + 1, uptime(), fastuptime());
      exit(0);
    }
  }

  for (int i = 0; i < numprocs; i++) {
    wait(0);
  }

  exit(0);
}
