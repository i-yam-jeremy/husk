global get_vesa_mode_info

[bits  32]
get_vesa_mode_info:
  mov edi, 0x01000000 
  mov byte [edi], 0x37
  ret

HelloWorld db 'Hi my name is',13,10,0
