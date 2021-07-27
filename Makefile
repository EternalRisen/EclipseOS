# look, I know this is a very jank makefile, but it works on my system and will get back to it later, what matters most is that it work on my pc.

build:
	@zig build
	@mv zig-out/bin/myos.bin isodir/boot/myos.bin
	@mkdir -p isodir/boot/grub
	@mkdir -p dist
	@grub-mkrescue -o dist/myos.iso isodir

qemu:
	@qemu-system-x86_64 -cdrom dist/myos.iso
