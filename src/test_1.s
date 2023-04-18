.LC0:
	.text
	.string	"%lld\n"
	.globl main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	pushq %r12
	pushq %rbx
	movq	$0,%r12
	movq	%r12, -8(%rbp)
.L1:
	movq	-8(%rbp),%r12
	movq	%r12, %rbx
	addq	$1, %r12
	movq	%r12, -8(%rbp)
	movq	-8(%rbp),%r12
	movq	$9,%rbx
	cmpq	%rbx, %r12
	setg	%r12b
	movzbq	%r12b, %r12
	cmpq	$0, %r12
	je	.L4
	jmp .L2
.L4:
	movq	-8(%rbp),%rbx
	movq	%rbx, %rsi
	leaq	.LC0(%rip), %rdi
	movq $0, %rax
	call	printf
.L3:
	movq	$1,%rbx
	cmpq	$1, %rbx
	je	.L1
.L2:
	popq	%rbx
	popq	%r12
	leave
	ret
