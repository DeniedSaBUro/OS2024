#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include "fun.h"

size_t n = 11;

void run_fib(int pipe_fd) {
    size_t res = fibonacci(n);
    write(pipe_fd, &res, sizeof(res)); // Передача результата в родительский процесс через канал
}

int main() {
    printf("Hello, World!\n");
    int pipe_fd[2];
    pipe(pipe_fd); // Создание канала

    pid_t cpid = fork();
    if (cpid == -1) {
        perror("fork");
        exit(EXIT_FAILURE);
    }

    if (cpid == 0) { // Дочерний процесс
        close(pipe_fd[0]); // Закрываем конец канала для чтения
        run_fib(pipe_fd[1]); // Выполняем вычисления и передаем результат через канал
        close(pipe_fd[1]); // Закрываем конец канала для записи
        exit(EXIT_SUCCESS);
    } else { // Родительский процесс
        close(pipe_fd[1]); // Закрываем конец канала для записи

        size_t res;
        read(pipe_fd[0], &res, sizeof(res)); // Считываем результат из канала
        printf("Fibonacci of %ld is %ld.\n", n, res);

        close(pipe_fd[0]); // Закрываем конец канала для чтения

        int status;
        waitpid(cpid, &status, 0);
        if (WIFEXITED(status)) {
            printf("A Child process killed.\n");
        }
    }
    return 0;
}
