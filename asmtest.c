#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

int func(int a){
    printf("arg: %d\n", a);
    return a;
}

void caller(){
    //printf("arg func applied to 3:%d\n", fptr(3));
    printf("address of func:%d\n", &func);
}
