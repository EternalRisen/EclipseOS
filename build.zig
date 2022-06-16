const builtin = @import("builtin");
const std = @import("std");

const CrossTarget = std.zig.CrossTarget;
const Target = std.Target;

// Targets i686-freestanding
const default_target = CrossTarget{
    .cpu_arch = .i386,
    .os_tag = .freestanding,
    .cpu_model = .{ .explicit = &Target.x86.cpu._i686 },
};

const cflags = [_][]const u8{
    "-O2",
    "-Wall",
    "-Wextra",
    "-pedantic",
};

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{ .default_target = default_target });

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    // Set to null, compile by adding files
    const bin = b.addExecutable("myos.bin", null);

    bin.setTarget(target);
    bin.setBuildMode(mode);
    bin.setOutputDir("isodir/boot");

    // add custom includes
    bin.addIncludeDir("kernel/include");

    // The files to compile
    bin.addAssemblyFile("boot/boot.s");
    bin.addCSourceFile("kernel/kernel.cpp", &cflags);
    bin.setLinkerScriptPath(.{ .path = "linker/linker.ld" });

    bin.install();

    const iso_cmd = b.addSystemCommand(&[_][]const u8{ "grub-mkrescue", "-o", "dist/myos.iso", "isodir" });
    iso_cmd.step.dependOn(b.getInstallStep());

    const iso_step = b.step("iso", "Build an iso");
    iso_step.dependOn(&iso_cmd.step);

    const qemu_cmd = b.addSystemCommand(&[_][]const u8{ "qemu-system-x86_64", "-cdrom", "dist/myos.iso" });
    qemu_cmd.step.dependOn(&iso_cmd.step);

    const qemu_step = b.step("qemu", "Run with qemu");
    qemu_step.dependOn(&qemu_cmd.step);
}
