// src/main.zig

const std = @import("std");

const xplmCamera = @import("zig-src/XPLMCamera.zig");
const xplmDisplay = @import("zig-src/XPLMDisplay.zig");
const xplmGraphics = @import("zig-src/XPLMGraphics.zig");
const xplmDefs = @import("zig-src/XPLMDefs.zig");
// const xplmCamera = @cImport({
//     @cInclude("XPLMCamera.h");
// });
// const xplmDisplay = @cImport({
//     @cInclude("XPLMDisplay.h");
// });
// const xplmGraphics = @cImport({
//     @cInclude("XPLMGraphics.h");
// });
// const xplmDefs = @cImport({
//     @cInclude("XPLMDefs.h");
// });

var g_window: xplmDisplay.XPLMWindowID = undefined;
export fn XPluginStart(outName: [*:0]u8, outSig: [*:0]u8, outDesc: [*:0]u8) c_int {
    @memcpy(outName, "Hello World!!");
    @memcpy(outSig, "xpsdk.examples.helloworld3plugin");
    @memcpy(outDesc, "Hello world! In zig");

    var params: xplmDisplay.XPLMCreateWindow_t = undefined;
    params.structSize = @sizeOf(xplmDisplay.XPLMCreateWindow_t);
    params.visible = 1;
    params.drawWindowFunc = draw_hello_world;
    params.handleMouseClickFunc = dummy_mouse_handler;
    params.handleRightClickFunc = dummy_mouse_handler;
    params.handleMouseWheelFunc = dummy_wheel_handler;
    params.handleKeyFunc = dummy_key_handler;
    params.handleCursorFunc = dummy_cursor_status_handler;
    params.refcon = null;
    params.layer = xplmDisplay.xplm_WindowLayerFloatingWindows;
    params.decorateAsFloatingWindow = xplmDisplay.xplm_WindowDecorationRoundRectangle;

    var left: c_int = 0;
    var bottom: c_int = 0;
    var right: c_int = 0;
    var top: c_int = 0;
    xplmDisplay.XPLMGetScreenBoundsGlobal(&left, &top, &right, &bottom);
    params.left = left + 50;
    params.bottom = bottom + 150;
    params.right = params.left + 200;
    params.top = params.bottom + 200;

    g_window = xplmDisplay.XPLMCreateWindowEx(&params);
    xplmDisplay.XPLMSetWindowPositioningMode(g_window, xplmDisplay.xplm_WindowPositionFree, -1);
    xplmDisplay.XPLMSetWindowResizingLimits(g_window, 200, 200, 300, 300);
    xplmDisplay.XPLMSetWindowTitle(g_window, "Hample Window from zig if it works");
    return if (g_window != null) 1 else 0;
}

export fn XPluginStop() void {
    // Since we created the window, we'll be good citizens and clean it up
    xplmDisplay.XPLMDestroyWindow(g_window);
    g_window = null;
}

export fn XPluginDisable() void {}
export fn XPluginEnable() c_int {
    return 1;
}
export fn XPluginReceiveMessage(inFrom: xplmDefs.XPLMPluginID, inMsg: c_int, inParam: ?*anyopaque) void {
    _ = inFrom;
    _ = inMsg;
    _ = inParam;
}

fn draw_hello_world(in_window_id: xplmDisplay.XPLMWindowID, in_refcon: ?*anyopaque) callconv(.C) void {
    _ = in_refcon;
    xplmGraphics.XPLMSetGraphicsState(0, 0, 0, 0, 1, 1, 0);

    var l: c_int = 0;
    var t: c_int = 0;
    var r: c_int = 0;
    var b: c_int = 0;

    xplmDisplay.XPLMGetWindowGeometry(in_window_id, &l, &t, &r, &b);

    var col_white = [_]f32{ 1.0, 1.0, 1.0 };
    var col_white_slc: [*]f32 = undefined;
    col_white_slc = &col_white;

    var helloString = [_]u8{ 'h', 'e', 'l', 'l', 'o', '!', '!', 0 };
    var helloString_slc: [*]u8 = undefined;
    helloString_slc = &helloString;

    xplmGraphics.XPLMDrawString(col_white_slc, l + 10, t - 20, helloString_slc, null, xplmGraphics.xplmFont_Proportional);
}
fn dummy_mouse_handler(in_window_id: xplmDisplay.XPLMWindowID, x: c_int, y: c_int, is_down: c_int, in_refcon: ?*anyopaque) callconv(.C) c_int {
    _ = x;
    _ = y;
    _ = is_down;
    _ = in_window_id;
    _ = in_refcon;
    return 0;
}
fn dummy_cursor_status_handler(in_window_id: xplmDisplay.XPLMWindowID, x: c_int, y: c_int, in_refcon: ?*anyopaque) callconv(.C) xplmDisplay.XPLMCursorStatus {
    _ = in_window_id;
    _ = x;
    _ = y;
    _ = in_refcon;
    return xplmDisplay.xplm_CursorDefault;
}
fn dummy_wheel_handler(in_window_id: xplmDisplay.XPLMWindowID, x: c_int, y: c_int, wheel: c_int, clicks: c_int, in_refcon: ?*anyopaque) callconv(.C) c_int {
    _ = in_window_id;
    _ = x;
    _ = y;
    _ = wheel;
    _ = clicks;
    _ = in_refcon;
    return 0;
}
fn dummy_key_handler(in_window_id: xplmDisplay.XPLMWindowID, key: u8, flags: xplmDefs.XPLMKeyFlags, virtual_key: u8, in_refcon: ?*anyopaque, losing_focus: c_int) callconv(.C) void {
    _ = in_window_id;
    _ = key;
    _ = flags;
    _ = virtual_key;
    _ = losing_focus;
    _ = in_refcon;
}
