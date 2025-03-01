; switch_to_pm.asm
; Switch CPU to 32-bt protected mode

switch_to_pm:
    cli    

    lgdt [gdt_descriptor]      

    ; enable protected mode
    mov eax, cr0       
    or eax, 0x1
    mov cr0, eax

    jmp CODE_SEG:init_pm

    ret

[bits 32]
init_pm:
    mov ax, DATA_SEG        
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000    
    mov esp, ebp

    call BEGIN_PM



