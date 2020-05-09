#	Lib_Member1.s
#	Version : 0.1
#	Date : 25-04-20
#	Last revise : 25-04-20
#	Symbol-Promise : 
#			_start - Start pointer
#			XXX... - Normaly symbol
#			_XXX._ - Function symbol
#
#	Description : This file as a object file would be linking to a C program file.

.section .data

	MSG:
		.asciz "Function KKSK had been called,program quiting\n"	#	Prompt string.
	MSG_Length:
		.byte . - MSG	#	Length

.section .bss

.section .text

	.type _KKSK_,@function
	.global _KKSK_
	_KKSK_:

		#	Arguments : Need not any parameters.
		#	Return : Return value saved in EAX.
		#	The registers would be used : EAX,EBX,ECX,EDX

		_Env_Of_KKSK_:

				pushq	%RBX	#	Save the old value.
				pushq	%RCX
				pushq	%RDX

		_Work_Zone_KKSK_:

				movq	$0x0,%RDX	#	Clear RDX

				movl	$0x04,%EAX	#	sys_write
				movl	$0x01,%EBX	#	stdout
				leal	MSG,%ECX	#	Data buffer
				movb	MSG_Length,%DL	#	Length

				int	$0x80		#	Soft interrupt

		_Return_Zone_KKSK_:

				popq	%RDX	#	Restore old value
				popq	%RCX
				popq	%RBX

				ret		#	Return

		
