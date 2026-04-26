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

  int NPROCS = atoi(argv[1]);
  printf("Creating %d processes...\n", NPROCS);
  uint result[NPROCS];
  memset(result, 0, sizeof(result));

  uint64 parent_pa = va2pa(FASTUPTIME_PAGE);

  for (int i = 0; i < NPROCS; i++) {
    if (fork() == 0) {
      uint64 child_pa = va2pa(FASTUPTIME_PAGE);
      if (child_pa != parent_pa) {
        exit(1);
      }
      exit(0);
    }
  }
  int failed_pa_matches = 0;
  for (int i = 0; i < NPROCS; i++) {
    int status;
    wait(&status);
    if (status != 0) {
      failed_pa_matches++;
    }
  }

  if (parent_pa == 0 || failed_pa_matches > 0) {
    printf("Failed: FASTUPTIME_PAGE not mapped properly.\n");
  } else {
    printf("Passed: FASTUPTIME_PAGE has the same PA in all child processes.\n");
  }
  exit(0);
}
