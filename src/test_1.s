.LC0:
	.text
	.string	"%lld\n"
	.globl main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	pushq %r12
	pushq %rbx
	pushq %r10
	movq	$5,%r12
	movq	%r12, -40(%rbp)
	movq	$1,%r12
	movq	$2,%rbx
	leaq	-32(%rbp), %r10
	movq	%rbx, (%r10, %r12, 8)
	movq	$1,%r12
	leaq	-32(%rbp), %rbx
	movq	(%rbx, %r12, 8), %r12
	movq	%r12, -40(%rbp)
	movq	$1,%r12
	leaq	-32(%rbp), %rbx
	movq	(%rbx, %r12, 8), %r12
	movq	%r12, %rsi
	leaq	.LC0(%rip), %rdi
	movq $0, %rax
	call	printf
	popq	%r10
	popq	%rbx
	popq	%r12
	leave
	ret
