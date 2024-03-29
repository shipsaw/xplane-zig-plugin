// src/main.zig

const std = @import("std");

const xplmDefs = @import("zig-src/XPLMDefs.zig");
const xplmDataAccess = @import("zig-src/XPLMDataAccess.zig");
const xplmMenus = @import("zig-src/XPLMMenus.zig");
const xplmUtilities = @import("zig-src/XPLMUtilities.zig");

var gDataRef: xplmDataAccess.XPLMDataRef = null;

export fn MyMenuHandlerCallback(inMenuRef: ?*anyopaque, inItemRef: ?*anyopaque) void {
    _ = inMenuRef;
    xplmUtilities.XPLMDebugString("**** 0\n");
    if (gDataRef != null) {
        xplmUtilities.XPLMDebugString("**** 1\n");
        xplmDataAccess.XPLMSetDatai(gDataRef, xplmDataAccess.XPLMGetDatai(gDataRef));
        xplmUtilities.XPLMDebugString("**** 2\n");
        // Convert * void to c_int
        const incrementAmount: c_int = @truncate(@as(i64, @bitCast(@intFromPtr(inItemRef))));

        var buffer: [10]u8 = undefined;
        const buf = buffer[0..];

        _ = std.fmt.bufPrintIntToSlice(buf, incrementAmount, 10, std.fmt.Case.lower, std.fmt.FormatOptions{});

        xplmUtilities.XPLMDebugString(buf);
        xplmDataAccess.XPLMSetDatai(gDataRef, xplmDataAccess.XPLMGetDatai(gDataRef) + incrementAmount);
        xplmUtilities.XPLMDebugString("**** 3\n");
    }
}
export fn XPluginStart(outName: [*:0]u8, outSig: [*:0]u8, outDesc: [*:0]u8) c_int {
    var myMenu: xplmMenus.XPLMMenuID = undefined;
    var mySubMenuItem: i32 = 0;
    @memcpy(outName, "Hello World Sim Data!!");
    @memcpy(outSig, "xpsdk.examples.helloworld3plugin");
    @memcpy(outDesc, "Hello world! In zig");

    const radioDecrement: i64 = -10;
    const radioDecrementUsize = @as(usize, @bitCast(radioDecrement));
    const radioDecrementCast = @as(?*anyopaque, @ptrFromInt(radioDecrementUsize));

    const radioIncrement: i64 = 10;
    const radioIncrementCast = @as(?*anyopaque, @ptrFromInt(radioIncrement));
    // const radioDecrement = [_]u8{ 0, 0, 0, '-', '1', '0', '0', '0' };
    // const radioDecrementBits = @as(usize, @bitCast(radioDecrement));
    // const radioDecrementPtr = @as(?*anyopaque, @ptrFromInt(radioDecrementBits));

    // const radioIncrement = [_]u8{ 0, 0, 0, '+', '1', '0', '0', '0' };
    // const radioIncrementBits = @as(usize, @bitCast(radioIncrement));
    // const radioIncrementPtr = @as(?*anyopaque, @ptrFromInt(radioIncrementBits));

    mySubMenuItem = xplmMenus.XPLMAppendMenuItem(xplmMenus.XPLMFindPluginsMenu(), "Sim Data", @ptrFromInt(0), 1);
    myMenu = xplmMenus.XPLMCreateMenu("Sim Data", xplmMenus.XPLMFindPluginsMenu(), mySubMenuItem, MyMenuHandlerCallback, @ptrFromInt(0));
    _ = xplmMenus.XPLMAppendMenuItem(myMenu, "Decrement Nav1", radioDecrementCast, 1);
    _ = xplmMenus.XPLMAppendMenuItem(myMenu, "Increment Nav1", radioIncrementCast, 1);
    gDataRef = xplmDataAccess.XPLMFindDataRef("sim/cockpit/radios/nav1_freq_hz");

    const debugString = if (gDataRef == null) "********** No gDataRef" else "********** gDataRef OK";
    xplmUtilities.XPLMDebugString(debugString);

    return if (gDataRef != null) 1 else 0;
}

export fn XPluginStop() void {}

export fn XPluginDisable() void {}
export fn XPluginEnable() c_int {
    return 1;
}
export fn XPluginReceiveMessage(inFrom: xplmDefs.XPLMPluginID, inMsg: c_int, inParam: ?*anyopaque) void {
    _ = inFrom;
    _ = inMsg;
    _ = inParam;
}
