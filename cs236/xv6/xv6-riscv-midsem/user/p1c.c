#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define NUMPAGES 1024
#define PAGESIZE 4096

int main(int argc, char* argv[]) {
  char *old_sbrk = (char*)sbrklazy(NUMPAGES * PAGESIZE), *p;

  printf("Number of pages allocated: %d\n", NUMPAGES);

  ////////////////////////////
  printf("Accessing %d pages with sbrklazy_size(1)\n", NUMPAGES / 4);
  sbrklazy_size(1); // Uncomment this line after implementing sbrklazy_size

  for (p = old_sbrk; p < old_sbrk + NUMPAGES * PAGESIZE / 4; p += PAGESIZE) {
    *p = 'a';
  }

  printf("Expected page faults: %d\n", NUMPAGES / 4);
  printf("Actual page faults: %d\n", get_pagefaults());

  printf("\n");

  //////////////////////////////
  printf("Accessing %d pages with sbrklazy_size(2)\n", NUMPAGES / 4);
  sbrklazy_size(2); // Uncomment this line after implementing sbrklazy_size

  for (; p < old_sbrk + 2 * NUMPAGES * PAGESIZE / 4; p += PAGESIZE) {
    *p = 'b';
  }

  printf("Expected page faults: %d\n", NUMPAGES / 4 + NUMPAGES / 4 / 2);
  printf("Actual page faults: %d\n", get_pagefaults());

  printf("\n");

  ///////////////////////////////
  printf("Accessing %d pages with sbrklazy_size(4)\n", NUMPAGES / 4);
  sbrklazy_size(4); // Uncomment this line after implementing sbrklazy_size

  for (; p < old_sbrk + 3 * NUMPAGES * PAGESIZE / 4; p += PAGESIZE) {
    *p = 'b';
  }

  printf("Expected page faults: %d\n",
         NUMPAGES / 4 + NUMPAGES / 4 / 2 + NUMPAGES / 4 / 4);
  printf("Actual page faults: %d\n", get_pagefaults());

  printf("\n");

  ////////////////////////////////
  printf("Accessing %d pages with sbrklazy_size(1)\n", NUMPAGES / 4);
  sbrklazy_size(1); // Uncomment this line after implementing sbrklazy_size

  for (; p < old_sbrk + 4 * NUMPAGES * PAGESIZE / 4; p += PAGESIZE) {
    *p = 'b';
  }

  printf("Expected page faults: %d\n",
         NUMPAGES / 4 + NUMPAGES / 4 / 2 + NUMPAGES / 4 / 4 + NUMPAGES / 4);
  printf("Actual page faults: %d\n", get_pagefaults());

  exit(0);
}