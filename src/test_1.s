.LC0:
	.text
	.string	"%lld\n"
	.globl main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$112, %rsp
	pushq %r12
	pushq %rbx
	pushq %r10
	movq	$0,%r12
	movq	%r12, -88(%rbp)
.L1:
	movq	-88(%rbp),%r12
	movq	$10,%rbx
	cmpq	%rbx, %r12
	setl	%r12b
	movzbq	%r12b, %r12
	cmpq	$0, %r12
	je	.L2
	movq	-88(%rbp),%r12
	movq	-88(%rbp),%rbx
	movq	$2,%r10
	imulq	%r10, %rbx
	leaq	-80(%rbp), %r10
	movq	%rbx, (%r10, %r12, 8)
.L3:
	movq	-88(%rbp),%r12
	movq	%r12, %rbx
	addq	$1, %r12
	movq	%r12, -88(%rbp)
	jmp .L1
.L2:
	movq	$0,%r12
	movq	%r12, -96(%rbp)
	movq	$0,%r12
	movq	%r12, -88(%rbp)
.L4:
	movq	-88(%rbp),%r12
	movq	$10,%rbx
	cmpq	%rbx, %r12
	setl	%r12b
	movzbq	%r12b, %r12
	cmpq	$0, %r12
	je	.L5
	movq	-88(%rbp),%r12
	leaq	-80(%rbp), %rbx
	movq	(%rbx, %r12, 8), %r12
	addq	%r12, -96(%rbp)
	movq	-96(%rbp), %r12
.L6:
	movq	-88(%rbp),%r12
	movq	%r12, %rbx
	addq	$1, %r12
	movq	%r12, -88(%rbp)
	jmp .L4
.L5:
	movq	-96(%rbp),%r12
	movq	%r12, %rsi
	leaq	.LC0(%rip), %rdi
	movq $0, %rax
	call	printf
	popq	%r10
	popq	%rbx
	popq	%r12
	leave
	ret
