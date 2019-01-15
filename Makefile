NASM=/usr/local/bin/nasm
CC=gcc
OBJCOPY=objcopy

TARGET=husk.iso

$(TARGET) : src/bootloader/bootloader.bin src/kernel/kernel.bin
	cat src/bootloader/bootloader.bin src/kernel/kernel.bin > $(TARGET)

run: $(TARGET)
	qemu-system-i386 $(TARGET)

src/kernel/kernel.bin: src/kernel/kernel.c
	$(CC) -ffreestanding -c src/kernel/kernel.c -o src/kernel/kernel.o
	$(OBJCOPY) -O binary --change-start 0x1000 src/kernel/kernel.o src/kernel/kernel.bin

src/bootloader/bootloader.bin: src/bootloader/bootloader.asm
	$(NASM) -O0 -f bin -o src/bootloader/bootloader.bin src/bootloader/bootloader.asm
