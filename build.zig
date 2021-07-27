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

    // The files to compile
    bin.addAssemblyFile("boot/boot.s");
    bin.addCSourceFile("kernel/kernel.cpp", &cflags);
    bin.setLinkerScriptPath("linker/linker.ld");

    bin.install();
}
