#	Multi_Dimensional.s
#	Version : 0.1
#	Date : 06-04-20
#	Last revise : 06-04-20
#	Description : 
#			Switch case for strings.Use multi-dimensional-array abstract.

.section .data


	#	.ascii type,the memory place will save a string at there.A element in string size is 1Byte.
	#	.asciz type,as same as '.ascii',but this type will be adding a '\0' at end.

	Str1:
		.ascii "1. file "
	Str2:
		.ascii "2. kksk "
	Str3:
		.ascii "3. aapp "
	Str4:
		.ascii "4. apue "

	#	Remember that memory must is aligned with Multiple of 2.	0,2,4,8,16,32,...

	#	Abstract the strings as a four-dimensional-array.

	Mask:
		.byte 0xDF			#	Case switch mask. 11011111

.section .bss

.section .text

.global _start

	_start:

		#	Cycle is nested.Cycle1 respone lines,cycle2 respone cols.

		movl	$Str1,%EBX		#	Get array head address.(It is Str1)
		movw	$0x4,%CX		#	Cycle counter,lines 4,cols 4.

	Lines:

		#	Lines cycle

		push	%CX			#	Save counter for outside.
		movl	$0x0,%EDI		#	EDI save index for string elements.
		movw	$0x4,%CX		#	And now,CX is a counter for inside cycle.

	Cols:

		#	Cols cycle

		movb	3(%EBX,%EDI,1),%AL	#	Send a byte data to AL
		and	Mask,%AL		#	Mask & %AL,because old string all is lower case.
		movb	%AL,3(%EBX,%EDI,1)	#	Write new char to old byte.
		incl	%EDI			#	EDI++,next col
		loop	Cols			#	To head of Cols cyle

		addl	$0x8,%EBX		#	Next line.8 is multiple of 2.
		pop	%CX			#	Restore counter for outside cycle.
		loop	Lines			#	To Lines	
	
	EXIT:

		movl	$0x1,%EAX		#	sys_exit
		movl	$0x0,%EBX		#	return 0
		int	$0x80			#	Soft interrupt.

		
