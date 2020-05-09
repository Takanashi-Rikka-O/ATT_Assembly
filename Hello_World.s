#	Hello_World.s
#	Version : 0.1
#	Date : 07-04-20
#	Last revise : 07-04-20
#	Description : 
#			Hello World!

.section .data

	HW:
		.ascii "Hellow World!\n"
#	Length:
#		.int 0x0

	Length= . - HW				#	This is GAS syntax.

.section .bss

.section .text

.global _start

	_start:
		
	Write:
	
		movl	$0x4,%EAX		#	Write.
		movl	$0x1,%EBX		#	file descript 1.
		movl	$HW,%ECX		#	Data buffer address.

#		leal	Length,%EDX		#	Save address of Length to EDX
#		subl	$HW,%EDX		#	%EDX-$HW=Length of string
		movl	$Length,%EDX

		int	$0x80			#	Soft interrupt

	Exit:
		
		movl	$0x1,%EAX		#	sys_exit
		movl	$0x0,%EBX		#	Return 0
		int	$0x80			#	Soft interrupt.
