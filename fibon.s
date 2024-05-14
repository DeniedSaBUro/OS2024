	.file	"main.c"
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"(SUBPROCESS) Fibonacci of %ld is %ld.\n"
	.text
	.p2align 4
	.globl	run_fib
	.type	run_fib, @function
run_fib:
.LFB22:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	n(%rip), %rdi
	call	fibonacci@PLT
	movq	n(%rip), %rsi
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	leaq	.LC0(%rip), %rdi
	movq	%rax, %rdx
	xorl	%eax, %eax
	jmp	printf@PLT
	.cfi_endproc
.LFE22:
	.size	run_fib, .-run_fib
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"Hello, World!"
.LC2:
	.string	"Fibonacci of %ld is %ld.\n"
.LC3:
	.string	"A Child process killed."
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB23:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	leaq	.LC1(%rip), %rdi
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	call	puts@PLT
	call	fork@PLT
	testl	%eax, %eax
	jne	.L5
	xorl	%eax, %eax
	call	run_fib
.L6:
	movq	8(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L9
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L5:
	.cfi_restore_state
	movq	n(%rip), %rdi
	movl	%eax, %ebx
	call	fibonacci@PLT
	movq	n(%rip), %rsi
	leaq	.LC2(%rip), %rdi
	movq	%rax, %rdx
	xorl	%eax, %eax
	call	printf@PLT
	movl	%ebx, %edi
	leaq	4(%rsp), %rsi
	xorl	%edx, %edx
	call	waitpid@PLT
	leaq	.LC3(%rip), %rdi
	call	puts@PLT
	jmp	.L6
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
n:
	.quad	11
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
