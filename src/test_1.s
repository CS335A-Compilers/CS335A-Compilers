.LC0:
	.text
	.string	"%lld\n"
	.globl main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	pushq %r12
	movq	$0,%r12
	movq	%r12, -8(%rbp)
	movq	$1,%r12
	movq	%r12, -56(%rbp)
	movq	$2,%r12
	movq	%r12, -48(%rbp)
	movq	$3,%r12
	movq	%r12, -40(%rbp)
	movq	$4,%r12
	movq	%r12, -32(%rbp)
	movq	$5,%r12
	movq	%r12, -24(%rbp)
	movq	$6,%r12
	movq	%r12, -16(%rbp)
	movq	$3,%r12
	movq	-24(%rbp), %rax
	cqo
	idivq	%r12
	movq	%rdx, -24(%rbp)
	movq	-24(%rbp), %r12
	movq	-24(%rbp),%r12
	movq	%r12, %rsi
	leaq	.LC0(%rip), %rdi
	movq $0, %rax
	call	printf
	movq	$3,%r12
	movq	-32(%rbp), %rax
	cqo
	idivq	%r12
	movq	%rdx, -32(%rbp)
	movq	-32(%rbp), %r12
	movq	-32(%rbp),%r12
	movq	%r12, %rsi
	leaq	.LC0(%rip), %rdi
	movq $0, %rax
	call	printf
	movq	$3,%r12
	movq	-48(%rbp), %rax
	cqo
	idivq	%r12
	movq	%rdx, -48(%rbp)
	movq	-48(%rbp), %r12
	movq	-48(%rbp),%r12
	movq	%r12, %rsi
	leaq	.LC0(%rip), %rdi
	movq $0, %rax
	call	printf
	popq	%r12
	addq	$64, %rsp
	leave
	ret
