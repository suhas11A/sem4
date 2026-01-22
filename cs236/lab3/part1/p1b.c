#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

int main() {
  int pipe1[2]; // Parent -> Child
  int pipe2[2]; // Child -> Parent
  pid_t pid;
  char buffer[20];

  // 1. Initialize both pipes
  int smth1 = pipe(pipe1);
  int smth2 = pipe(pipe2);
  pid = fork();

  if (pid > 0) {
    // PARENT PROCESS
    // 2. Write "Ping" to pipe1
    write(pipe1[1],"Ping",4);
    // 6. Read response from pipe2
    read(pipe2[0],buffer,100);
    // 7. Print "[PID=process_id, PPID=parent_process_id] Parent received: ..." and close remaining ends
    printf("[PID=%d, PPID=%d] Parent received: %s\n", getpid(), getppid(), buffer);
    close(pipe1[0]); close(pipe1[1]); close(pipe2[0]); close(pipe2[1]);
  } else {
    // CHILD PROCESS
    // 3. Read "Ping" from pipe1
    read(pipe1[0],buffer,100);
    // 4. Print "[PID=process_id, PPID=parent_process_id] Child received: ..."
    printf("[PID=%d, PPID=%d] Child received: %s\n", getpid(), getppid(), buffer);
    // 5. Write "Pong" to pipe2 and close remaining ends
    write(pipe2[1],"Pong",4);
    close(pipe1[0]); close(pipe1[1]); close(pipe2[0]); close(pipe2[1]);
  }

  return 0;
}
