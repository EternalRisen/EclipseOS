# look, I know this is a very jank makefile, but it works on my system and will get back to it later, what matters most is that it work on my pc.

build:
	mkdir -p dist
	i386-elf-as boot/boot.s -o dist/boot.o
	i386-elf-g++ -S kernel/kernel.cpp -o dist/kernel.s -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti
	i386-elf-as dist/kernel.s -o dist/kernel.o
	rm dist/kernel.s
	i386-elf-g++ -T linker/linker.ld -o isodir/boot/myos.bin -ffreestanding -O2 -nostdlib dist/boot.o dist/kernel.o -B /home/eternal/Downloads/gcc-i386/libexec/gcc/i386-elf/9.3.0/ -lgcc

qemu:
	qemu-system-x86_64 -cdrom dist/myos.iso

iso:
	mkdir -p isodir/boot/grub
	grub-mkrescue -o dist/myos.iso isodir
