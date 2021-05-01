# look, I know this is a very jank makefile, but it works on my system and will get back to it later, what matters most is that it work on my pc.

build:
	i386-elf-as boot.s -o boot.o
	i386-elf-gcc -S kernel.c -o kernel.s -std=gnu99 -ffreestanding -O2 -Wall -Wextra
	i386-elf-as kernel.s -o kernel.o
	rm kernel.s
	i386-elf-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -B /home/eternal/Downloads/gcc-i386/libexec/gcc/i386-elf/9.3.0/ -lgcc

qemu:
	qemu-system-x86_64 myos.iso

iso:
	mkdir -p isodir/boot/grub
	cp myos.bin isodir/boot/myos.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o myos.iso isodir