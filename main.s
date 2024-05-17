	.file	"main.c"
	.text //Начало программы
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0: // Текстовая константа
	.string	"Cannot read all the data"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1: // Текстовая константа
	.string	"(SUBPROCESS) Fibonacci number %ld is %ld\n"
	.text
	.p2align 4
	.globl	run_fib
	.type	run_fib, @function
run_fib:
.LFB22:
	.cfi_startproc
	pushq	%rbx // Сохранение значения регистра %rbx на стеке
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp // Выделение места на стеке для локальных переменных
	.cfi_def_cfa_offset 48
	movl	4+p(%rip), %edi // Загрузка первого аргумента (файловый дескриптор) в регистр %edi
	movq	%fs:40, %rax // Получение значения текущего сегмента данных из таблицы дескриптеров
	movq	%rax, 24(%rsp) 
	xorl	%eax, %eax // Обнуляем EAX (для успешного возврата из функции)
	movq	$0, 8(%rsp) 
	call	close@PLT // Вызов функции close
	movl	p(%rip), %edi 
	leaq	8(%rsp), %rsi
	movl	$8, %edx
	call	read@PLT
	movl	p(%rip), %edi
	movq	%rax, %rbx // Сохранение количества прочитанных байт в регистр %rbx
	call	close@PLT // Вызов функции close
	cmpq	$8, %rbx // Сравнение количества прочитанных байт с 8
	jne	.L6 // Переход к метке .L6
	movq	8(%rsp), %rdi
	call	fibonacci@PLT
	movq	8(%rsp), %rsi
	leaq	.LC1(%rip), %rdi
	movq	%rax, %rdx
	movq	%rax, 16(%rsp)
	xorl	%eax, %eax // Обнуляем EAX (для успешного возврата из функции)
	call	printf@PLT // Вызов функции printf
	movl	o(%rip), %edi
	call	close@PLT
	movl	4+o(%rip), %edi
	leaq	16(%rsp), %rsi
	movl	$8, %edx
	call	write@PLT
	movl	4+o(%rip), %edi
	call	close@PLT
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L7
	addq	$32, %rsp // Восстановление указателя стека
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret // Возврат из функции
.L6:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	puts@PLT // Вызов функции puts для вывода сообщения об ошибке
	movl	$1, %edi
	call	_exit@PLT // Вызов функции _exit для завершения процесса
.L7:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE22:
	.size	run_fib, .-run_fib
	.section	.rodata.str1.1
.LC2:
	.string	"Hello, World!"
	.section	.rodata.str1.8
	.align 8
.LC3:
	.string	"Fibonacci number %ld is %ld. (Taken from child process)\n"
	.section	.rodata.str1.1
.LC4:
	.string	"A Child process killed."
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB23:
	.cfi_startproc
	pushq	%rbp // Сохранение значения регистра %rbp на стеке
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	leaq	.LC2(%rip), %rdi
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$24, %rsp // Выделение места на стеке для локальных переменных
	.cfi_def_cfa_offset 48
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax // Обнуляем EAX (для успешного возврата из функции)
	call	puts@PLT
	leaq	p(%rip), %rdi
	call	pipe@PLT // Вызов функции pipe для создания канала
	leaq	o(%rip), %rdi
	call	pipe@PLT // Вызов функции pipe для создания канала
	call	fork@PLT // Создание дочернего процесса
	testl	%eax, %eax  // Обнуляем EAX (для успешного возврата из функции)
	jne	.L9 // Переход к метке .L9
	xorl	%eax, %eax // Обнуляем EAX (для успешного возврата из функции)
	call	run_fib // Вызов функции run_fib в дочернем процессе
.L10:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L13 // Переход к метке .L13
	addq	$24, %rsp // Восстановление указателя стека
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	xorl	%eax, %eax // Обнуляем EAX (для успешного возврата из функции)
	popq	%rbx // Восстановление значения регистра %rbx
	.cfi_def_cfa_offset 16
	popq	%rbp // Восстановление значения регистра %rbp
	.cfi_def_cfa_offset 8
	ret
.L9:
	.cfi_restore_state
	movl	p(%rip), %edi
	movl	%eax, %ebx
	movq	%rsp, %rbp
	call	close@PLT
	movl	4+p(%rip), %edi
	movl	$8, %edx
	leaq	n(%rip), %rsi
	call	write@PLT
	movl	4+p(%rip), %edi
	call	close@PLT
	movl	4+o(%rip), %edi
	call	close@PLT
	movl	o(%rip), %edi
	movq	%rbp, %rsi
	movl	$8, %edx
	call	read@PLT
	movl	o(%rip), %edi
	call	close@PLT
	movq	(%rsp), %rdx
	movq	n(%rip), %rsi
	xorl	%eax, %eax
	leaq	.LC3(%rip), %rdi
	call	printf@PLT
	movl	%ebx, %edi
	xorl	%edx, %edx
	movq	%rbp, %rsi
	call	waitpid@PLT
	leaq	.LC4(%rip), %rdi
	call	puts@PLT
	jmp	.L10
.L13:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE23:
	.size	main, .-main
	.globl	n
	.data
	.align 8
	.type	n, @object
	.size	n, 8
n: //Создание переменной n
	.quad	12
	.globl	o
	.bss
	.align 8
	.type	o, @object
	.size	o, 8
o: //Создание переменной o
	.zero	8
	.globl	p
	.align 8
	.type	p, @object
	.size	p, 8
p: //Создание переменной p
	.zero	8
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
