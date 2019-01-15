NASM=/usr/local/bin/nasm
CC=gcc

TARGET=husk.iso

$(TARGET) : src/bootloader/bootloader.bin


src/bootloader/bootloader.bin: src/bootloader/bootloader.asm
	$(NASM) -O0 -f bin -o src/bootloader/bootloader.bin src/bootloader/bootloader.asm
