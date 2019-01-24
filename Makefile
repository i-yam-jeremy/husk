NASM=/usr/local/bin/nasm
CC=gcc
OBJCOPY=objcopy

TARGET=husk.raw
TARGET_ISO=husk.iso

$(TARGET) : src/bootloader/bootloader.bin src/kernel/kernel.bin
	cat src/bootloader/bootloader.bin src/kernel/kernel.bin > $(TARGET)

run: $(TARGET)
	qemu-system-i386 -drive format=raw,file=$(TARGET)

iso: $(TARGET_ISO)
$(TARGET_ISO): $(TARGET)
	dd if=/dev/zero of=husk.flp bs=1024 count=1440
	dd if=husk.raw of=husk.flp seek=0 count=33 conv=notrunc
	mkdir -p iso
	cp husk.flp iso/
	#cp src/kernel/kernel.bin iso/
	mkisofs -quiet -V 'HUSK' -input-charset iso8859-1 -o husk.iso -b husk.flp -hide husk.flp iso/

src/kernel/kernel.bin: src/kernel/*.c src/kernel/vesa.asm
		$(NASM) -O0 -f macho32 -o src/kernel/vesa.o src/kernel/vesa.asm
		$(CC) -ffreestanding -m32 -c -o src/kernel/kernel.o src/kernel/kernel.c
		ld -r -o src/kernel/full_kernel.o src/kernel/kernel.o src/kernel/vesa.o 
		$(OBJCOPY) -O binary --change-start 0x1000 --pad-to 0x4000 src/kernel/full_kernel.o src/kernel/kernel.bin

src/bootloader/bootloader.bin: src/bootloader/*.asm
	$(NASM) -O0 -f bin -o src/bootloader/bootloader.bin src/bootloader/bootloader.asm
