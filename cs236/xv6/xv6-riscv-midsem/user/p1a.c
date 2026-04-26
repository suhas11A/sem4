#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define NUMPAGES 512
#define PAGESIZE 4096

int main(int argc, char* argv[]) {
  if (argc != 2) {
    printf("Usage: p1a <sbrklazy_size>\n");
    exit(1);
  }

  int k = atoi(argv[1]);
  if (k <= 0 || k > NUMPAGES) {
    printf("0 <= sbrklazy_size <= %d\n", NUMPAGES);
    exit(1);
  }

  sbrklazy_size(k); // Uncomment this line after implementing sbrklazy_size

  char* old_sbrk = (char*)sbrklazy(NUMPAGES * PAGESIZE);
  printf("Number of pages allocated: %d, k = %d\n", NUMPAGES, k);

  for (char* p = old_sbrk; p < old_sbrk + NUMPAGES * PAGESIZE; p += PAGESIZE) {
    *p = 'a';
  }

  printf("Expected page faults: %d\n", (NUMPAGES + k - 1) / k);
  printf("Actual page faults: %d\n", get_pagefaults());

  exit(0);
}