#	Letterc.s
#	Version : 0.1
#	Date : 13-04-20
#	Last revise : 13-04-20
#	Promise-Symbol : 
#			_start - Start point
#			XXX... - Normal symbol
#			_XX.._ - Function
#
#	Description : 
#			Define a Function to change the 'lower case character' to 'capital character'.Scope : a--z.The string use a '0' as end.

.section .data

	Message:
		.ascii "hello_world3"		#	A string
	End_M:
		.byte 0x0			#	End of string

.section .bss

.section .text

.global _start

	_start:

		movq	$0x0,%RBX		#	RBX to zero.
		movl	$Message,%EBX		#	Get Address of string.
		
		#	Call _Letterc_

		pushq	%RBX			#	push 8B.	But string in the segment .data,the max_length of address is 32bit.

		call	_Letterc_		#	Call _Letterc_

		popq	%RCX			#	Restore RSP.	_Letterc_ could not change address from RBX.So pop it to RCX.

	View_String:

		movl	$0x4,%EAX		#	sys_write
		movl	$0x1,%EBX		#	stdout
		movb	$0x0A,End_M		#	Continuous memory load.	So set End_M to save '\n'
		movl	$0x0D,%EDX		#	Length

		int	$0x80			#	Soft interrupt.
		
	EXIT:

		movl	$0x1,%EAX		#	sys_exit
		movl	$0x0,%EBX		#	return 0

		int	$0x80			#	Sof interrupt.

		











	.type _Letterc_,@function	#	Define a function '_Letterc_'
	_Letterc_:

		#	Change characters of a string as '0' as end to 'capital character'.	"*****0"
		#	Arguments-list : (Address_String) Use stack to send this address.(32bit)
		#	Return : None return.
		#	Registers would be affecting : RCX,RBP,RSI

		Env_Letterc_:
			
			pushq	%RBP
			movl	16(%RSP),%EBP	#	Use RBP to accessing string.	RBP->Address of string.

			pushq	%RCX		#	Store temporary registers.
			pushq	%RSI		#	

		Work_Zone_Letterc_:

			movq	$0x0,%RCX	#	RCX to zero.
			movl	$0x0,%ESI	#	ESI index to zero.

			#	First element.

			movb	(%EBP,%ESI,0x1),%CL	#	Use CL as a compare object.Optimization for memory access.

			Convert_Cycle_Letterc_:

					#	a 0x61, z 0x7A ;	No symbol subtrate.

					movb	$0x61,%CH		#	Hight 16bit.
					cmp	%CH,%CL			#	Check the element of string if is less than 0x61.
					jb	Is_not_in_a_z		#	CF=1.	E<0x61

					movb	$0x7A,%CH		#	Hight 16bit.
					cmp	%CL,%CH			#	It is equal or less than 0x7A 'z'.
					jb	Is_not_in_a_z		#	CF=1.	E>0x61
					
					Is_a_lower_char:		#	If it is a lower character.

						andb	$0B11011111,(%EBP,%ESI,0x1)	#	To capital.
						#subb	$0x20,(%EBP,%ESI,0x1)

					Is_not_in_a_z:			#	This element is not in a--z.
						
						incl	%ESI		#	Pointer ++

						movw	$0x0,%CX	#	CX to zero.

						movb	(%EBP,%ESI,0x1),%CL	#	Get next in cx as counter.
						incb	%CL			#	Loop will do subtrate for CX.

						loop	Convert_Cycle_Letterc_	#	To entrance of cycle.

		Return_Letterc_:

			popq	%RSI	#	Restore temporary registers.
			popq	%RCX
			popq	%RBP

			ret

	#--------------------------#		


