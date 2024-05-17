	.file	"main.c"
	.text //Начало программы
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0: //Создание строковой константы
	.string	"(SUBPROCESS) Fibonacci of %ld is %ld.\n"
	.text
	.p2align 4
	.globl	run_fib //Глобальная функция
	.type	run_fib, @function
run_fib:
.LFB22:
	.cfi_startproc
	subq	$8, %rsp // Резервируем место для локальных переменных на стеке
	.cfi_def_cfa_offset 16
	movq	n(%rip), %rdi // Передаем значение аргумента n функции Fibonacci в регистр RDI
	call	fibonacci@PLT // Вызываем функцию Fibonacci
	movq	n(%rip), %rsi // Снова передаем значение аргумента n в регистр RSI для вывода результата
	addq	$8, %rsp // Освобождаем место, зарезервированное на стеке
	.cfi_def_cfa_offset 8
	leaq	.LC0(%rip), %rdi // Загружаем адрес строки формата в RDI для передачи в printf
	movq	%rax, %rdx // Переносим результат из RAX (возвращаемый регистр) в RDX (аргумент для вывода)
	xorl	%eax, %eax // Обнуляем EAX (для успешного возврата из функции)
	jmp	printf@PLT // Переходим к вызову функции printf
	.cfi_endproc
.LFE22: //Создание строковой константы
	.size	run_fib, .-run_fib
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1: //Создание строковой константы
	.string	"Hello, World!"
.LC2: //Создание строковой константы
	.string	"Fibonacci of %ld is %ld.\n"
.LC3: //Создание строковой константы
	.string	"A Child process killed."
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB23:
	.cfi_startproc
	pushq	%rbx // Сохраняем RBX на стеке
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	leaq	.LC1(%rip), %rdi
	subq	$16, %rsp // Резервируем место для локальных переменных на стеке
	.cfi_def_cfa_offset 32
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp) // Сохраняем значение в стеке
	xorl	%eax, %eax // Обнуляем EAX (для успешного возврата из функции)
	call	puts@PLT
	call	fork@PLT // Создаем дочерний процесс с помощью fork
	testl	%eax, %eax
	jne	.L5 // Переходим к .L5
	xorl	%eax, %eax // Обнуляем EAX (для успешного возврата из функции)
	call	run_fib // Вызываем функцию run_fib
.L6:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L9 // Переходим к .L9
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	xorl	%eax, %eax // Обнуляем EAX (для успешного возврата из функции)
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret // Возвращаемся из функции main
.L5:
	.cfi_restore_state
	movq	n(%rip), %rdi // Передаем значение аргумента n функции Fibonacci в RDI
	movl	%eax, %ebx // Сохраняем результат fork в EBX 
	call	fibonacci@PLT // Вызываем функцию Fibonacci
	movq	n(%rip), %rsi // Передаем значение аргумента n в RSI для вывода результата
	leaq	.LC2(%rip), %rdi
	movq	%rax, %rdx // Переносим результат из RAX (возвращаемый регистр) в RDX (аргумент для вывода)
	xorl	%eax, %eax // Обнуляем EAX (для успешного возврата из функции)
	call	printf@PLT
	movl	%ebx, %edi // Передаем сохраненное значение результат fork в EDI для передачи в waitpid
	leaq	4(%rsp), %rsi
	xorl	%edx, %edx // Обнуляем EDX (для передачи опций в waitpid)
	call	waitpid@PLT 
	leaq	.LC3(%rip), %rdi
	call	puts@PLT // Вызываем puts для вывода сообщения о завершении дочернего процесса
	jmp	.L6 // Переходим к .L6 
.L9:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE23:
	.size	main, .-main
	.globl	n
	.data
	.align 8
	.type	n, @object
	.size	n, 8
n: // Инициализируем переменную n значением 11
	.quad	11
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
