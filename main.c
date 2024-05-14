#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include "fun.h"


size_t n = 11;

void run_fib(){
    size_t res = fibonacci(n);
    printf("(SUBPROCESS) Fibonacci of %ld is %ld.\n", n, res);
}

int main(){
    printf("Hello, World!\n");
    size_t cpid;

    if ((cpid = fork()) == 0){
        run_fib();
    }
    else {
        size_t res = fibonacci(n);
        printf("Fibonacci of %ld is %ld.\n", n, res);
    }
    if (cpid != 0){
        int rc;
        waitpid(cpid, &rc, 0);
        printf("A Child process killed.\n");
    }
    return 0;
}
