#	TEST_Ins.s
#	Version : 0.1
#	Date : 23-04-20
#	Last revise : 23-04-20
#	Promise-Symbol : 
#			_start - Start pointer
#			XXXX.. - Normal symbol
#			_XX.._ - Function symbol

.section .data

.section .bss

	.lcomm TempF,4	#	Double words

.section .text

.code32		#	Use 32bit mode.

.global _start

	_start:

		movl	$TempF,%EBX		#	Address

		movb	$0B11010011,%AL		#	AL=0B11010011 == 211
		pushf		#	Push 32bit EFLAGS
		popl	(%EBX)	#	Use EBX save eflags temporarly.

		
		#	break point.
		
		#	Use test instruction to testing for AL.

		test	$0B01001111,%AL		#	AL&0B01001111,this operation will be changing EFLAGS.

		movl	$0x0,(%EBX)
		pushf
		popl	(%EBX)

		#	break point.

	EXIT:

		movl	$0x1,%EAX		#	sys_exit
		movl	$0x0,%EBX		#	return 0
		int	$0x80			#	Soft interrupt

