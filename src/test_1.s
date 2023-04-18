.LC0:
	.text
	.string	"%lld\n"
	.globl main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	pushq %r12
	movq	$9,%r12
	movq	%r12, -8(%rbp)
	movq	$1,%r12
	movq	%r12, -16(%rbp)
	popq	%r12
	leave
	ret
