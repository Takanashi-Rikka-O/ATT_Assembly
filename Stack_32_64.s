#	Stack_32_64
#	Version : 0.1
#	Date : 10-04-20
#	Last revise : 10-04-20
#	Description : 
#			Test for 'push -and pop' in the envrionmention '32bit' and '64bit'.Over test will write infomation of them in there.
#
#	In 32bit mode : push could adding suffix 'w'-word and 'l'-double word.
#
#	In 64bit mode : push could adding suffix 'q'-quad word(four word value),but could not use 'w -and l'.
#
#		32bit : 
#			Non-Suffix - push : 8B/unit , pop : 8B/unit . Registers : pop - EAX,EBX.
#			Suffix-'w' - pushw : 2B/unit , popw : 2B/unit . Registers : popw - AX,BX.
#			Suffix-'l' - pushl : 8B/unit , popl : 8B/unit . Registers : popl - EAX,EBX.
#
#				'l - double word' but it is 8B(4W)/unit ,somewhere propably have errors.
#				If the operand of 'pushl -and popl' is not a 2W object,then they would use 8B(4W)/unit.This is why the suffix is 'l' but
#			'push -and pop' use 8B as an unit.
#
#		64bit :
#			Non-Suffix - push : 8B/unit , pop : 8B/unit . Registers : pop - RAX,RBX.
#			Non-Suffix - push : 8B/unit , pop : 2B/unit . Registers : pop - AX,BX.	(Error,failed to call 'sys_exit'. RAX=RBX=0)
#			Suffix-'q' - pushq : 8B/unit, popq : 8B/unit . Registers : popq - RAX,RBX.
#
#
#	To sum it up, size for operands of 'push -and pop' must is as same.
#


.section .data

.section .bss

.section .text


#	32bit

#/*

#	'.code32' notice to gas use 32bit mode.
.code32

#*/

#	64bit	--	Closed '.code32'.

.global _start

	_start:

	#	You must mark a break point at there to check 'RSP' in gdb.


	#	32bit
#/*
		pushl	$0x00000001		#	sys_exit
		pushl	$0x00000000		#	return 0
#*/
	
	#	64bit

/*
		pushq	$0x1		#	sys_exit
		pushq	$0x0		#	return 0

*/

	#	You must mark a break point at there to check 'RSP' in gdb.

	EXIT:

	#	32bit

#/*

		popl	%EBX		#	return 0
		popl	%EAX		#	sys_exit

#*/

	#	64bit

/*
		popq	%RBX		#	return 0
		popq	%RAX		#	sys_exit
*/

	#	You must mark a break point at there to check 'RSP' in gdb.

		int	$0x80		#	Soft 

		
