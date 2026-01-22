#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int main() {
  int p1_to_p2[2]; // Pipe: Parent -> Child 1
  int p2_to_p3[2]; // Pipe: Child 1 -> Child 2
  int p3_to_p1[2]; // Pipe: Child 2 -> Parent

  pid_t pid1, pid2=0;
  int num;

  // 1. take num input from command line
  
  // 2. Create all three pipes
  pipe(p1_to_p2);
  pipe(p2_to_p3);
  pipe(p3_to_p1);
  // 3. Create first child process (Child 1)
  pid1 = fork();
  // 4. Create second child process (Child 2)
  if (pid1==0) {
    read(p1_to_p2[0],&num,4);
    printf("Child 1 received: %d\n", num);
    num=num*2;
    write(p2_to_p3[1],&num,4);
  }
  else {
    pid2 = fork();
    if (pid2==0) {
      read(p2_to_p3[0],&num,4);
      printf("Child 2 received: %d\n", num);
      num=num*2;
      write(p3_to_p1[1],&num,4);
    }
    else {
      printf("Enter a number: ");
      scanf("%d", &num);
      write(p1_to_p2[1],&num,4);
      read(p3_to_p1[0],&num,4);
      printf("Parent received: %d\n", num);
    }
  }

  return 0;
}
