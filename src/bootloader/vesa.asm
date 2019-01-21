;vbe_info_structure:
;  .signature db "VBE2"
;  .table_data resb 512-4

vbe_mode_info_structure:
  .pre_data resb 40
  .framebuffer resb 4
  .post_data resb 256-44


print_hex_num: ;; num in bx
  mov ah, 0x0e
  push bx
  and bl, 0xF
  mov al, bl
  add al, 0x30
  int 0x10
  pop bx
  shr bx, 4
  dec cx
  jne print_hex_num
  ret


get_vesa_framebuffer_location:
  ;;mov bx, 0x21
  ;;call print_hex_num

  push es
  mov ax, 0x4F01
  mov cx, 0x4118
  ;
  mov di, vbe_mode_info_structure
  int 0x10
  pop es

  ret

  ;;pop es


  ;;mov di, 0x0000
  ;;mov es, di
  ;;call print_hex_num
  ;;mov di, vbe_mode_info_structure
  ;;mov di, vbe_mode_info_structure
  ;;mov bx, [di+40]
  ;;mov bx, 0x12
  ;;call print_hex_num
  ;;mov di, 0x4000
  ;;mov es, di
  ;;mov di, 0x0000
  ;;mov [es:di], ax

  ;;mov di, vbe_mode_info_structure
  ;;add di, 2
  ;;mov ax, [di]
  ;;mov di, 0x8002
  ;;mov [di], ax

  ;;ret

;;set_vesa_mode:
;;  mov ax, 0x4F02
;;  mov bx, 0x4118
;;  int 0x10
;;  ret
