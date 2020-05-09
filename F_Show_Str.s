#	F_Show_Str.s
#	Version : 0.1
#	Date : 10-04-20
#	Last revise : 10-04-20
#	Description : 
#			Define a function in assembly and call it to show a string.

.section .data

	MSG:
		.ascii "Linux assembly!\n"	#	Message.

.section .bss

#	.lcomm ENTER,1				#	ENTER

.section .text

#.code32

#	Command '.code32' could notice to GAS use 32bit assemblier.Then could use suffix 'w || l' for some instructions.
#
#	But in default '64bit',RSP(stack pointer) will save a address which is 8B.
#	If use EBP as stack pointer in function (movl %ESP,%EBP) ,RSP have data size is 6B(Stack address),but EBP could save 4B only.
#	So that would causes 'segfault' when you want to using (%EBP) to access memory unit.

.global _start

	_start:



		#	Test part

		movq	$0xFFFF,%RAX
		movq	$0xFFFF,%RBX
		movq	$0xFFFF,%RCX
		movq	$0xFFFF,%RDX

		#	These registers would be using in function _Show_Str.


		
		#	Push parameters to call 'Show_Str'.	push and pop
		
		pushq	$MSG		#	Address
		pushq	$0x10		#	16

		nop
		nop

		callq _Show_Str		#	Call function _Show_Str

		nop
		nop


	EXIT:
		movl	$0x1,%EAX	#	sys_exit
		movq	$0x0,%RBX	#	To zero.
		popq	%RBX		#	Result of _Show_Str to returned.

		int	$0x80		#	Soft interrupt.





	.type _Show_Str,@function		#	Notice to GAS that at there is defining a function 'Show_Str',now.
	_Show_Str:

		#	Function content.

		/*
			Function : Show_Str ;
			Parameter : An address of a Message string.Save the address(32bot) and its length(8bit) in Stack.	(Address,Length)
			Result : Number of result(8bit) will be saving in stack.
		*/

		Env_of_Show_Str:		#	Set enviornment for function.
		
			pushq	%RBP		#	push value in EBP to stack,size is 32bit.	ESP+=4
			movq	%RSP,%RBP	#	EBP=ESP
			
				#	Save cases of registers

			pushq	%RAX		#	Will be sending 0x1 to EAX
			pushq	%RBX		#	will be sending 0x1 to EBX	stdout
			pushq	%RCX		#	Will be sending address of String to ECX
			pushq	%RDX		#	Will be sending length of string to EDX

		Content_Show_Str:		#	Function working zone.

			movl	$0x4,%EAX		#	Write
			movl	24(%RBP),%ECX		#	Data buffer

			movl	$0x0,%EDX		#	To zero.
			movw	16(%RBP),%DX		#	Length

			int	$0x80			#	Soft interrupt.

		Return_Show_Str:			#	Return to caller.

			movq	$0x0,16(%RBP)		#	To zero.
			movq	%RAX,16(%RBP)		#	Save result in stack.
			movq	$0x0,24(%RBP)		#	Clear string address in the stack.

			#	Registers restore.

			popq	%RDX
			popq	%RCX
			popq	%RBX
			popq	%RAX
			popq	%RBP

			ret				#	Return caller.
			

			







