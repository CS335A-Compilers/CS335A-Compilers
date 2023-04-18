main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	pushq %r12
	movq	$6,%r12
	movq	%r12, -8(%rbp)
	movq	$5,%r12
	movq	%r12, -16(%rbp)
	movq	-8(%rbp),%r12
	movq	%r12, -16(%rbp)
	popq	%r12
	popq	%rbp
	ret
