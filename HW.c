#include<stdio.h>

void HELLO_WORLD(const char* STR);

int main(void)
{

	const char* Str="Hellow World.";

	HELLO_WORLD(Str);

	return 0;
}

void HELLO_WORLD(const char* STR)
{
	printf("%s\n",STR);
}
