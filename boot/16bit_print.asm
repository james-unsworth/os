; 16bit_print.asm
; Basic screen output for 16-bit mode using BIOS intweeupts

BIOS_TELETYPE equ 0x0e ; BIOS interrupt for teletype output

NEWLINE equ 0x0a
RETURN equ 0x0d
PRINT equ 0x10

ASCII_NUMBER_OFFSET equ 0x30
ASCII_LETTER_OFFSET equ 7

; Print null terminated string at [bx]
print_16:
    pusha
   start:
        mov al, [bx]    
        cmp al, 0       
        je done

        mov ah, BIOS_TELETYPE    
        int PRINT

        add bx, 1      
        jmp start

    done:
        popa
        ret

; Print newline and carriage return
print_nl_16:
    mov ah, BIOS_TELETYPE
    mov al, NEWLINE    
    int PRINT
    mov al, RETURN    
    int PRINT

    ret

; Print value at [dx] in hex format
print_hex:
    mov cx, 0

   hex_loop:        
    cmp cx, 4
    je end

    mov ax, dx
    ; Mask out lower nibble to work one digit at a time      
    and ax, 0x000f  
    add al, ASCII_NUMBER_OFFSET
        
    cmp al, 0x39    
    jle step2       
    add al, ASCII_LETTER_OFFSET     

    step2:
        mov bx, HEX_OUT + 5    
        sub bx, cx      
        mov [bx], al    
        ror dx, 4 ;     

        add cx, 1       
        jmp hex_loop


    end:
        mov bx, HEX_OUT
        call print_16
        ret

HEX_OUT:
    db '0x0000', 0