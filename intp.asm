osabi 9 ;FreeBSD

bits 32

section	.swtm_code exec

extern my_hello, my_exit

    db        0x01, 0x01, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00
    db        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    db        0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    db        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

th_hello:
    db        0
    jmp       my_hello

th_exit:
    db        0
    jmp       my_exit

section	.swtm_table

    dd        0x00000000
    dd        0x40000010
    dd        th_hello
    dd        th_exit

section	.text

global	intp

intp:
    mov       esi,0x40000000
    jmp       entry

return:
    pop       esi

    xor       eax,eax            ;clear upper 3 bytes for lodsb
    lodsb                           ;al=tok, inc esi
    shl       eax,2                 ;token*4 (pointers are 4-bytes), set flags...
    jz        return                ;A 0 token that is not first means return
inner_loop:
    push      esi                   ;thread in...
    shr       esi,4                 ;Tricky: esi shr 4 then shl 2 for alignment
    mov       esi,[esi*4+eax]       ;and index it with token*4 resulting in CALL
entry:
    xor       eax,eax
    lodsb
    shl       eax,2                 ;first byte of subroutine 0? Machine language code follows
    jnz       inner_loop            ;continue threading
    call      esi                   ;call assembly subroutine that follows
    jmp       return
