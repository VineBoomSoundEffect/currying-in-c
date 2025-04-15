#include <stdio.h>
#include <stdlib.h>

typedef long long int INT;

extern void* (curry)(void *fptr, INT i);

INT I(INT x){return x;}

int main(){
    INT (*fptr)(INT);
    fptr = &I;
    INT (*fptr2)(INT);
    fptr2 = curry(fptr, 0);
    printf("%d",fptr2(45));
    return 0;
}
//f(a,b,c)
//g = curry(f, 1, a)
//g(b,c)
//sdjkflsdfjdlskfjls
//void * converts to anything automatically i think?
