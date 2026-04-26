#include "kernel/types.h"
#include "user/user.h"

#define PGSIZE 4096  // bytes per page
#define MAXVA (1L << (9 + 9 + 9 + 12 - 1))
#define TRAMPOLINE (MAXVA - PGSIZE)
#define TRAPFRAME (TRAMPOLINE - PGSIZE)
#define FASTUPTIME_PAGE (TRAPFRAME - PGSIZE)

int main(int argc, char* argv[]) {
  printf("Reading addr FASTUPTIME_PAGE (%p)\nExpecting to not crash on read\n",
         (void*)FASTUPTIME_PAGE);
  uint a = *(uint*)FASTUPTIME_PAGE;
  printf("Read value: %d\n", a);
  printf("Writing to addr FASTUPTIME_PAGE (%p)\nExpecting to crash on write\n",
         (void*)FASTUPTIME_PAGE);
  *(uint*)FASTUPTIME_PAGE = 10;
  printf("If this didn't crash, the page is NOT MAPPED PROPERLY!\n");
  return 0;
}
