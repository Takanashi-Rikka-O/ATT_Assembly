#	Info_Table_View.s
#	Version : 0.1
#	Date : 12-04-20
#	Last revise : 12-04-20
#	Description : 
/*
			Use infos to create a table.One field(Ne-Summ) is from division calculate.
		Table : Year(4Byte)	space(1Byte)	Summ(4Byte)	space(1Byte)	Ne(2Byte)	space(1Byte)	Ne-Summ(2Byte)	space(1Byte)

		All of line size is 16Byte.
		Year use string.
		Ne-Summ=Summ/Ne.
		
		I splited the data as three part.And also could do not split as pieces to operate them.That is Year as a part which is accessed by a symbol.
	And other data could use the method as same as Year part.
		After overed working,view table on the screen.

		And the splition is not beast in program,because that I did not align for memory with multiple of 16.
*/

.section .data

	#	Year.All 21 years.

	Year:
		.ascii "1975","1976","1977","1978","1979","1980","1981","1982","1983","1984","1985","1986","1987","1988","1989","1990","1991","1992","1993","1994","1995"	#	21*4 B

	#	Summ 21 years.

	Summ:
		.int 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514,345980,590827,803530,1183000,1843000,2759000,3753000,4649000,59370000
		#	21*4 B

	Ne:
		.word 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226,11542,14430,15257,17800	

.section .bss
	
	.lcomm Table,32		#	Table line
#	.lcomm ENTER,1		#	\n
#	.lcomm TempAddr,4	#	2B

.section .text

.global _start

	_start:

		leal	Table,%EBP			#	Use EBP to save address of Table.
		movl	$0x0,%EDI			#	Index data.
		movl	$0x0,%ESI			#	Index table.
		movw	$0x15,%CX			#	Counter.21

#		movl	$Create_Table_Cycle,TempAddr

	Create_Table_Cycle:

		push	%CX				#	Save CX

		#	Year

		movl	$Year,%EBX			#	Year address
		movl	(%EBX,%EDI,0x4),%EAX		#	EAX is temp register.
		movl	%EAX,(%EBP,%ESI,0x4)		#	Send string to table.
		addl	$0x4,%ESI			#	ESI+=4
		movb	$0x09,(%EBP,%ESI,0x1)		#	Adding a '\t'
		incl	%ESI				#	ESI++

		jmp	Summ_D				#	To Summ_D part

		Part1:		#	Midpoint

			jmp	Create_Table_Cycle	#	To cycle head

		#	Summ	Under on there,write 1B data once.
	
		Summ_D:

		movl	$Summ,%EBX			#	Summ
		movw	(%EBX,%EDI,0x4),%AX		#	Lower 16bit
		movw	2(%EBX,%EDI,0x4),%DX		#	Hight 16bit

		#	Call _Convert_		

		push	%DX	
		push	%AX

		movq	$0x0,%RAX		#	RAX to zero.
		movl	(%RSP),%EAX		#	32bit data save in 64bit register.
		pop	%DX
		pop	%DX

		pushq	%RAX			#	Push 8B

		call	_Convert_		#	Call _Convert_ , but the order of string is reverse.
		
		push	%CX			#	Length of string.

		#	Call _Reorder_		#	Change order of string

		call	_Reorder_		#	Call _Reorder_

		pop	%CX
		movq	%RSP,%RAX		#	Use RAX to accessing string address.

			Copy_To_Table1:		#	Copy the string to table.

				movb	(%RAX),%DL
				movb	%DL,(%EBP,%ESI,0x1)
			
				incl	%ESI	#	Index
				incq	%RAX	#	RAX point to stack.
				
				loop	Copy_To_Table1

		incl	%ESI
		movb	$0x09,(%EBP,%ESI,0x1)	#	Adding a '\t'
		incl	%ESI

		popq	%RAX		#	Throw invalid data in stack away.

		jmp	Ne_D		#	To Ne_D part

		Part2:		#	Midpoint

			jmp	Part1	#	Go to the previous


		#	Ne
		Ne_D:		

		movl	$Ne,%EBX			#	Ne
		movw	(%EBX,%EDI,0x2),%AX		#	Lower 16bit.
		movw	$0x0,%DX			#	Hight 16bit full 0.

		#	Call _Convert_

		push	%DX				#	Hight 16bit
		push	%AX				#	Lower 16bit

		movq	$0x0,%RAX		#	RAX to zero.
		movl	(%RSP),%EAX		#	32bit data save in 64bit registers
		pop	%DX
		pop	%DX
		
		pushq	%RAX			#	Push 8B

		call	_Convert_		#	Call _Convert_

		push	%CX			#	Length of string.

		#	Call _Reorder_

		call	_Reorder_		#	Sort string.

		pop	%CX

		movq	%RSP,%RAX		#	Use RAX to accessing string address.

			Copy_To_Table2:		#	Copy the string to table.

				movb	(%RAX),%DL
				movb	%DL,(%EBP,%ESI,0x1)
			
				incl	%ESI	#	Index
				incq	%RAX	#	RAX point to stack.

				loop	Copy_To_Table2

		incl	%ESI
		movb	$0x09,(%EBP,%ESI,0x1)
		incl	%ESI

		popq	%RAX		#	Throw invalid data in stack away.

		jmp	Summ_Ne		#	To Summ_Ne part

		Part3:		#	Midpoint
			
			jmp	Part2	#	Go to the previous
	
		#	Summ/Ne		This expression is could not overflow.
		Summ_Ne:

		movl	$Summ,%EBX	#	Get Summ address.
		movw	(%EBX,%EDI,0x4),%AX	#	Lower 16bit
		movw	2(%EBX,%EDI,0x4),%DX	#	Hight 16bit
						#	A

		movl	$Ne,%EBX
		movw	(%EBX,%EDI,0x2),%CX	#	B

		div	%CX		#	AX -- Quotient, DX -- Remainder.Does not need remainder.

		movw	$0x0,%DX	#	DX to zero.

		#	Call _Convert_

		push	%DX
		push	%AX

		movq	$0x0,%RAX	#	RAX to zero.
		movl	(%RSP),%EAX
		pop	%DX
		pop	%DX

		pushq	%RAX		#	Push 8B

		call	_Convert_

		#	Call _Reorder_

		push	%CX		#	Length of string

		call	_Reorder_	#	Call _Reorder_

		movq	$0x0,%RCX

		pop	%CX
		movq	%RSP,%RAX	#	Use RAX to accessing string address.

			Copy_To_Table3:

				movb	(%RAX),%DL
				movb	%DL,(%EBP,%ESI,0x1)
			
				incl	%ESI	
				incq	%RAX

				loop	Copy_To_Table3

		incl	%ESI
		movb	$0x0A,(%EBP,%ESI,0x1)		#	Adding a '\n'
		incl	%ESI				#	Recore length

		popq	%RAX		#	Throw invalid data in stack away.

		View_Record:

		movl	$0x4,%EAX	#	sys_write
		movl	$0x1,%EBX	#	stdout
		movl	%EBP,%ECX	#	record address
		movl	%ESI,%EDX	#	record length

		int	$0x80		#	Soft interrupt.

		movl	$0x0,%ESI	#	Index of Table
		movl	$0x4,%ECX	#	32B

		Table_Clear:		#	Clear old data in the table

			movq	$0x0,(%EBP,%ESI,0x8)	#	Once to full 8B
			incl	%ESI			#	ESI++

			loop	Table_Clear	#	Cycle
			
		movl	$0x0,%ESI	#	ESI to zero.
		incl	%EDI		#	EDI point to next.

		movl	$0x0,%ECX	#	ECX to zero.
		pop	%CX		#	Restore CX

		decw	%CX		#	CX--
		movw	$0x0,%AX	#	AX=0
		cmp	%AX,%CX		#	Compare CX and AX . Real work is CX-AX

		jne	Part3		#	Go to the previous.	Because loop jump scope is -128--127,so I use condition-jump to the rear part.

	EXIT:

		movl	$0x1,%EAX			#	sys_exit.
		movl	$0x0,%EBX			#	return 0.
		int	$0x80				#	Soft interrupt.

	#--------------------------#

	.type _Convert_,@function
	_Convert_:

		#	Value to string save in stack.
		#	Argument: (Value) 32bit - use 8B to save
		#	Return : None return,but save string in stack which had been converted.And CX would save length of that string.
		#	Use 32bit division.And the string is reverse order,you must use length to reorder for it.
		#	Would be using registers : RBP,RAX,RDX,RCX,RBX.

		Env_Convert_:

			pushq	%RBP		#	8B
			pushq	%RAX		#	8B
			pushq	%RBX		#	8B
			pushq	%RDX		#	8B

			movq	%RSP,%RBP	#	Use RBP to accessing Data space.
			addq	$0x28,%RBP	#	Data space address.
	
			#	Temp registers.

			movq	$0x0,%RBX
			movq	$0x0,%RAX
			movq	$0x0,%RCX
			movq	$0x0,%RDX

		Work_Zone_Convert_:

			movw	(%RBP),%AX	#	Get value lower 16bit
			movw	2(%RBP),%DX	#	Get value hight 16bit.

			Cycle_to_convertion:	#	Entrance

				#	BH record length.
				incb	%BL

				push	%DX		#	push hight 16bit
				push	%AX		#	push lower 16bit
				movw	$0x0A,%DX
				push	%DX		#	0x0A is 10,it is divise number.

				call	_Division_	#	None overflow division with 32bit / 16bit(8bit)
							#	After working overed, DX - Hight 16bit Quotient, AX - Lower 16bit Quotient, CX - Remainder.

				#	Convert remainder and send it to data space(Max_length = 8B).
				addb	$0x30,%CL	#	To ascii
				movb	%CL,(%RBP)	#	Send ascii to data space.
	
				pop	%CX		#	Throw invalid data.
				pop	%CX
				pop	%CX

				push	%DX
				push	%AX

				movl	(%RSP),%ECX	#	Counter update.

				pop	%AX		#	Restore RSP.
				pop	%DX

				incq	%RBP		#	RBP++

				jecxz	End_Convert_	#	ECX == 0,end.
				incl	%ECX		#	Because loop will make ECX--
				loop	Cycle_to_convertion	#	Cycle.

		End_Convert_:

				#	All work had been completed.Now stack save ascii string,CX save length of that string.

				movl	$0x0,%ECX
				movb	%BL,%CL		#	Length send to CX
			
		Return_Convert_:

				popq	%RDX		#	Restore registers
				popq	%RBX
				popq	%RAX
				popq	%RBP

				ret			#	Return to caller.


	#--------------------------#

	.type _Division_,@function
	_Division_:

		#	_Division_ use a value A(Maxbit=32bit) to do division with a value B(Maxbit=16bit).
		#	It could avoid overflow from division.
		#	Arguments-list : (A,B). Use stack to send parameters.
		#	Return : DX-Hight 16bit, AX-Lower 16bit, CX-Remainder.
		#	Registers would be using : RAX,RDX,RCX,RBP.
		#
		#	H - hight 16bit of A, L - lower 16bit of A.	Q_A/B : Quotient from A/B ; R_H/B : Remainder from A/B.
		#	Division Expression : A/B=Q_H/B * 2^16 + ( R_H/B * 2^16 + L )/B	;

		Env_Division_:		#	Complete enviornmention.

			#	Save RBP
			pushq	%RBP
		
			movq	%RSP,%RBP
			
			#	To zero.
			movq	$0x0,%RAX	
			movq	$0x0,%RCX
			movq	$0x0,%RDX

		Work_Zone_Division_:	#	Working zone

			#	Quotient=H/B

			movw	20(%RBP),%AX	#	Get hight 16bit of A
			movw	$0x0,%DX	#	Set DX to zero.

			divw	16(%RBP)	#	H/B.	Quotient in AX,Remainder in DX.
			
			push	%DX		#	Save Remainder
			push	%AX		#	Quotient of H/B

			#	Multipition Q_H/B * 2^16 - 1	2^16 : 0--65535
			
			movw	$65535,%DX	#	2^16 - 1
			mul	%DX		#	Q_H/B * 2^16 - 1 , DX - Hight 16bit, AX - Lower 16bit.

			push	%DX		#	push Hight 16bit
			push	%AX		#	push Lower 16bit

			movl	(%RSP),%ECX	#	Get 32bit product.

			#	Q_H/B * 2^16 - 1 + Q_H/B == Q_H/B * 2^16
			
			movl	$0x0,%EAX	#	EAX to zero.

			pop	%AX		#	Throw invalid data away.
			pop	%AX
			pop	%AX		#	Now Quotient_H/B in EAX.

			addl	%EAX,%ECX	#	ECX=Q_H/B * 2^16. And RSP-->Remainder_H/B
			movl	%ECX,-10(%RSP)	#	Save Result-1 in the stack.


			#	Remaind_H/B * 2^16

			pop	%AX		#	AX save that remainder.
			movw	%AX,-6(%RSP)	#	Save R_H/B in the stack.
			
			#	Multipition R_H/B * 2^16 - 1
			
			movw	$65535,%DX
			mul	%DX		#	DX - Hight 16bit, AX - Lower 16bit

			#	R_H/B * (2^16-1) + R_H/B == R_H/B * 2^16.

			push	%DX		#	Hight 16bit
			push	%AX		#	Lower 16bit

			movl	(%RSP),%EAX	#	product of R_H/B * 2^16.
			movl	$0x0,%EDX	#	EDX to zero.
			movw	-2(%RSP),%DX	#	Get R_H/B

			addl	%EDX,%EAX	#	R_H/B * 65535 + R_H/B.

			#	R_H/B * 2^16 + L

			pop	%DX		#	Throw data away which had been invalid.
			pop	%DX
			
			movw	18(%RBP),%DX	#	Get L
			addl	%EDX,%EAX	#	R_H/B*65535+L
			movl	%EAX,-4(%RSP)	#	Save Sum in stack.
			
			#	(R_H/B*2^16+L)/B

			movw	-2(%RSP),%DX	#	Hight 16bit
			movw	-4(%RSP),%AX	#	Lower 16bit

			divw	16(%RBP)	#	/B	DX - Remainder, AX - Quotient.

			#	Save remainder in %CX

			movl	$0x0,%ECX	#	CX to zero.
			movw	%DX,%CX		

			#	Add Result-1 Result-2
		
			push	%AX
			movl	$0x0,%EAX	#	Result-2
			pop	%AX
			
			movl	$0x0,%EDX	#	EDX save result-1
			movl	-12(%RSP),%EDX

			addl	%EDX,%EAX	#	EAX+EDX

			movl	%EAX,-4(%RSP)	#	Save 32bit data in stack.

			movw	-2(%RSP),%DX	#	DX save hight 16bit.
			movw	-4(%RSP),%AX	#	AX save lower 16bit.

		Return_Division_:	#	Restore registers and return to caller.

			popq	%RBP	#	Restore RBP.
			ret		#	Return to caller.

					#	Until to ther,	DX - Quotient_Hight-16bit, AX - Quotient_Lower-16bit, CX - Remainder.
			

	#--------------------------#

	.type _Reorder_,@function	#	Sort function
	_Reorder_:

		#	Resort string with right order.
		#	Arguments-list : (Str,Len)
		#	Return : None
		#	Registers would be using : RBP,RBX,RCX,RAX.

		Env_Reorder_:

			pushq	%RBP
			movq	%RSP,%RBP
			pushq	%RAX
			pushq	%RBX
			pushq	%RCX

		Work_Zone_Reorder_:

			movq	$0x0,%RCX	#	RCX to zero.
			movw	16(%RBP),%CX	#	Length.

			movq	$0x0,%RBX	#	RBX to zero.
			movw	%CX,%BX		#	Get length of string.

#			push	%CX		#	push CX

			movw	%CX,%AX		#	AX/2
			movb	$0x2,%CL	#	8bit
			div	%CL		#	AL quotient AH remainder.

			movl	$0x0,%ECX	#	CX to zero.
			movb	%AL,%CL		#	Get quotient.

			movq	$0x0,%RAX	#	RAX to zero.
			movq	%RBP,%RAX
			addq	$0x12,%RAX	#	RAX->Head
			movq	%RAX,%RBP	#	RBP->Head


			addq	%RBX,%RBP	#	RBP->End+1
			decq	%RBP		#	RBP->End

			movq	$0x0,%RBX

			Order_Cycle:

				jecxz	Return_Reorder_		#	If CX == 0,do nothing.

				movb	(%RAX),%BL	#	End start
				movb	(%RBP),%BH	#	Head start

				movb	%BH,(%RAX)	#	To head
				movb	%BL,(%RBP)	#	To end

				incq	%RAX
				decq	%RBP
					
				loop	Order_Cycle	#	Cycle

		Return_Reorder_:
		
#				pop	%CX

				popq	%RCX		#	Restore all registers.
				popq	%RBX
				popq	%RAX
				popq	%RBP

				ret			#	Return to caller.


	#--------------------------#
		


	
