; printing in 32-bit protected mode uses VGA memory to separate screen into array of cells 80x25
; store ascii character and attributes in each cell

[bits 32]

VIDEO_MEMORY equ 0xb8000        ; video memory always starts at this address
WHITE_ON_BLACK equ 0x0f

print_32:
    pusha
    mov edx, VIDEO_MEMORY       ; set edx start of video memory

print_32_loop:
    mov al, [ebx]               ; store char in ebx in al
    mov ah, WHITE_ON_BLACK      ; store attributes in ah

    cmp al, 0                   ; if end, done
    je print_32_done

    mov [edx] , ax              ; store character and attribute in video memory
    add ebx, 1                  ; next char
    add edx, 2                  ; next video memory position

    jmp print_32_loop

print_32_done:
    popa
    ret