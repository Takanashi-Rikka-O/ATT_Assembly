	.file	"Inline_asm.c"
	.section	.rodata
.LC0:
	.string	"Value1(%d) + Value2(%d) = %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$10, -4(%rbp)
	movl	$20, -8(%rbp)
	movl	$0, -12(%rbp)
	movl	-4(%rbp), %edx
	movl	-8(%rbp), %ecx
#APP
# 19 "Inline_asm.c" 1
	movl	%edx,%eax
	addl	%eax,%ecx
	movl	%ecx,%edx
	
# 0 "" 2
#NO_APP
	movl	%edx, -12(%rbp)
	movl	-12(%rbp), %ecx
	movl	-8(%rbp), %edx
	movl	-4(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-39)"
	.section	.note.GNU-stack,"",@progbits
