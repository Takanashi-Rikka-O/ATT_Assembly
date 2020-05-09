#	Array_Add.s
#	Version : 0.1
#	Date : 06-04-20
#	Last revise : 06-04-20
#	Description : 
#			Add calculate for Array1 and Array2 with anyelement,and result save in Array3.

.section .data

	Array1:
		.int 0x1,0x2,0x3,0x4,0x5,0x6,0x7,0x8		#	Add1

	Array2:
		.int 0x1,0x2,0x3,0x4,0x5,0x6,0x7,0x8		#	Add2

	Array3:
		.int 0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0		#	Result

.section .bss
	
	.equ SOFTI,0x80		#	Soft interrupt

.section .text

.global _start		#	Entrance

	_start:

		movl	$Array1,%EBX		#	Get Array1 address and save in EBX
		movl	$Array2,%EBP		#	Get Array2 address and save in EBP
		movl	$Array3,%ESI		#	Get Array3 address and save in ESI
		movl	$0x0,%EDI		#	Index
		movb	$8,%CL			#	Cycle counter.

	CYCLE:

		movl	(%EBX,%EDI,0x4),%EAX	#	Take element from Array1 and save in EAX
		addl	(%EBP,%EDI,0x4),%EAX	#	Take element from Array2 and use it add %EAX,result save in EAX
		movl	%EAX,(%ESI,%EDI,0x4)	#	Send result to Array3
		incl	%EDI			#	Update counter
		loop	CYCLE			#	Cycle point.

	EXIT:

		movl	$0x1,%EAX		#	sys_exit
		movl	$0x0,%EBX		#	return 0
		int	$SOFTI			#	Soft interrupt.Quote static data must add prefix '$'.


