print_16:
    pusha
   start:
        mov al, [bx]    ; store content at first address in register
        cmp al, 0       ; if 0, end loop
        je done

        mov ah, 0x0e    ; print character in al
        int 0x10

        add bx, 1      ; increment index
        jmp start

    done:
        popa
        ret

print_nl_16:

    mov ah, 0x0e
    mov al, 0x0a    ; nl character
    int 0x10
    mov al, 0x0d    ; carriage return - back to start of line
    int 0x10

    ret

print_hex:
    mov cx, 0

   hex_loop:        ; loop 4 times
    cmp cx, 4
    je end

    mov ax, dx      ; move hex value to ax
    and ax, 0x000f  ; strip to only last digit by comparing each bit using and operation with 0000 0000 0000 1111
    add al, 0x30    ; add 0x30 to get ascii for 0-9
    cmp al, 0x39    ; if more than 0x39 eg A-F
    jle step2       ; if not then continue
    add al, 7       ; if so then add 7 to get A-F ascii

    step2:
        mov bx, HEX_OUT + 5    
        sub bx, cx      ; get index of current character ie take 5-loop number, 5-1=4
        mov [bx], al    ; add ascii value to that position in HEX_OUT
        ror dx, 4 ;     ; rotate original hex by 4 bits, eg 0x1234 -> 0x4123, for next run

        add cx, 1       ; increment loop
        jmp hex_loop


    end:
        mov bx, HEX_OUT
        call print_16
        ret

HEX_OUT:
    db '0x0000', 0