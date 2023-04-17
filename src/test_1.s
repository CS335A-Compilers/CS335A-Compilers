main:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq %r12
	movq	$1,%r12
	movq	%r12, -8(%rbp)
	movq	$0,%r12
	movq	%r12, -16(%rbp)
	movq	$5,%r12
	movq	%r12, %rax
	popq  %r12
	popq	%rbp
	ret
