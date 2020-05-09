#	CopyMem_2.s
#	Vesion : 0.1
#	Date : 06-04-20
#	Last revise : 06-04-20
#	Description :
#			Feature as same as 'CopyMem_1.s' but will use 7 lines for instruction to complete that.(Not contain 'exit').
#		As less must using 8 lines code.

.section .data

	#	Type 'int' length 32bit	

	Array1:
		.int 0x1,0x2,0x3,0x4,0x5,0x6,0x7,0x8

	Array2:
		.int 0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0

.section .bss

.section .text

.global _start

	_start:

		movl	$Array1,%EBX		#	Get address for Array1 and save at EBX
		movl	$Array2,%EBP		#	Get address for Array2 and save at EBP
		movl	$0x0,%EDI		#	Index register
		movw	$8,%CX			#	Cycle count.

	CYCLE:
	
	#	On the book,instructions 'push' and 'pop' could have suffix.But in gas,suffix was not be supported.
	#	It is possbile auto to match length.		

		push	(%EBX,%EDI,0x4)		#	pushl (32bit) a element to stack
		pop	(%EBP,%EDI,0x4)		#	popl (32bit) a element from stack
		incl	%EDI			#	incl (32bit) make value in EDI increase 1
		loop	CYCLE			#	Cycle point.

	EXIT:
		movl	$0x1,%EAX		#	System call number '1' - sys_exit
		movl	$0x0,%EBX		#	Value in EBX will be returning to system
		int	$0x80			#	Soft interrupt.
