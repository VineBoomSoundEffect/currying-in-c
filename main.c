#include <stdio.h>
#include <stdlib.h>

typedef long long int INT;

extern void* (curry)(void *fptr, INT at, INT ac, ...);
extern void* (execute_curry)(void *fptr, INT at, INT not_ac, ...);

int add(int x, int y, int z){return x+y+z;}

int main(){
    //only works for one curry-execute_curry pair, so you cannot have curry(curry(...))
    int (*fptr)(int, int, int);
    fptr = &add;
    void *p = curry(&add, 3, 1, 34);
    printf("%d\n",execute_curry(p, 3, 2, 35, 31));
    return 0;
}
