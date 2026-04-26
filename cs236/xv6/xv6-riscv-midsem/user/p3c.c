#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char* argv[]) {
  if (argc != 2) {
    printf("Usage: %s <iterations>\n", argv[0]);
    exit(1);
  }

  int iterations = atoi(argv[1]);

  // Uncomment this line after you implement fastuptime
  printf("start: uptime() = %u\tfastuptime() = %u\n", uptime(), fastuptime());

  uint64 t1, t2, t3, t4;

  // ---- measure normal syscall uptime() ----
  t1 = uptime();
  for (int i = 0; i < iterations; i++) {
    fastuptime(); // Uncomment this line after you implement fastuptime
  }
  t2 = uptime();

  uint64 elapsed_fast = t2 - t1;
  printf("fastuptime() * %d: %lu ticks\n", iterations, elapsed_fast);

  // ---- measure direct fastuptime() ----
  t3 = uptime();
  for (int i = 0; i < iterations; i++) {
    uptime();
  }
  t4 = uptime();

  uint64 elapsed_sys = t4 - t3;

  printf("uptime()     * %d: %lu ticks\n", iterations, elapsed_sys);

  // Uncomment this line after you implement fastuptime
  printf("end  : uptime() = %u\tfastuptime() = %u\n", uptime(), fastuptime());
  exit(0);
}
