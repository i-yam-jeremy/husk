[org 0x7c00]

  mov bp, 0x9000          ; Set  the  stack.
  mov sp, bp
  call  welcome_16bit_mode
  call  switch_to_pm      ; Note  that we  never  return  from  here.
  jmp $

welcome_16bit_mode:
  mov ah, 0x0e
  mov al, 0x21
  int 0x10
  ret

%include "src/bootloader/gdt.asm"
%include "src/bootloader/print_string_pm.asm"
%include "src/bootloader/switch_to_pm.asm"

[bits  32]

; This is  where we  arrive  after  switching  to and  initialising  protected  mode.
BEGIN_PM:
  mov ebx , MSG_PROT_MODE
  call  print_string_pm    ; Use  our 32-bit  print  routine.
  jmp $                      ; Hang.

; Global  variables
MSG_PROT_MODE   db "Successfully  landed  in 32-bit  Protected  Mode", 0
; Bootsector  padding
times  510-($-$$) db 0
dw 0xaa55
