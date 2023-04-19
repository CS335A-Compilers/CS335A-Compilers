.LC0:
	.text
	.string	"%lld\n"
	.globl main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	pushq %r12
	pushq %rbx
	movq	$5,%r12
	movq	$0, %r10
	leaq	-16(%rbp), %rbx
	movq	%r12, (%rbx, %r10, 1)
	movq	$0, %rbx
	leaq	-16(%rbp), %r12
	movq	(%r12, %rbx, 1), %rbx
	movq	%rbx, -24(%rbp)
	movq	-24(%rbp),%r12
	movq	%r12, %rsi
	leaq	.LC0(%rip), %rdi
	movq $0, %rax
	call	printf
	popq	%rbx
	popq	%r12
	addq	$32, %rsp
	leave
	ret
