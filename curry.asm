section .text
extern printf
extern malloc
extern free
extern testm
global curry
;curry (f, nrargs, arg1, arg2, ...)
;rcx = f
;rdx = nrargs
;r8 r9 stack... = arg1, arg2, ...
curry:
    enter 0,0
    ;adhering to ms_abi, it is our job to copy the registers into the shadow space if we so need
    ;i am going to do that, makes it easier for me
    mov [rbp+16],rcx ;[rbp+8] is skipped because that's where the return adress lies
    mov [rbp+24],rdx
    mov [rbp+32],r8
    mov [rbp+40],r9

    mov rax,16
    push qword[rbp+24]
find_size:
    cmp qword[rbp+24],0
    je end_find_size
    sub qword[rbp+24],1
    add rax,8
    jne find_size
end_find_size:
    pop qword[rbp+24]
    mov rcx,rax
    sub rsp,32
    call malloc

    mov rbx,[rbp+16]
    mov [rax],rbx
    mov rbx,[rbp+24]
    mov [rax+8],rbx
    mov rcx,0
    push qword[rbp+24]
put_in_heap:
    cmp qword[rbp+24],0
    je end_put_in_heap
    add rcx,8
    mov rbx,[rbp+24+rcx]
    mov [rax+8+rcx],rbx
    sub qword[rsp],1
    jne put_in_heap
end_put_in_heap:
    pop qword[rbp+24]
    mov rax,[rax]
    leave
    ret
section .data
str: db "%d",0
msg: db "hello world",0

;;after enter 0,0:
;bp - bp
;ret_addr +8
;args +16...
