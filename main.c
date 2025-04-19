#include <stdio.h>
#include <stdlib.h>

typedef long long int INT;

extern void* (curry)(void *fptr, INT at, INT ac, ...);
extern void* (execute_curry)(void *fptr, INT at, INT not_ac, ...);

INT I(INT x){return x+1;}

int main(){
    INT (*fptr)(INT);
    fptr = &I;
    void *fptr2 = curry(fptr, 1, 1, (INT)69/*, (INT)69, (INT)69*/);
    //execute_curry(fptr2, 1, 1);
    printf("%d",execute_curry(fptr2, 1, 0));
    return 0;
}
//f(a,b,c)
//g = curry(f, 1, a)
//g(b,c)

//void * converts to anything automatically i think?
