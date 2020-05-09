#	Decimal_To_Char.s
#	Version : 0.1
#	Date : 12-04-20
#	Last revise : 12-04-20
#	Promise-Symbol : 
#			_start - Start pointer
#			XXX... - Normal symbol
#			_XX.._ - Function symbol
#
#	Description : 
#			Convert decimal data to string and show on the screen.
#			Convertion Expression : ASCII-Decimal=Decimal_value + 0x30 ;
#			Use remainder from division to get a decimal number which is a piece of the decimal-data.

.section .data

	DATA:
		.word 123,234,14,19,31,38

.section .bss

	.lcomm ENTER_OR_Div,1				#	Save \n
	.lcomm	Str_Buffer,100				#	100 Byte.

.section .text

.global _start

	_start:

		movl	$DATA,%EBX		#	Address of DATA
		movl	$0x0,%EBP		#	Index

		#	Use a cycle to convert these data.
		movw	$0x6,%CX

		CYCLE:

			movw	(%EBX,%EBP,0x2),%AX	#	Get decimal value.

			#	Call _Convertion_ .

			push	%AX		#	Parameter.

			call	_Convertion_	#	Call.

			pop	%AX		#	Recycle old parameter.
	
			incl	%EBP		#	EBP++.
			loop	CYCLE

		movw	$0x2,%CX		#	Twoce to show \n
		Add_Enter:
			
			push	%CX

			movl	$0x4,%EAX	#	sys_write
			movb	$0x0A,ENTER_OR_Div	#	\n
			movl	$ENTER_OR_Div,%ECX	#	Address
			movl	$0x1,%EBX		#	stdout.
			movl	$0x1,%EDX		#	Length	
			int	$0x80			#	Soft interrupt
		
			movl	$0x0,%ECX

			pop	%CX

			loop	Add_Enter

	EXIT:

		movl	$0x1,%EAX		#	sys_exit
		movl	$0x0,%EBX		#	return 0
		int	$0x80			#	Soft interrupt.


	#--------------------------#


	.type _Convertion_,@function		#	Define a function symbol.
	_Convertion_:
		/*
			'Convertion use stack to receive arguments.Only receive a parameter it is a decimal-data'address.That numbers must is a word-data.
		Arguments-list : (decimal_value).
		Return : None return anything,after parameter had been converted and then show result-string on the screen.
		Would affect registers : RBP,RAX,RCX,RBX,RDX.

		*/

		Env_Of_Convertion:		#	Complete for enviornmention.

			movb	$0x0A,ENTER_OR_Div	#	ENTER=0x0A

			pushq	%RBP		#	Push RBP to stack.		8B
			pushq	%RBX		#	Push RBX to stack.		8B
			pushq	%RAX		#	Push RAX to stack.		8B
			pushq	%RCX		#	Push RCX to stack.		8B
			pushq	%RDX		#	Push RDX to stack.		8B
			movq	%RSP,%RBP	#	RBP=%RSP.

		Work_Zone_Convertion:		#	Convertion working zone.

			movq	$0x0,%RCX	#	RCX to zero.
			movw	48(%RBP),%CX	#	Get A.
#			subw	$0x1,%CX	#	A-=1

			movq	$0x0,%RBX	#	To zero.

			movb	ENTER_OR_Div,%DL	#	DL=0x0A
			
			Convertion_Division:	#	There is cycle entrance.

							#	Record.	
				incb	%BH		#	Hight 8bit save length of string.
				decq	%RBP		#	RBP-=1.		To after 1B.
				
				movq	$0x0,%RAX	#	RAX to zero.	
				movw	%CX,%AX		#	AX save A.
#				incw	%AX		#	AX+=1.	Because loop would do subtraction for CX.
				div	%DL		#	A/10
			
				addb	$0x30,%AH	#	Remainder+0x30=ASCII-Char.
				movb	%AH,%BL		#	BL save ASCII value.
				movb	%BL,(%RBP)	#	Save ASCII value to stack.

				movl	$0x0,%ECX	#	ECX to zero.
				movb	%AL,%CL		#	Update CX

				jecxz	Show_String	#	ECX == 0 End.
				incb	%CL		#	Because loop would subtracte one to CX.When quotient is equal 1,then cycle will break.
				loop	Convertion_Division	#	Cycle.

			Show_String:

				decq	%RBP			#	RBP-=1.
				movb	%DL,(%RBP)		#	Send '\n' to memory.
				incb	%BH			#	BH++.
			
				movq	$0x0,%RDX		#	EDX to zero.
				movb	%BH,%BL			#	Length byte
				movb	$0x0,%BH		#
				movw	%BX,%DX			#	Save length parameter in DX.

				movw	%BX,%CX			#	Data length
				movl	$Str_Buffer,%EBX	#	Buffer address.

				Copy_Data_To_Buffer:

					movb	(%RBP),%AL	#	A char
					movb	%AL,(%EBX)	#	Copy
					
					incq	%RBP		#	Update pointer
					incl	%EBX		
	
					loop	Copy_Data_To_Buffer

			
				movl	$0x4,%EAX		#	sys_write
				movl	$Str_Buffer,%ECX	#	Address
				movl	$0x1,%EBX		#	stdout
	
				#	Size of string had been saved in RDX.

				int	$0x80			#	Soft interrupt.

		Return_Convertion:		#	Restore affected registers and return to caller.

				
				#	Restore registers.
			
				popq	%RDX	
				popq	%RCX
				popq	%RAX
				popq	%RBX
				popq	%RBP	
			
				#	Return

				ret



	#-------------------------#
