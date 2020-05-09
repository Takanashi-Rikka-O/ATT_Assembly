#	CopyIns.s
#	Version : 0.1
#	Date : 06-04-20
#	Last revise : 06-04-20
#	Description : 
#			Copy instructions until 'exit' to other part.


.section .data

.section .bss
	
	#	Location normally memory zone and uninitialized.And symbol is 'CMDS',length is 30B.
	.lcomm CMDS,30

.section .text

.global _start

	_start:

		movw	%CS,%AX		#	Get instuction section address.
		movw	%AX,%ES		#	Change data for section register ES.
		movl	%EAX,%EBX	#	Base address register.
		movl	$CMDS,%EBP	#	Array zone address.
		movl	$0x0,%EDI	#	Index address register.
		movb	$30,%CL		#	Cycle count.

	CYCLE:

	#	Error,because the value in CS is not a realy physical address.
	
		movl	%ES:(,%EDI,0x1),%EAX	#	Send one byte data to AL.
		movb	%AL,(%EBP,%EDI,0x1)	#	Send data from AL to memory.
		loop	CYCLE

	EXIT:
		
		movl	$0x1,%EAX	#	sys_exit
		movl	$0x0,%EBX	#	Return value
		int	$0x80		#	Soft interrupt

