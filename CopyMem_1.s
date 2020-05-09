#	CopyMem_1.s
#	Version : 0.1
#	Date : 05-04-20
#	Last revise : 06-04-20
#	Description : Send value 1--8 from a part of memory to other part.
#
#	loop	Symbol		-	Cycle instruction.
#					Before jump to Symbol,it would decrease 1 for a value in %ECX.If that value is not less than 0,do jump.
#
#	Memory indrect accessing	-	section:displacement(base_reg,index_reg,scale)
#							'displacement' only is a value;
#							'scale' could is 1(default),2,4,8;
#							'base_reg' is a normally register with 32bit;
#							'index_reg' is a 32bit register too,it's general use EDI
#							'section' is a Segment-register.
#
#						Address=section*32(64)+base_reg+index_reg*scale+displacement.


#	Code :

.section .data		#	Segment data

	
	Array1:
		.int 0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08		#	Use a part of memory in segment .data to save some values.It as a array.
									#	.word = 16bit	.int = 32bit
	Array2:
		.int 0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0			#	Use other part of that segment as a array.

	#	Copy Array1 to Array2

.section .bss		#	Segment bss


.section .text		#	Segment text

.global _start		#	Entrence

	_start:


		movl	$Array1,%EBX		#	Assignment for EBX with address of Array1.
		movl	$0x0,%EAX		#	Set EAX is '0',it will as temp register.
		movl	$0x0,%EDI		#	Index register.
		movl	$Array2,%EBP		#	EBP save address of Array2.


/*
		If this part in process,then would receive a SIGSEGV.
		
		Linux is working in protect mode.Use Section/Page to manage physical memory.So Section registers were not save address of physical.
	They are save a section-number,then use that num to found linear-logic address from GDT(A section description table).And then use Page mapping to 
	acess physical memory address.So if you change that value in DS,real address would be resolving to other address,will get a SIGSEGV.

		movl	$Array1,%EAX
		movw	%AX,%DS
		movl	$Array2,%EAX
		movw	%AX,%ES
		movl	$0x0,%EDI
*/

		movw	$8,%CX			#	CX is a register for cycle count.




	
	CYCLE_COPY:
			
		#	AT&T memory quote syntax : 
		#				section:displacement(base,index,scale)	Register must add '%' front on name.
		#		'scale' default is 1,and it could be assignmented '1,2,4,8'.

		#	Real memory address is : section*32(or 64)+base+index*scale+displacement
		#	displacement is a offset for base.

		#	MOV can not use two for memory_quote at same time.
		
		movl	(%EBX,%EDI,1),%EAX	#	Send element in '%EBX+%EDI*2' to %AX
		movl	%EAX,(%EBP,%EDI,1)	#	Send element in %AX to '%EBP+%EDI*2'
		addl	$0x4,%EDI		#	BX+=2.	Update offset.
		loop	CYCLE_COPY


/*
		movw	(,%EDI,1),%AX		#	DS segment.
		movw	%AX,%ES:(,%EDI,1)	#	ES segment.
		addl	$0x2,%EDI
		loop	CYCLE_COPY
*/			

	EXIT:
	
		movl	$0x1,%EAX		#	sys_exit().
		movl	$0x0,%EBX		#	This value will return to os.		
		int	$0x80			#	Interrupt.


