#	Mulite_Section_1.s
#	Version : 0.1
#	Date : 06-04-20
#	Last revise : 06-04-20
#	Description : 
/*
			Define a array zone and push,pop elements.Program have to using a new stack section.But in protect mode it could not be done.
*/

.section .data
	
	#	Array zone with data type 'word'.Size is 8 words.

	Array:
		.word 0x0123,0x0456,0x0789,0x0ABC,0x0DEF,0x0FED,0x0CBA,0x0987

.section .bss

.section .text  

.global _start

	_start:

		movl	$Array,%EBX		#	Get array address and save in EBX

	#	push and pop could use suffix 'w',but can not use 'l'.
		
		pushw	(%EBX)			#	push a word element to stack,source address is %EBX
		pushw	2(%EBX)			#	push a word element to stack,source address is %EBX+2
		popw	(%EBX)			#	pop a word element from stack,destination address is %EBX+2
		popw	2(%EBX)			#	pop a word element from stack,destination address is %EBX

	EXIT:
		
		movl	$0x1,%EAX		#	sys_exit
		movl	$0x0,%EBX		#	Return 0
		int	$0x80			#	Soft interrupt
		
