; ==================================================================
; MikeOS -- The Mike Operating System kernel
; Copyright (C) 2006 - 2014 MikeOS Developers -- see doc/LICENSE.TXT
;
; This is loaded from the drive by BOOTLOAD.BIN, as KERNEL.BIN.
; First we have the system call vectors, which start at a static point
; for programs to use. Following that is the main kernel code and
; then additional system call code is included.
; ==================================================================


	BITS 16

	%DEFINE MIKEOS_VER '4.5'	; OS version number
	%DEFINE MIKEOS_API_VER 16	; API version for programs to check


	; This is the location in RAM for kernel disk operations, 24K
	; after the point where the kernel has loaded; it's 8K in size,
	; because external programs load after it at the 32K point:

	disk_buffer	equ	24576


; ------------------------------------------------------------------
; OS CALL VECTORS -- Static locations for system call vectors
; Note: these cannot be moved, or it'll break the calls!

; The comments show exact locations of instructions in this section,
; and are used in programs/mikedev.inc so that an external program can
; use a MikeOS system call without having to know its exact position
; in the kernel source code...

os_call_vectors:
	jmp os_main			; 0000h -- Called from bootloader


; ------------------------------------------------------------------
; START OF MAIN KERNEL CODE

os_main:
	cli				; Clear interrupts
	mov ax, 0
	mov ss, ax			; Set stack segment and pointer
	mov sp, 0FFFFh
	sti				; Restore interrupts

	cld				; The default direction for string operations
					; will be 'up' - incrementing address in RAM

	mov ax, 2000h			; Set all segments to match where kernel is loaded
	mov ds, ax			; After this, we don't need to bother with
	mov es, ax			; segments ever again, as MikeOS and its programs
	mov fs, ax			; live entirely in 64K
	mov gs, ax

option_screen:

start:
    mov ax,13h
    int 10h
  ; draw palette in 32x8 squares, each square 5x5 pixels big (so 160x40px)
    push 0a000h
    pop es
    xor di,di
    xor ax,ax  ; color
    mov cx,8   ; big rows (each having 32 5x5 squares)
bigRowLoop:
    mov bx,5 ; pixel height of single row
rowLoop:
    mov dx,32 ; squares per row
    push ax
    push di
squareLoop:
    ; draw 5 pixels with "ah:al" color, ++color, di += 5
    mov [es:di],ax
    mov [es:di+2],ax
    mov [es:di+4],al
    add ax,0101h
    add di,5
    dec dx
    jnz squareLoop
    pop di
    pop ax     ; restore color for first square
    add di,320 ; move di to start of next line
    dec bx     ; do next single pixel line
    jnz rowLoop
    ; one row of color squares is drawn, now next 32 colors
    add ax,02020h ; color += 32
    dec cx
    jnz bigRowLoop
  ; wait for any key and exit
    xor ah,ah
    int 16h
    ret

	jmp $

; ==================================================================
; END OF KERNEL
; ==================================================================
