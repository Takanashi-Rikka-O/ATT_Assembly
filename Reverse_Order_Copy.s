#	Reverse_Order_Copy.s
#	Version : 0.1
#	Date : 06-04-20
#	Last revise : 06-04-20
#	Description : 
#			Use stack to copy elements from Array1 to Array2 with reverse order.

.section .data

	#	Array zone and element size is 32bit(8bit).(Why it not using byte? Because in debug byte data is not auto to convertion.)
	Array1:
		.int 0x1,0x2,0x3,0x4,0x5,0x6,0x7,0x8,0x9,0xA,0xB,0xC

.section .bss
	
	#	Location normally zone and uninitialized. - 32B
	.lcomm Array2,32

.section .text

.global _start		#	Entrance.

	_start:

		movl	$Array1,%EBX		#	Get address of Array1 and save in EBX.
		movl	$Array2,%EBP		#	Get address of Array2 and save in EBP.
		movl	$0x7,%EDI		#	Index for Array1.
		movl	$0x0,%ESI		#	Index for Array2.
		movb	$8,%CL			#	Cycle counter.

	CYCLE:

		push	(%EBX,%EDI,4)		#	push a element type is 32bit(8bit).
		pop	(%EBP,%ESI,4)		#	pop a element type is 32bit(8bit).
		incl	%ESI			#	ESI=%ESI+1
		decl	%EDI			#	EDI=%EDI-1
		loop	CYCLE

	EXIT:

		movl	$0x1,%EAX		#	sys_exit.
		movl	$0x0,%EBX		#	return 0.
		int	$0x80			#	Soft interrupt.
