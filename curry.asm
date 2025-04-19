section .text
extern printf
extern malloc
extern free
extern testm
global curry
global execute_curry
;curry (f, nrargs, arg1, arg2, ...)
;rcx = f
;rdx = nrargs
;r8 = nargs_to_be_curried
;r9 stack... = arg1, arg2, ...
curry:
    enter 0,0
    ;adhering to ms_abi, it is our job to copy the registers into the shadow space if we so need
    ;i am going to do that, makes it easier for me
    mov qword[rbp+16],rcx ;[rbp+8] is skipped because that's where the return adress lies
    mov qword[rbp+24],rdx
    mov qword[rbp+32],r8
    mov qword[rbp+40],r9

    mov rax,24
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

    mov rbx,qword[rbp+16]
    mov qword[rax],rbx
    mov rbx,[rbp+24]
    mov qword[rax+8],rbx
    mov rbx,[rbp+32]
    mov qword[rax+16],rbx
    mov rcx,0
    push qword[rbp+32]
put_in_heap:
    cmp qword[rbp+32],0
    je end_put_in_heap
    add rcx,8
    mov rbx,qword[rbp+32+rcx]
    mov qword[rax+16+rcx],rbx
    sub qword[rbp+32],1
    jne put_in_heap
end_put_in_heap:
    pop qword[rbp+32]

    ;mov rax,[rax]
    leave
    ret




execute_curry:
    enter 0,0
    mov [rbp+16],rcx
    mov [rbp+24],rdx
    mov [rbp+32],r8 ;nr of args that are NOT curried
    mov [rbp+40],r9

    push qword[rbp+24]
    mov rbx,[rbp+32]
    sub [rbp+24],rbx
    mov rbx,[rbp+24]
    pop qword[rbp+24]

    push qword[rbp+32]
    mov rcx,0
    add rcx,16

find_size_curried_args:
    cmp rbx,0
    je end_find_size_curried_args
    add rcx,8
    sub rbx,1
    jne find_size_curried_args
end_find_size_curried_args:

put_rest_in_heap:
    cmp qword[rbp+32],0
    je end_put_rest_in_heap
    add rcx,8
    mov rdx,rcx
    ;sub rdx,rbx
    ;sub rdx,16
    mov rdx,[rbp+8+rdx]
    mov rax,[rbp+16]
    mov [rax+rcx],rdx
    sub qword[rbp+32],1
    jne put_rest_in_heap
end_put_rest_in_heap:
    pop qword[rbp+32]

no_args:
    cmp qword[rbp+24],0
    jne yes_args
    sub rsp,32
    mov rax,[rbp+16]
    call [rax]
yes_args:

    mov rdx,24
    push qword[rbp+24]
find_size_again:
    cmp qword[rbp+24],0
    je end_find_size_again
    sub qword[rbp+24],1
    add rdx,8
    jne find_size_again
end_find_size_again:
    pop qword[rbp+24]

call_with_args:
    cmp qword[rbp+32],0
    je end_call_with_args
    mov rax,[rbp+16]
    push qword[rax+24+rdx]
    sub rdx,8
    sub qword[rbp+32],1
    jne call_with_args
    
end_call_with_args:
    mov rax,[rbp+16]

    mov rcx,[rax+24]
    mov rdx,[rax+32]
    mov r8,[rax+40]
    mov r9,[rax+48]
    sub rsp,32
    call [rax]
    leave
    ret
section .data
str: db "%d",0
msg: db "hello world",0

;;after enter 0,0:
;bp - bp
;ret_addr - bp+8
;args - bp+16...
