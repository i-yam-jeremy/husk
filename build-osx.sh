#! /bin/bash

if test "`whoami`" != "root" ; then
 	echo "[halt] Not running with superuser privileges."
 	exit
fi

echo "[okay] Running from superuser"

full_nasm_path=/usr/local/bin/nasm

$full_nasm_path -O0 -f bin -o src/bootload/bootload.bin src/bootload/bootload.asm || exit
echo "[okay] Assembled bootloader"
cd src
$full_nasm_path -O0 -f bin -o kernel.bin kernel.asm || exit
cd ..
echo "[okay] Assembled kernel"
#cd programs
#for i in *.asm
#do
#	$full_nasm_path -O0 -f bin $i -o `basename $i .asm`.bin || exit
#	echo "[okay] Assembled program: $i"
#done
#cd ..
cp disk_images/husk.flp disk_images/husk.dmg
echo "[okay] Copied floppy image"
dd conv=notrunc if=src/bootload/bootload.bin of=disk_images/husk.dmg || exit
echo "[okay] Added bootloader to image"
rm -rf tmp-loop
dev=`hdid -nobrowse -nomount disk_images/husk.dmg`
mkdir tmp-loop && mount -t msdos ${dev} tmp-loop && cp src/kernel.bin tmp-loop/
#cp programs/*.bin programs/*.bas programs/sample.pcx tmp-loop
#echo "[okay] Added programs to image"
diskutil umount tmp-loop || exit
hdiutil detach ${dev}
rm -rf tmp-loop
echo "[okay] Unmounted floppy image"
rm -f disk_images/husk.iso
mkisofs -quiet -V 'HUSK' -input-charset iso8859-1 -o disk_images/husk.iso -b husk.dmg disk_images/ || exit
echo "[okay] Converted floppy to ISO-8859-1 image"
echo "[done] Build completed"

qemu-system-i386 -drive format=raw,media=cdrom,readonly,file=disk_images/husk.iso
