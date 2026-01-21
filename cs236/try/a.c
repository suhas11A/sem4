#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>

int main() {
	int pid=fork();
	char *args[] = {"ls", "-l", "/home", NULL};
	if (pid==0) {
		execvp("ls", args);
	}
	printf("ola\n");
}
