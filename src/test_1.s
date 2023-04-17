4    a
8    b
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	$1,%r12
	movq	%r12, -4(%rbp)
	movq	$2,%r12
	movq	%r12, -8(%rbp)
	movq	-8(%rbp),%r12
	movq	-4(%rbp),%rbx
	imulq	%rbx, %r12
	movq	-4(%rbp),%rbx
	addq	%rbx, %r12
	ret
