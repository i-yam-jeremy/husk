[org 0x7c00]

  mov ah, 0x0e
  mov al, 51
  int 0x10

  mov dh, 1

  mov bx, 0x9000

  mov ah, 0x02     ; BIOS  read  sector  function
  mov al, dh       ; Read DH  sectors
  mov ch, 0x00     ; Select  cylinder 0
  mov dh, 0x00     ; Select  head 0
  mov cl, 0x02     ; Start  reading  from  second  sector (i.e.
  ; after  the  boot  sector)
  int 0x13          ; BIOS  interrupt
  jc  disk_error    ; Jump if error (i.e.  carry  flag  set)
  mov dh, 1            ; Restore  DX from  the  stack
  cmp dh, al       ; if AL (sectors  read) != DH (sectors  expected)
  jne  disk_error   ;    display  error  message

  mov ah, 0x0e
  mov al, 48
  int 0x10

  jmp $

disk_error :
  mov ah, 0x0e
  mov al, 51
  int 0x10
  ;jmp $

;
; Padding  and  magic  BIOS  number.
;
  times  510-($-$$) db 0 ; Pad  the  boot  sector  out  with  zeros
  dw 0xaa55                ; Last  two  bytes  form  the  magic  number ,
; so BIOS  knows  we are a boot  sector.
