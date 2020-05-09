//	Inline_asm.c
//	Version : 0.1
//	Date : 01-05-20
//	Last revise : 01-05-20
//	Symbol-Constraint : 
//				_Xx.._ - Function Symbol
//				Xx..|x|X - Variable Symbol
//	Description : 
//			Use the extend asm to calculating for an adding.

#include<stdio.h>
//#include<linux-module.h>

int main(void)
{
	unsigned int Value1=10,Value2=20;	//	4B unsigned int values.
	unsigned int Result=0;	//	Result to be saving.

	__asm__ volatile ("movl	%1,%%eax\n\t"		//	movl	Value1,%EAX
			"addl	%%eax,%2\n\t"		//	addl	%EAX,Result
			"movl	%2,%0\n\t"
			:"=r"(Result)			//	Output part.Output result to Result
			:"r"(Value1),"r"(Value2)	//	Input part.Value1 and Value2
			:"%eax"
		);
		//	0 -> Result
		//	1 -> Value1
		//	2 -> Value2
		
	/*	#APP
		# 19 "Inline_asm.c" 1
			movl	%edx,%eax
			addl	%eax,%ecx
			movl	%ecx,%edx
 	*/


	printf("Value1(%d) + Value2(%d) = %d\n",Value1,Value2,Result);
	return 0;
}
