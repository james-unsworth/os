; 32bit_print.asm
; Print functions for 32-bit protected mode

; print_32 - Print null terminated string at [ebx]

; Screen = 80x25

[bits 32]

VIDEO_MEMORY equ 0xb8000        
WHITE_ON_BLACK equ 0x0f

print_32:
    pusha
    mov edx, VIDEO_MEMORY       

print_32_loop:
    mov al, [ebx]               
    mov ah, WHITE_ON_BLACK      

    cmp al, 0                  
    je print_32_done

    mov [edx] , ax              
    add ebx, 1                  
    add edx, 2                  

    jmp print_32_loop

print_32_done:
    popa
    ret