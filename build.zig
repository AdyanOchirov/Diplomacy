const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // src
    const dip = b.addModule("dip", .{
        .root_source_file = b.path("src/dip.zig"),
        .target = target,
        .optimize = optimize,
    });
    const dip_names = b.addModule("dip_names", .{
        .root_source_file = b.path("src/extras/dip_names.zig"),
        .target = target,
        .optimize = optimize,
    });
    dip_names.addImport("dip", dip);
    const dip_memory = b.addModule("dip_memory", .{
        .root_source_file = b.path("src/extras/dip_memory.zig"),
        .target = target,
        .optimize = optimize,
    });
    dip_memory.addImport("dip", dip);

    // maps
    const classic = b.addModule("classic", .{
        .root_source_file = b.path("maps/classic.zig"),
        .target = target,
        .optimize = optimize,
    });
    classic.addImport("dip", dip);
    classic.addImport("dip_names", dip_names);
    //classic.addImport("dip_memory", dip_memory);

    // projects
    const cli = b.addModule("cli", .{
        .root_source_file = b.path("projects/cli/cli.zig"),
        .target = target,
        .optimize = optimize,
    });
    cli.addImport("dip", dip);
    cli.addImport("dip_names", dip_names);
    cli.addImport("dip_memory", dip_memory);
    cli.addImport("classic", classic);

    const exe = b.addExecutable(.{
        .name = "Diplomacy",
        .root_module = cli,
    });
    b.installArtifact(exe);

    //tests
    const test_step = b.step("test", "Run the tests");

    const datc_module = b.addModule("datc", .{
        .root_source_file = b.path("tests/datc.zig"),
        .target = target,
        .optimize = optimize,
    });
    datc_module.addImport("dip", dip);
    datc_module.addImport("dip_names", dip_names);
    datc_module.addImport("classic", classic);
    const datc_compile = b.addTest(.{
        .root_module = datc_module,
    });
    const datc_run = b.addRunArtifact(datc_compile);
    test_step.dependOn(&datc_run.step);

    const my_datc_module = b.addModule("my_datc", .{
        .root_source_file = b.path("tests/my_datc.zig"),
        .target = target,
        .optimize = optimize,
    });
    my_datc_module.addImport("dip", dip);
    my_datc_module.addImport("dip_names", dip_names);
    my_datc_module.addImport("classic", classic);
    const my_datc_compile = b.addTest(.{
        .root_module = my_datc_module,
    });
    const my_datc_run = b.addRunArtifact(my_datc_compile);
    test_step.dependOn(&my_datc_run.step);
}
