;
; A simple  boot  sector  that  prints a message  to the  screen  using a BIOS  routine.
;
  mov ah, 0x0e   ; int  10/ah = 0eh -> scrolling  teletype  BIOS  routine
  mov al, 48
  int 0x10
  mov al, 49
  int 0x10
  mov al, 50
  int 0x10
  mov al, 51
  int 0x10
  mov al, 52
  int 0x10
  jmp $           ; Jump to the  current  address (i.e.  forever).
;
; Padding  and  magic  BIOS  number.
;
  times  510-($-$$) db 0 ; Pad  the  boot  sector  out  with  zeros
  dw 0xaa55                ; Last  two  bytes  form  the  magic  number ,
; so BIOS  knows  we are a boot  sector.
