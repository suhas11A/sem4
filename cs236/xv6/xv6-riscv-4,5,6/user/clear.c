#include "kernel/types.h"
#include "user/user.h"

int
main(void)
{
  // ANSI escape: clear screen + move cursor to top-left
  printf("\033[2J\033[H");
  exit(0);
}