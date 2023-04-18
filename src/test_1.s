.LC0:
	.text
	.string	"%lld\n"
	.globl fib
fib:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	pushq %r12
	pushq %rbx
	pushq %r10
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp),%r12
	movq	$2,%rbx
	cmpq	%rbx, %r12
	jg	.L1
	movq	$1,%r12
	movq	%r12, %rax
	jmp .LL1
.L1:
	movq	-8(%rbp),%r12
	movq	$1,%rbx
	subq	%rbx, %r12
	movq	%r12, %rdi
	call	fib
	movq	%rax, %r12
	movq	-8(%rbp),%rbx
	movq	$2,%r10
	subq	%r10, %rbx
	movq	%rbx, %rdi
	call	fib
	movq	%rax, %rbx
	addq	%rbx, %r12
	movq	%r12, %rax
.LL1:
	popq	%r10
	popq	%rbx
	popq	%r12
	leave
	ret
	.globl main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	pushq %r12
	movq	$6,%r12
	movq	%r12, %rdi
	call	fib
	movq	%rax, %r12
	movq	%r12, -8(%rbp)
	movq	-8(%rbp),%r12
	movq	%r12, %rsi
	leaq	.LC0(%rip), %rdi
	movq $0, %rax
	call	printf
	popq	%r12
	leave
	ret
