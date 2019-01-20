; A boot  sector  that  boots a C kernel  in 32-bit  protected  mode
[org 0x7c00]
KERNEL_OFFSET  equ 0x1000   ; This is the  memory  offset  to which  we will  load  our  kernel

  mov [BOOT_DRIVE], dl ; BIOS  stores  our  boot  drive  in DL, so it’s
  ; best to  remember  this  for  later.
  mov bp, 0x9000         ; Set -up the  stack.
  mov sp, bp
  call switch_to_bios_vga
  call  load_kernel       ; Load  our  kernel
  call  switch_to_pm      ; Switch  to  protected  mode , from  which
  ; we will  not  return

  jmp $

; Include  our useful , hard -earned  routines
%include "src/bootloader/disk_load.asm"
%include "src/bootloader/gdt.asm"
%include "src/bootloader/switch_to_pm.asm"
%include "src/bootloader/vesa.asm"

[bits  16]
; switch to BIOS VGA video mode
switch_to_bios_vga:
  call get_vesa_framebuffer_location
  mov ax, 0x13
  int 0x10
  ; call set_vesa_mode
  ret

; load_kernel
load_kernel:
  mov bx, KERNEL_OFFSET      ; Set -up  parameters  for  our  disk_load  routine , so
  mov dh, 32                   ; that we load  the sectors (excluding
  mov dl, [BOOT_DRIVE]       ; the  boot  sector) from  the  boot  disk (i.e.  our
  call  disk_load               ;   kernel  code) to  address  KERNEL_OFFSET
  ret

[bits  32]
; This is where we  arrive  after  switching  to and  initialising  protected  mode.
BEGIN_PM:
  call  KERNEL_OFFSET      ; Now  jump to the  address  of our  loaded
  ; kernel  code , assume  the  brace  position ,
  ; and  cross  your  fingers.  Here we go!
  jmp $                      ; Hang.

; Global  variables
BOOT_DRIVE        db 0

; Bootsector  padding
times  510-($-$$) db 0
dw 0xaa55
