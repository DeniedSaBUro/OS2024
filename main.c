#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include "fun.h"

int p[2];
int o[2];

void run_fib(){
    size_t m = 0;

    close(p[1]);
    size_t sz = read(p[0], &m, sizeof(m));
    close(p[0]);
    if (sz!=sizeof(m)){
        printf("Cannot read all the data\n");
        _exit(1);
    }
    size_t res = fibonacci(m);
    printf("(SUBPROCESS) Fibonacci number %ld is %ld\n", m, res);
    close(o[0]);
    write(o[1], &res, sizeof(res));
    close(o[1]);
}

size_t n = 12;

int main(){
    printf("Hello, World!\n");
    size_t cpid;

    pipe(p);
    pipe(o);

    if ((cpid = fork()) == 0){
        run_fib();
    }
    else {
        close(p[0]);
        write(p[1], &n, sizeof(n));
        close(p[1]);

        size_t rc;

        close(o[1]);
        read(o[0], &rc, sizeof(rc));
        close(o[0]);
        printf("Fibonacci number %ld is %ld. (Taken from child process)\n", n, rc);
    }
    if (cpid!=0){
        int rc;
        waitpid(cpid, &rc, 0);
        printf("A Child process killed.\n");
    }
    return 0;
}
