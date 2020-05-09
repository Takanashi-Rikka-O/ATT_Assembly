#	Read_File_And_Convert_Char.s
#	Version : 0.1
#	Date : 27-04-20
#	Last revise : 27-04-20
#	Symbol-Constraint :
#				_start - Start point
#				X/x... - Normaly symbol
#				_X/x._ - Function symbol
#
#
#	Description : 
#			Read a file the name of it from command-line.And then open that file convert to it.
#
#	Functions : 
#		_Cycle_To_Read_		//	Features as its name as.
#		_Convert_Character_	//	Features as its name as.
#		_Error_Messages_	//	Output error messages.
#		_Strlen_		//	Scan string and get length.
#
#

.section .data

	Str_Error1:
		.ascii "Failed to open file !\n"		#	Error string 1.
	Str_Error1_Len:
		.byte . - Str_Error1					#	Length of error-string-1.

	Str_Error2:
		.ascii "Failed to close file !\n"		#	Error string 2.
	Str_Error2_Len:
		.byte . - Str_Error2					#	Length of error-string-2.

	Str_Error3:
		.ascii "Command-Line parameter errored !\n"	#	Error string 2.
	Str_Error3_Len:	
		.byte . - Str_Error3					#	Length of error-string-3.

	#	The stack frame of environment one of the units length is 8B

.section .bss

	.lcomm File_Buffer,1024		#	1KB buffer for file data.
	.lcomm File_Name,32		#	File Name buffer.
	.lcomm FileDes,4		#	4B file descriptor.

	.equ Head_a,0x61		#	ASCII Value a
	.equ End_z,0x7A			#	ASCII Value z
	.equ Convertion_Mask,0B11011111	#	Mask 'a' to 'A'

.section .text

#.code64

.global _start

		_start:

			movq	%RSP,%RBP	#	Use RBP as Stack indirectly accessing pointer.

		Check_Arguments:

				movl	(%RBP),%EAX	#	Get number of arguments.
				
				#	Check
				cmp	$0x02,%EAX	#	Compare EAX and $0x2, if EAX != 2,exit.
				jne	Error_3

		Open_File:	#	O_RDWR = 02 , open() = 0x05

			addq	$0x10,%RBP	#	RBP->File-Name
			movq	(%RBP),%RBX	#	The first parameter pointer.
			
			#	Get length of File Name
			call	_Strlen_	#	Call _Strlen_

			movl	$0x00,%ECX	#	ECX=0

			movb	%AL,%CL		#	The AL saved string'length.
			movq	%RBX,%RSI	#	Implicated source.
			leal	File_Name,%EDI	#	Implicated destination.

			cld			#	DF=0

			rep movsb		#	Copy File name to the buffer File_Name.
			
			#	Open File
			movl	$0x05,%EAX		#	open()
			movl	$File_Name,%EBX		#	Path
			movl	$02,%ECX		#	O_RDWR
			int	$0x80			#	system call

			#	Check whether succeed to open file.
			movl	%EAX,FileDes		#	Get File Descripter.
			cmpl	$0x2,FileDes	#	If FileDes == -1,failed to open file.
			jl	Error_1			#	Open file failed.

			#	Otherwise call function '_Cycle_To_Read_'
			call	_Cycle_To_Read_		#	Set up for converted work.
			
		Close_File:	#	close() = 0x06	failed return -1,succeed return 0.

			movl	$0x06,%EAX		#	close()
			movl	FileDes,%EBX		#	Would to closed file descriptor.
			int	$0x80			#	Soft interrupt

			#	Check whether succeed to close file.
			cmp	$0x00,%EAX
			jne	Error_2

			movl	$0X0,%EBX		#	Succeed.
			jmp	EXIT			#	Jump to EXIT.


		Error_1:
		
			push	$0x01			#	Push NO.1 error code.	8B
			call	_Error_Messages_	#	Call _Error_Messages_
			addq	$0x08,%RSP		#	Jump across to 0x01.
		
			movl	$0x01,%EBX		#	return1
			jmp	EXIT

		Error_2:
			
			push	$0x02			#	Push NO.2 error code.	8B
			call	_Error_Messages_	#	Call _Error_Messages_
			addq	$0x08,%RSP		#	Jump across to 0x02.

			movl	$0x01,%EBX		#	return 1
			jmp	EXIT
		
		Error_3:	#	Command line parameter failed.

			push	$0x03			#	Push NO.3 error code.	8B
			call	_Error_Messages_	#	Call _Error_Messages_
			addq	$0x08,%RSP		#	Jump across to 0x03.
			
			movl	$0x01,%EBX		#	return 1
			jmp	EXIT

		EXIT:
		
			movl	$0x1,%EAX		#	sys_exit
			int	$0x80			#	Soft interrupt



		#------------------------------#

		.type _Cycle_To_Read_,@function
		_Cycle_To_Read_:
			#	Arguments : Saved the file descriptor in the variable FileDes.
			#	Return : None
			#	Would be used registers : RAX,RBX,RCX,RDX

			_Env_Of_Cycle_To_Read_:

				pushq	%RAX	#	Temporary register
				pushq	%RBX	#	Temporary register
				pushq	%RCX	#	Temporary register
				pushq	%RDX	#	Temporary register

				movq	$0x00,%RAX	#	Clear
				movq	$0x00,%RBX
				movq	$0x00,%RCX
				movq	$0x00,%RDX

			_Work_Zone_Cycle_To_Read_:
				
				#	read() = 0x3, if missed a EOF,return -1.
						
				movl	FileDes,%EBX		#	File descriptor.
				leal	File_Buffer,%ECX	#	File buffer.
				movl	$0x0200,%EDX		#	1024.

				Cycle_Read:
				
					movl	$0x03,%EAX	#	read()
					int	$0x80		#	Soft interrupt.
					
					#	Check status
					cmp	$0x00,%EAX	#	EAX > 0
					ja	Not_EOF_Or_Error	#	Jump to do work
					jmp	_Return_Cycle_To_Read_	#	EOF or Nothing data had been readed.

					Not_EOF_Or_Error:

						call	_Convert_Character_	#	Call _Convert_Character_

					To_Cycle_Read_Head:

						jmp	Cycle_Read		#	Cycle.

			_Return_Cycle_To_Read_:

				popq	%RDX	#	Restore registers.
				popq	%RCX
				popq	%RBX
				popq	%RAX

				ret		#	Return
				
		#------------------------------#

		.type _Convert_Character_,@function
		_Convert_Character_:

			#	Arguments : Save the realy to readed length of data in the EAX.
			#	Return : None.
			#	Would be used registers : RAX,RBX,RCX,RDX,RSI

			_Env_Of_Convert_Character_:

				pushq	%RAX	#	Temporary register
				pushq	%RBX	#	Temporary register
				pushq	%RCX	#	Temporary register
				pushq	%RDX	#	Temporary register
				pushq	%RSI	#	Temporary register

				movq	$0x00,%RBX	
				movq	$0x00,%RCX
				movq	$0x00,%RDX
				movq	$0x00,%RSI

			_Work_Zone_Convert_Character_:

				movl	%EAX,%ECX	#	EAX saved the length of data.
				leal	File_Buffer,%EBX	#	EBX->File_Buffer
				
				Cycle_To_Convert:
					
					#	Check the char in 'a'--'z'.

					movb	(%EBX,%ESI,0x1),%DL		#	Send data to AL

					Greater_a:

						cmp	$Head_a,%DL			#	Data - 'a'
						jb	To_Cycle_Convert_Head		#	less than 'a'

					Less_z:

						cmp	$End_z,%DL			#	Data - 'z'
						ja	To_Cycle_Convert_Head		#	greater than 'z'

						#	None signed, jb < , ja >
						#	Signed,jl < , jg >

					Converting:
			
						and	$Convertion_Mask,%DL		#	Convertion.	
						movb	%DL,(%EBX,%ESI,0x1)		#	restore

					To_Cycle_Convert_Head:
						
						incl	%ESI	#	ESI++
						loop	Cycle_To_Convert	#	Cycle

				Set_Offset:	#	SEEK_CUR = 1.

						notl	%EAX		#	EAX~=%EAX
						addl	$0x01,%EAX	#	EAX = -EAX
						
						#	Call lseek 0x19 to set new offset up.

						movl	%EAX,%ECX	#	ECX=-Realy_Readed
						movl	FileDes,%EBX	#	File descriptor
						movl	$0x01,%EDX	#	whence=SEEK_CUR
						movl	$0x13,%EAX	#	lseek()

						int	$0x80		#	Soft interrupt

				Write_To_File:

					movl	$0x04,%EAX	#	write()
					movl	FileDes,%EBX	#	EBX->File
					leal	File_Buffer,%ECX	#	File_Buffer address
					movl	$0x0200,%EDX	#	1024
					int	$0x80

			_Return_Zone_Convert_Character_:
		
					popq	%RSI		#	Registers restore.
					popq	%RDX
					popq	%RCX
					popq	%RBX
					popq	%RAX

					ret			#	Return
					
			
					

		#------------------------------#

		.type _Strlen_,@function
		_Strlen_:	#	NULL - 0X00

			#	Arguments : RBX saved the address of string which would be scanning.
			#	Return : The normaly register AL saved the length of string.
			#	Would be used registers : %RSI

			_Env_Strlen_:

				pushq	%RSI	#	Temporary register

				movb	$0x00,%AL	#	Clear
				movl	$0x00,%ESI

			_Work_Zone_Strlen_:

				Scan_Cycle:

					incb	%AL	#	AL++
					cmp	$0x00,(%RBX,%RSI,0x01)	#	Compare
									#	64bit indirectly addressing,all registers use 64bit normaly register.
					je	_Return_Zone_Strlen_

					#	Otherwise
					incq	%RSI	#	RSI++
					jmp	Scan_Cycle	#	Continue

			_Return_Zone_Strlen_:
	
				popq	%RSI	#	Register restore.
			
				ret		#	return
	
		#------------------------------#

		.type _Error_Messages_,@function
		_Error_Messages_:

			#	Arguments : (Code_Number),Stack to send order is right to left.
			#	Return : None.
			#	Would be used registers : RAX,RBX,RCX,RDX,RBP
			
			_Env_Of_Error_Messages_:

				pushq	%RBP		#	Temporary register

				movq	%RSP,%RBP	#	RBP->TOP

				pushq	%RAX		#	Temporary register
				pushq	%RBX		#	Temporary register
				pushq	%RCX		#	Temporary register
				pushq	%RDX		#	Temporary register

				movq	$0x00,%RDX	#	RDX to zero.

				movq	16(%RBP),%RAX	#	Code in RAX

			_Work_Zone_Error_Messages_:

				cmpb	$0x1,%AL	#	1byte compare.
				je	Code_1
				
				cmpb	$0x02,%AL
				je	Code_2
				
				cmpb	$0x03,%AL
				je	Code_3
				
				Code_1:
				
					leal	Str_Error1,%ECX		#	Error message 1
					movb	Str_Error1_Len,%DL
				
					jmp	Output
			
				Code_2:

					leal	Str_Error2,%ECX		#	Error message 2
					movb	Str_Error2_Len,%DL
				
					jmp	Output

				Code_3:

					leal	Str_Error3,%ECX		#	Error message 3
					movb	Str_Error3_Len,%DL
		
				Output:

					movl	$0x04,%EAX	#	write()
					movl	$0x01,%EBX	#	stdout
		
					int	$0x80		#	Soft interrupt

			_Return_Zone_Error_Messages_:

					popq	%RDX	#	Registers restore.
					popq	%RCX
					popq	%RBX
					popq	%RAX
					popq	%RBP

					ret		#	return

		#------------------------------#



