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
	pushq %r10
	movq	$5,%r12
	movq	$0, %r10
	leaq	-16(%rbp), %rbx
	movq	%r12, (%rbx, %r10, 1)
	movq	$6,%r12
	movq	$8, %r10
	leaq	-16(%rbp), %rbx
	movq	%r12, (%rbx, %r10, 1)
	movq	$0, %rbx
	leaq	-16(%rbp), %r12
	movq	(%r12, %rbx, 1), %rbx
	movq	$8, %r10
	leaq	-16(%rbp), %r12
	movq	(%r12, %r10, 1), %r10
	addq	%r10, %rbx
	movq	$2,%r12
	imulq	%r12, %rbx
	movq	$8, %r10
	leaq	-16(%rbp), %r12
	movq	(%r12, %r10, 1), %r10
	addq	%r10, %rbx
	movq	$0, %r10
	leaq	-16(%rbp), %r12
	movq	%rbx, (%r12, %r10, 1)
	movq	$0, %rbx
	leaq	-16(%rbp), %r12
	movq	(%r12, %rbx, 1), %rbx
	movq	%rbx, %rsi
	leaq	.LC0(%rip), %rdi
	movq $0, %rax
	call	printf
	popq	%r10
	popq	%rbx
	popq	%r12
	addq	$32, %rsp
	leave
	ret
