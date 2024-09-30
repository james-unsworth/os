; GDT

gdt_start:
    dd 0x0      ; 4 bytes of 0
    dd 0x0      ; 4 bytes of 0

gdt_code:
    ; base=0x0, limit=0xfffff,
    ; 1st flags: (present)1, (privilege)00, (descirptor type)1, 
    ; type flags: (code)1, (conforming)0, (readable)1, (accessed)0
    ; 2nd flags: (granularity)1, (32-bit default)1, (64-bit seg)0, (AVL)0
    dw 0xffff       ; limit (bits 0-15)
    dw 0x0          ; base (bits 0-15)
    db 0x0          ; base (bits 16-23)
    db 10011010b    ; 1st flags, type flags, b=binary
    db 11001111b    ; 2nd flags, limit (bits 16-19)
    db 0x0          ; base (bits 24-31)

gdt_data:
    ; same as code segment except for type flags
    ; type flags: (code)0, (expand down)0, (writable)1, (accessed)0
    dw 0xffff       ; limit (bits 0-15)
    dw 0x0          ; base (bits 0-15)
    db 0x0          ; base (bits 16-23)
    db 10010010b    ; 1st flags, type flags
    db 11001111b    ; 2nd flags, limit (bits 16-19)
    db 0x0          ; base (bits 24-31)

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1      ; calculate GDT size
    dd gdt_start                    ; start address of GDT 

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start



