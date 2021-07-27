build:
	@zig build
	@mv zig-out/bin/myos.bin isodir/boot/myos.bin
	@mkdir -p isodir/boot/grub
	@mkdir -p dist
	@grub-mkrescue -o dist/myos.iso isodir

qemu:
	@qemu-system-x86_64 -cdrom dist/myos.iso
