NASM=/usr/local/bin/nasm
CC=gcc

TARGET=husk.iso

$(TARGET) : src/bootloader/bootloader.bin
	mkisofs -o husk.iso src
	dd conv=notrunc if=src/bootloader/bootloader.bin of=husk.iso

run: $(TARGET)
	qemu-system-i386 $(TARGET)

src/bootloader/bootloader.bin: src/bootloader/bootloader.asm
	$(NASM) -O0 -f bin -o src/bootloader/bootloader.bin src/bootloader/bootloader.asm
