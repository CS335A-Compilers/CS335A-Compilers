.LC0:
	.text
	.string	"%lld\n"
	.globl main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	pushq %r12
	pushq %rbx
	pushq %r10
	pushq %r13
	movq	$0,%r12
	movq	%r12, -8(%rbp)
.LL1:
	movq	-8(%rbp),%r12
	movq	$5,%rbx
	cmpq	%rbx, %r12
	jge	.L1
	movq	$0,%r12
	movq	%r12, -16(%rbp)
.LL2:
	movq	-16(%rbp),%r12
	movq	$5,%r10
	cmpq	%r10, %r12
	jge	.L2
	movq	-8(%rbp),%r12
	movq	-16(%rbp),%r13
	addq	%r13, %r12
	movq	%r12, %rsi
	leaq	.LC0(%rip), %rdi
	movq $0, %rax
	call	printf
	movq	-16(%rbp),%r12
	movq	%r12, %r10
	addq	$1, %r12
	movq	%r12, -16(%rbp)
	jmp .LL2
.L2:
	movq	-8(%rbp),%r12
	movq	%r12, %rbx
	addq	$1, %r12
	movq	%r12, -8(%rbp)
	jmp .LL1
.L1:
	popq	%r13
	popq	%r10
	popq	%rbx
	popq	%r12
	leave
	ret
