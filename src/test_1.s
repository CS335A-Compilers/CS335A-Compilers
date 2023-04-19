.LC0:
	.text
	.string	"%lld\n"
	.globl main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$144, %rsp
	pushq %r12
	pushq %rbx
	pushq %r10
	pushq %r13
	pushq %r14
	movq	$0,%r12
	movq	%r12, -96(%rbp)
.L1:
	movq	-96(%rbp),%r12
	movq	$10,%rbx
	cmpq	%rbx, %r12
	setl	%r12b
	movzbq	%r12b, %r12
	cmpq	$0, %r12
	je	.L2
	movq	-96(%rbp),%r12
	movq	-96(%rbp),%rbx
	movq	$10,%r10
	imulq	%r10, %rbx
	leaq	-88(%rbp), %r10
	movq	%rbx, (%r10, %r12, 8)
.L3:
	movq	-96(%rbp),%r12
	movq	%r12, %rbx
	addq	$1, %r12
	movq	%r12, -96(%rbp)
	jmp .L1
.L2:
	movq	$0,%r12
	movq	%r12, -104(%rbp)
	movq	$10,%r12
	movq	$1,%rbx
	subq	%rbx, %r12
	movq	%r12, -112(%rbp)
	movq	$30,%r12
	movq	%r12, -120(%rbp)
	movq	-104(%rbp),%r12
	movq	-112(%rbp),%rbx
	addq	%rbx, %r12
	movq	$2,%rbx
	movq	%r12, %rax
	cqo
	idivq	%rbx
	movq	%rax, %r12
	movq	%r12, -128(%rbp)
.L4:
	movq	-104(%rbp),%r12
	movq	-112(%rbp),%rbx
	cmpq	%rbx, %r12
	setle	%r12b
	movzbq	%r12b, %r12
	cmpq	$0, %r12
	je	.L5
	movq	-128(%rbp),%rbx
	leaq	-88(%rbp), %r10
	movq	(%r10, %rbx, 8), %rbx
	movq	-120(%rbp),%r10
	cmpq	%r10, %rbx
	setl	%bl
	movzbq	%bl, %rbx
	cmpq	$0, %rbx
	je	.L6
	movq	-128(%rbp),%r10
	movq	$1,%r13
	addq	%r13, %r10
	movq	%r10, -104(%rbp)
	jmp .L7
.L6:
	movq	-128(%rbp),%r10
	leaq	-88(%rbp), %r13
	movq	(%r13, %r10, 8), %r10
	movq	-120(%rbp),%r13
	cmpq	%r13, %r10
	sete	%r10b
	movzbq	%r10b, %r10
	cmpq	$0, %r10
	je	.L8
	movq	-128(%rbp),%r13
	movq	%r13, %rsi
	leaq	.LC0(%rip), %rdi
	movq $0, %rax
	call	printf
	jmp .L5
	jmp .L9
.L8:
	movq	-128(%rbp),%r13
	movq	$1,%r14
	subq	%r14, %r13
	movq	%r13, -112(%rbp)
.L9:
.L7:
	movq	-104(%rbp),%r13
	movq	-112(%rbp),%r14
	addq	%r14, %r13
	movq	$2,%r14
	movq	%r13, %rax
	cqo
	idivq	%r14
	movq	%rax, %r13
	movq	%r13, -128(%rbp)
	jmp .L4
.L5:
	movq	-104(%rbp),%r13
	movq	-112(%rbp),%r14
	cmpq	%r14, %r13
	setg	%r13b
	movzbq	%r13b, %r13
	cmpq	$0, %r13
	je	.L10
	movq	$1,%r14
	neg	%r14
	movq	%r14, %rsi
	leaq	.LC0(%rip), %rdi
	movq $0, %rax
	call	printf
.L10:
	popq	%r14
	popq	%r13
	popq	%r10
	popq	%rbx
	popq	%r12
	leave
	ret
