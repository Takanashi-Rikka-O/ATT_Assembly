#	Info_Table.s
#	Version : 0.1
#	Date : 08-04-20
#	Last revise : 08-04-20
#	Description : 
/*
			Use infos to create a table.One field(Ne-Summ) is from division calculate.
		Table : Year(4Byte)	space(1Byte)	Summ(4Byte)	space(1Byte)	Ne(2Byte)	space(1Byte)	Ne-Summ(2Byte)	space(1Byte)

		All of line size is 16Byte.
		Year use string.
		Ne-Summ=Summ/Ne.
		
		I splited the data as three part.And also could do not split as pieces to operate them.That is Year as a part which is accessed by a symbol.
	And other data could use the method as same as Year part.

		And the splition is not beast in program,because that I did not align for memory with multiple of 16.

*/

.section .data

	#	Year.All 21 years.

	Year1:
		.ascii "1975","1976","1977","1978","1979","1980","1981","1982","1983"		#	36B
	Year2:
		.ascii "1984","1985","1986","1987","1988","1989","1990","1991","1992"		#	36B
	Year3:	
		.ascii "1993","1994","1995"							#	12B

	#	Summ 21 years.

	Summ1:
		.int 16,22,382,1356,2390,8000,16000,24486,50065					#	36B
	Summ2:
		.int 97479,140417,197514,345980,590827,803530,1183000,1843000,2759000		#	36B
	Summ3:
		.int 3753000,4649000,593700							#	12B

	#	Ne 21 years.

	Ne1:
		.word 3,7,9,13,28,38,130,220,476						#	18B
	Ne2:
		.word 778,1001,1442,2258,2793,4037,5635,8226,11542				#	18B
	Ne3:
		.word 14430,15257,17800							#	6B

.section .bss
	
	.lcomm Table,336	#	Table memory. 21*16B

.section .text

.global _start

	_start:

		leal	Table,%EBP			#	Use EBP to save address of Table.
		movl	$0x0,%EDI			#	Index data.
		movl	$0x0,%ESI			#	Index table.
		movb	$9,%CL				#	Counter.
	
	CYCLE1:

		#	This cycle frequency is 9.	1975--1983

	#	String

		leal	Year1,%EBX			#	Year1 address.
		movl	(%EBX,%EDI,0x4),%EAX		#	Send string to EAX.	4B
		movl	%EAX,(%EBP,%ESI,0x4)		#	Send string to Table.
		incl	%ESI				#	ESI++

	#	Summ

		leal	Summ1,%EBX			#	Summ1 address.
		movl	(%EBX,%EDI,0x4),%EAX		#	Send number to EAX	4B
		movb	$0xFF,(%EBP,%ESI,0x4)		#	Full FF as sapce.
		movl	%EAX,1(%EBP,%ESI,0x4)		#	Send summ to Table.
		incl	%ESI				#	ESI++
		
	#	Ne

		leal	Ne1,%EBX			#	Ne1 address.
		movw	(%EBX,%EDI,0x2),%AX		#	Send number to AX.	2B
		movb	$0xFF,1(%EBP,%ESI,0x4)		#	Full FF as sapce.
		movw	%AX,2(%EBP,%ESI,0x4)		#	Send number to Table.
		incl	%ESI				#	ESI++

	#	Summ/Ne		32bit/16bit
		
		#	A

		leal	Summ1,%EBX			#	Summ1 address.
		movw	(%EBX,%EDI,0x4),%AX		#	Lower 16bit.
		movw	2(%EBX,%EDI,0x4),%DX		#	Hight 16bit.

		#	B

		leal	Ne1,%EBX			#	Ne1 address.
		movw	(%EBX,%EDI,0x2),%BX		#	Save B in BX.
		div	%BX				#	Division.

		#	C

		movw	%AX,1(%EBP,%ESI,0x4)		#	Send result to Table.
		movb	$0xFF,3(%EBP,%ESI,0x4)		#	Full FF as sapce.

	#	Update counters.

		incl	%EDI				#	EDI++
		movl	$0x0,%ESI			#	Return to zero.
		addl	$0x10,%EBP			#	Table+=16.
		
		loop	CYCLE1
		
	#	----------------------------------	#	

	#	Counters reset.		

		movl	$0x0,%EDI			#	Index data.
		movl	$0x0,%ESI			#	Index table.
		movb	$9,%CL				#	Counter.


	CYCLE2:
	
		#	This cycle frequency is 9.	1984--1992

	#	String

		leal	Year2,%EBX			#	Year2 address.
		movl	(%EBX,%EDI,0x4),%EAX		#	Send string to EAX.	4B
		movl	%EAX,(%EBP,%ESI,0x4)		#	Send string to Table.
		incl	%ESI				#	ESI++

	#	Summ

		leal	Summ2,%EBX			#	Summ2 address.
		movl	(%EBX,%EDI,0x4),%EAX		#	Send number to EAX	4B
		movb	$0xFF,(%EBP,%ESI,0x4)		#	Full a FF as sapce.
		movl	%EAX,1(%EBP,%ESI,0x4)		#	Send summ to Table.
		incl	%ESI				#	ESI++
		
	#	Ne

		leal	Ne2,%EBX			#	Ne2 address.
		movw	(%EBX,%EDI,0x2),%AX		#	Send number to AX.	2B
		movb	$0xFF,1(%EBP,%ESI,0x4)		#	Full FF as sapce.
		movw	%AX,2(%EBP,%ESI,0x4)		#	Send number to Table.
		incl	%ESI				#	ESI++

	#	Summ/Ne		32bit/16bit
		
		#	A

		leal	Summ2,%EBX			#	Summ2 address.
		movw	(%EBX,%EDI,0x4),%AX		#	Lower 16bit.
		movw	2(%EBX,%EDI,0x4),%DX		#	Hight 16bit.

		#	B

		leal	Ne2,%EBX			#	Ne2 address.
		movw	(%EBX,%EDI,0x2),%BX		#	Save B in BX
		div	%BX				#	Division.

		#	C

		movw	%AX,1(%EBP,%ESI,0x4)		#	Send result to Table.
		movb	$0xFF,3(%EBP,%ESI,0x4)		#	Full FF as sapce.

	#	Update counters.

		incl	%EDI				#	EDI++
		movl	$0x0,%ESI			#	Return to zero.
		addl	$0x10,%EBP			#	Table+=16.
		
		loop	CYCLE2

		
	#	----------------------------------	#	

	#	Counters reset.		

		movl	$0x0,%EDI			#	Index data.
		movl	$0x0,%ESI			#	Index table.
		movb	$3,%CL				#	Counter.

	CYCLE3:

		#	This cycle frequency is 3.	1993--1995

	#	String

		leal	Year3,%EBX			#	Year3 address.
		movl	(%EBX,%EDI,0x4),%EAX		#	Send string to EAX.	4B
		movl	%EAX,(%EBP,%ESI,0x4)		#	Send string to Table.
		incl	%ESI				#	ESI++

	#	Summ

		leal	Summ3,%EBX			#	Summ3 address.
		movl	(%EBX,%EDI,0x4),%EAX		#	Send number to EAX	4B
		movb	$0xFF,(%EBP,%ESI,0x4)		#	Full FF as sapce.
		movl	%EAX,1(%EBP,%ESI,0x4)		#	Send summ to Table.
		incl	%ESI				#	ESI++
		
	#	Ne

		leal	Ne3,%EBX			#	Ne3 address.
		movw	(%EBX,%EDI,0x2),%AX		#	Send number to AX.	2B
		movb	$0xFF,1(%EBP,%ESI,0x4)		#	Full FF as sapce.
		movw	%AX,2(%EBP,%ESI,0x4)		#	Send number to Table.
		incl	%ESI				#	ESI++

	#	Summ/Ne		32bit/16bit
		
		#	A

		leal	Summ3,%EBX			#	Summ3 address.
		movw	(%EBX,%EDI,0x4),%AX		#	Lower 16bit.
		movw	2(%EBX,%EDI,0x4),%DX		#	Hight 16bit.

		#	B

		leal	Ne3,%EBX			#	Ne3 address.
		movw	(%EBX,%EDI,0x2),%BX		#	Save B in BX
		div	%BX				#	Division.

		#	C

		movw	%AX,1(%EBP,%ESI,0x4)		#	Send result to Table.
		movb	$0xFF,3(%EBP,%ESI,0x4)		#	Full FF as sapce.

	#	Update counters.

		incl	%EDI				#	EDI++
		movl	$0x0,%ESI			#	Return to zero.
		addl	$0x10,%EBP			#	Table+=16.
		
		loop	CYCLE3


	EXIT:

		movl	$0x1,%EAX			#	sys_exit.
		movl	$0x0,%EBX			#	return 0.
		int	$0x80				#	Soft interrupt.
