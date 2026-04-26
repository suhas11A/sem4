#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define NUMPAGES 12
#define PAGESIZE 4096

void access_page(char* base, int pg) {
  printf("Accessing page %d | ", pg);
  base[pg * PAGESIZE] = 'x';
  printf("total pgfaults: %d\n", get_pagefaults());
}

int main(int argc, char* argv[]) {
  sbrklazy_size(4); // Uncomment this line after implementing sbrklazy_size

  char* base = (char*)sbrklazy(NUMPAGES * PAGESIZE);

  printf("sbrklazy_size = 4\n");
  printf("Allocated %d pages lazily\n\n", NUMPAGES);

  access_page(base, 2);  // expect faults = 1
  access_page(base, 3);  // should not fault
  access_page(base, 5);  // should not fault
  access_page(base, 4);  // should not fault

  printf("\n");
  
  access_page(base, 7); // expect faults = 2
  access_page(base, 8); // should not fault
  access_page(base, 9); // should not fault
  access_page(base, 10); // should not fault

  printf("\n");

  access_page(base, 0); // expect faults = 3
  access_page(base, 1); // should not fault
  access_page(base, 6); // should not fault
  access_page(base, 11); // should not fault

  printf("\n");
  access_page(base, 5); // should not fault

  access_page(base, 12); // trap!!!

  exit(0);
}
