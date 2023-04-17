8    a
16    b
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	$1,%r12
	movq	%r12, -8(%rbp)
	movq	$2,%r12
	movq	%r12, -16(%rbp)
	movq	-16(%rbp),%r12
	movq	$3,%rbx
	addq	%rbx, %r12
	addq	%r12, -8(rbp)
	ret
