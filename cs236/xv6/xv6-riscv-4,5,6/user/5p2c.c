#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
  // Implement your logic here.
  int a; uint64 p = (uint64)&a;
  int f = fork();
  if (f==0) {
    printf("child  : virtual is %ld, physical is %ld\n", p, va_to_pa(p));
    exit(0);
  }
  wait(0);
  printf("parent : virtual is %ld, physical is %ld\n", p, va_to_pa(p));
  exit(0);
}
