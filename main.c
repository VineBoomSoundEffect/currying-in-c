#include <stdio.h>
#include <stdlib.h>

typedef long long int INT;

extern void* (curry)(void *fptr, INT at, INT ac, ...);
extern void* (execute_curry)(void *fptr, INT at, INT not_ac, ...);

int add(int x, int y){return x+y;}

int main(){
    int (*fptr)(int, int);
    fptr = &add;
    void *p = curry(&add, 2, 1, 34);
    printf("%d\n", p);
    //execute_curry(fptr2, 1, 1, (int)69);
    printf("%d\n",execute_curry(p, 2, 1, 35));
    return 0;
}
//f(a,b,c)
//g = curry(f, 1, a)
//g(b,c)

//void * converts to anything automatically i think?
