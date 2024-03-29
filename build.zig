const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.

    const targets: []const std.Target.Query = &.{
        // .{ .os_tag = .macos },
        // .{ .os_tag = .linux },
        .{ .os_tag = .windows },
    };

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    for (targets) |t| {
        const xplDll = b.addSharedLibrary(.{
            .name = "Win",
            .root_source_file = .{ .path = "src/sample-plugin.zig" },
            .target = b.resolveTargetQuery(t),
            .optimize = optimize,
        });
        xplDll.addIncludePath(std.Build.LazyPath.relative("src/SDK/CHeaders/XPLM"));
        xplDll.addIncludePath(.{ .path = "src/SDK/CHeaders/Widgets" });

        xplDll.root_module.addCMacro("XPLM200", "1");
        xplDll.root_module.addCMacro("XPLM210", "1");
        xplDll.root_module.addCMacro("XPLM300", "1");
        xplDll.root_module.addCMacro("XPLM301", "1");
        xplDll.root_module.addCMacro("XPLM302", "1");
        xplDll.root_module.addCMacro("XPLM303", "1");

        xplDll.linkLibC();

        if (t.os_tag == .windows) {
            xplDll.addLibraryPath(std.Build.LazyPath.relative("src/SDK/Libraries/Win"));

            xplDll.root_module.addCMacro("IBM", "1");
            xplDll.root_module.addCMacro("APL", "0");
            xplDll.root_module.addCMacro("LIN", "0");

            xplDll.linkSystemLibrary("XPLM_64");

            xplDll.addIncludePath(.{ .path = "zig-src/win/xplm" });
            xplDll.addIncludePath(.{ .path = "zig-src/win/widgets" });
        }
        if (t.os_tag == .linux) {
            xplDll.root_module.addCMacro("IBM", "0");
            xplDll.root_module.addCMacro("APL", "0");
            xplDll.root_module.addCMacro("LIN", "1");
        }

        b.installArtifact(xplDll);
    }
}
