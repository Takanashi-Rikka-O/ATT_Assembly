#	F_Div_Overflow.s
#	Version : 0.1
#	Date : 11-04-20
#	Last revise : 11-04-20
#	Promise-Symbol : 
#			_start - Start pointer.
#			XXX... - Normal lable.
#			_XXX._ - Function lable.
#
#	Description : 
#			When you want use a value is 32bit to do division with a value which is not 16bit,and then will occur 'division overflow'.
#		So must use a division method another to do div.
#
#		Thought : 
/*				A/B=C....D
			A have 32bit ; B have 16bit.

			H is hight 16bit of A ; L is lower 16bit of A.
			
			Quotient_H/B is a Quotient of H/B ; Remainder_H/B is a remainder of H/B.

			A/B=Quotient_H/B * 2^16 + ( Remainder_H/B * 2^16 + L )/B ;	2^16=65536.

		Calculate process : 
				I made up a miss in the calculate process.
			Expresion : A*65536 ;
			16bit Register could not save the value '65536'.It maxnum is '65535',so I had used 'A1=A*65535,A1+=A1' to instead 'A*65536'.But that is 
		a error.'A1+=A1 == A1*2',it is not right.The right calculation is 'A1+A'.This wrong had revised.(But I spent many times to check program,that's
		is a disaster!!!)

		Optimization of this program have not to did,until now.
*/


.section .data

.section .bss

	.equ V,65535

.section .text

.global _start

	_start:

		movq	$0x000F4240,%RDX
		movw	$0x000A,%CX

		pushq	%RDX		#	push	A
		push	%CX		#	push	B
					#	(A,B)

		#	Call _DIVOF_

		call	_DIVOF_

	EXIT:

		#	GDB check pointer.

		movl	$0x1,%EAX		#	sys_exit
		movl	$0x0,%EBX		#	return 0
		int	$0x80			#	Soft interrupt.


	#--------------------------#		#	Function zone.

	.type _DIVOF_,@function			#	Define a function '_DIVOF_'
	_DIVOF_:

		#	_DIVOF_ do an algorithm work that is as same as 'Description part'.
		#	Arguments : (A,B) [ Use stack to send parameters ]
		#	Result : Hight 16bit of Quotient would save in RDX,lower 16bit of Quotient  would save in RAX.
		#		Remainder would save in RCX. (So RAX and RDX and RCX would be overriding.)
		#	Registers would be using : RAX,RBX,RDX,RCX,RBP.

		Env_Of_DIVOF_:

			pushq	%RBX		#	push RBX 64bit
			pushq	%RBP		#	push RBP 64bit.
			movq	%RSP,%RBP	#	Use RBP to instead for RSP.

			movw	$V,%BX		#	%BX=2^16

		Work_Zone_DIVOF_:

			movw	24(%RBP),%CX	#	Get B.

			#	Calculate Quotient_H/B

			movw	28(%RBP),%AX	#	Get A hight 16bit H.
			movq	$0x0,%RDX
			div	%CX		#	AX -- Quotient, DX -- Remainder.

			#	Save Quotient_H/B and Remainder_H/B
		
			
			push	%AX		#	Save Quotient_H/B
			push	%DX		#	Save Remainder_H/B

			#	Calculate Quotient_H/B * 2^16

			mul	%BX		#	AX*2^16.

			#	Save DX and AX to stack. From mul 'Quotient_H/B * 2^16'

			push	%DX		#	Hight 16bit
			push	%AX		#	Lower 16bit

			movl	(%RSP),%EDX	#	EDX=%EDX+'Quotient_H/B'
			addl	6(%RSP),%EDX	
			movl	%EDX,(%RSP)

			#	Calculate Remainder_H/B * 2^16

			movw	4(%RSP),%AX	#	Get remainder of H/B
			mul	%BX		#	Remainder_H/B * 2^16

			#	Save DX and AX to stack. From mul 'Remainder_H/B * 2^16'

			movw	%DX,-2(%RSP)	#	Hight 16bit.
			movw	%AX,-4(%RSP)	#	Lower 16bit.
			movl	-4(%RSP),%EDX	#	EDX=%EDX+ 'Remainder_H/B'
			addl	4(%RSP),%EDX
			movl	%EDX,-4(%RSP)

			#	Get Remainder_H/B * 2^16 and then adding L

			movq	$0x0,%RAX	#	To zero.
			movq	$0x0,%RDX

			movl	-4(%RSP),%EAX	#	Get Result.
			movw	26(%RBP),%DX	#	Get L

			addl	%EDX,%EAX	#	EAX=%EAX+%EDX

			#	Save %EAX to stack

			movl	%EAX,-4(%RSP)	#	Override Remainder_H/B * 2^16

			#	Get Hight 16bit to DX
				
			movw	-2(%RSP),%DX	
			
			#	Get Lower 16bit to AX

			movw	-4(%RSP),%AX

			#	(Remainder_H/B * 2^16 + L)  /  B

			div	%CX

			#	Save result to stack and save remainder to CX

			movw	%AX,-4(%RSP)
			movw	%DX,%CX

			#	Quotient_H/B * 2^16 + (Remainder_H/B * 2^16 + L)/B
			
			movl	$0x0,%EAX
			movl	$0x0,%EDX

			movw	-4(%RSP),%AX		#	Quotient of '(Remainder_H/B * 2^16 + L)/B'
			movl	(%RSP),%EDX		#	Hight 16bit of 'Quotient_H/B * 2^16'
			addl	%EDX,%EAX

			pop	%DX		#	push	%AX
			pop	%DX		#	push	%DX
			pop	%DX		#	push	%DX
			pop	%DX		#	push	%AX
				#	RSP->RBP

			movl	%EAX,-4(%RBP)
			movw	-2(%RBP),%DX
			movw	-4(%RSP),%AX

			popq	%RBP		#	Restore.
			popq	%RBX		#	Restore.

			ret

	#--------------------------#

			
			

			

			

			

			

	













