#	CMD_Parameter.s
#	Version : 0.1
#	Date : 25-05-20
#	Last revise : 25-05-20
#	Symbol-Promise : 
#			_start - Start pointer
#			XXX... - Normaly symbol
#			_XX.._ - Function symbol
#
#	Description : Use gdb to checking command line parameters.

.section .data

.section .bss

	.lcomm str,36	#	Buffer
	.lcomm var,4	#	Temp variable.

.section .text
.global _start

		_start:

			#	64bit model,parameter size in the stack all is 8B,32bit is 4B.

			movq	%RSP,%RSI	#	RSI->Top
			movq	$str,%RDI	#	RDI->Buffer

			addq	$0x08,%RSI	#	RSI->Next
			movq	(%RSI),%RAX	#	Get string address
			movq	%RAX,%RSI

			movl	$0x10,%ECX	#	ECX=36

			rep movsb

			movq	$str,%RCX	#	RCX->Buffer



#			movq	%RSP,%RCX	#	RCX->TOP
#			addq	$0x08,%RCX	#	RCX+=0x08

#			movq	(%RCX),%RBX
#			movq	%RBX,%RCX			

			movl	$0x04,%EAX	#	sys_write
			movl	$0x01,%EBX	#	stdout
			movl	$0x10,%EDX	#	Length

			int	$0x80		#	Soft interrupt

		Show_result:

			movl	%EAX,var	#	var save result
			
			movl	$0x04,%EAX	#	sys_write
			movl	$0x01,%EBX	#	stdout
			leal	var,%ECX	#	RCX=&str
			movl	$0x04,%EDX	#	Length

			int	$0x80		#	Soft interrupt


		

		EXIT:
		
			movl	$0x1,%EAX	#	sys_exit
			movl	$0X0,%EBX	#	return 0
			int	$0x80		#	Soft interrupt
