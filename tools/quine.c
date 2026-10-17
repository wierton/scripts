#include<stdio.h>
int main()
{
char *c="#include<stdio.h>%cint main()%c{%cchar *c=%c%s%c;%cprintf(c,10,10,10,34,c,34,10,10,10);%c}%c";
printf(c,10,10,10,34,c,34,10,10,10);
}
