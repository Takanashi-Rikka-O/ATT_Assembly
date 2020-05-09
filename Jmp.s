#	Jmp.s
#	Version : 0.1
#	Date : 09-04-20
#	Last revise : 09-04-20
#	Description : 
#			Test for 'jmp' instruction and 'jcxz' instruction.	

.section .data

	MSG1:
		.ascii "JMP part! "		#	Hint message.
	MSG2:
		.ascii	"JCXZ part!"		#	Hint message.

.section .bss

	.lcomm ENTER,1				#	Enter.In this memory would be saving 'ENTER'

.section .text

.global _start

	_start:

	#---------------------------------------#

	Env:
		
		movl	$0x1,%ECX		#	Set ECX=1
		movb	$0x0A,ENTER		#	Set ENTER=0x0A	(New line).

	#---------------------------------------#

	Context:	

		#	Set a symbol 'Context' which is for stop to jump.

		jecxz	JECXZ			#	Jump to 'JECXZ',but Register must is equal to zero. (In 64bit,must use 'jecxz')

		nop				#	Do nothing
		nop				#	Do nothing

		jmp	JMP			#	Jump to 'JMP',need not any conditions.

		nop				#	Do nothing
		nop				#	Do nothing

	#---------------------------------------#

	JMP:
		
		#	nanosleep 162.		
		#	What is a regretly! Couldn't call sleep function in assembly,it have not be contained in 'unistd.h'.

	Write:

		movl	$0x4,%EAX		#	write - 4
		movl	$0x1,%EBX		#	stdout
		movl	$MSG1,%ECX		#	data buffer
		movl	$0x0A,%EDX		#	Length 10 Byte
		int	$0x80			#	Soft interrupt.
/*
	Sleep:
	
		movl	$0xA2,%EAX		#	sleep - 167
		movl	$0x3,%EBX		#	3s
		int	$0x80			#	Soft interrupt.
*/
	ToHead:
		
		movl	$0x0,%ECX		#	Condition set for jcxz.
		jmp	Context			#	Jump to Context.

	#---------------------------------------#

	JECXZ:

		movl	$0x4,%EAX		#	write - 4
		movl	$0x1,%EBX		#	stdout
		movl	$MSG2,%ECX		#	data buffer
		movl	$0x0A,%EDX		#	Length 10 Byte
		int	$0x80			#	Soft interrupt.

	#---------------------------------------#

	EXIT:

		movl	$0x4,%EAX		#	Reset EAX,because after sys_call,the EAX would save result of calling.	
		movl	$0x1,%EBX		#	stdout
		movl	$ENTER,%ECX		#	Enter character
		movl	$0x1,%EDX		#	Size 1 Byte
		int	$0x80			#	Soft interrupt.

		movl	$0x1,%EAX		#	sys_exit
		movl	$0x0,%EBX		#	return 0
		int	$0x80			#	Soft interrupt.









