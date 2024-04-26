const std = @import("std");
const raySdk = @import("raylib");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.

const Entry = struct {
    name: []const u8,
    path: []const u8,
    description: []const u8,
};

pub fn build(b: *std.Build) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const raylib = try raySdk.addRaylib(b, target, optimize, .{});

    // Create a list of executable targets to build, as a key value pair of names
    // and the corresponding source file.
    const entries = [_]Entry{
        .{ .name = "tree", .path = "src/tree.zig", .description = "Simple tree." },
    };

    // iterate over the list of targets and build each one
    for (entries) |entry| {
        const exe = b.addExecutable(.{
            .name = entry.name,
            .root_source_file = b.path(entry.path),
            .target = target,
            .optimize = optimize,
        });
        b.installArtifact(exe);

        // Add the raylib include path to the build
        exe.addIncludePath(.{ .path = "vendor/raylib/src" });
        exe.linkLibrary(raylib);

        // This *creates* a Run step in the build graph, to be executed when another
        // step is evaluated that depends on it. The next line below will establish
        // such a dependency.
        const run_cmd = b.addRunArtifact(exe);

        // By making the run step depend on the install step, it will be run from the
        // installation directory rather than directly from within the cache directory.
        // This is not necessary, however, if the application depends on other installed
        // files, this ensures they will be present and in the expected location.
        run_cmd.step.dependOn(b.getInstallStep());

        // This allows the user to pass arguments to the application in the build
        // command itself, like this: `zig build run -- arg1 arg2 etc`
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }

        // This creates a build step. It will be visible in the `zig build --help` menu,
        // and can be selected like this: `zig build run`
        // This will evaluate the `run` step rather than the default, which is "install".
        const run_step = b.step(entry.name, entry.description);
        run_step.dependOn(&run_cmd.step);

        const exe_unit_tests = b.addTest(.{
            .root_source_file = b.path(entry.path),
            .target = target,
            .optimize = optimize,
        });

        const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
        const test_step = b.step(
            try std.fmt.allocPrint(allocator, "{s}-test", .{entry.name}),
            try std.fmt.allocPrint(allocator, "Run unit tests for {s}", .{entry.name}),
        );
        test_step.dependOn(&run_exe_unit_tests.step);
    }
}
