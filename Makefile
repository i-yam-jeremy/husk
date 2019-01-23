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
	dd if=src/bootloader/bootloader.bin of=husk.flp seek=0 count=1 conv=notrunc
	mkdir -p iso
	cp husk.flp iso/
	#cp src/bootloader/bootloader.bin iso/
	#mkisofs -r -b bootloader.bin -c husk.flp -o husk.iso -no-emul-boot -boot-load-size 4 -boot-info-table iso/
	mkisofs -quiet -V 'HUSK' -input-charset iso8859-1 -o husk.iso -b husk.flp iso/
	dd if=husk.raw of=husk.iso seek=0 count=33 conv=notrunc
	#mkisofs -V 'HUSK' -input-charset iso8859-1 -o $(TARGET_ISO) -no-emul-boot -boot-load-size 4 -b husk.flp -hide husk.flp iso/


src/kernel/kernel.bin: src/kernel/*.c
		$(CC) -ffreestanding -m32 -c -o src/kernel/kernel.o src/kernel/kernel.c
		$(OBJCOPY) -O binary --change-start 0x1000 --pad-to 0x4000 src/kernel/kernel.o src/kernel/kernel.bin

src/bootloader/bootloader.bin: src/bootloader/*.asm
	$(NASM) -O0 -f bin -o src/bootloader/bootloader.bin src/bootloader/bootloader.asm
