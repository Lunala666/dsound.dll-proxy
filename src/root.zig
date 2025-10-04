const std = @import("std");
const win = std.os.windows;
const w = @import("externs.zig");
// const dll: [:0]const u16 = std.unicode.utf8ToUtf16LeStringLiteral("dsound.dll");
const dll: [:0]const u8 = "dsound.dll";
var dllPath: [:0]u16 = undefined;

// pub fn pathAppend(fmt: []const u8, args: anytype) [*:0]const u16 {
pub fn pathAppend(allocator: std.mem.Allocator, x: []const u8, y: []const u8) []const u8 {
    var buf: [1084]u8 = undefined;
    const print: []const u8 = std.fmt.bufPrint(&buf, "{s}/{s}", .{ x, y }) catch unreachable;

    const heap_copy = allocator.dupe(u8, print) catch unreachable;
    return heap_copy;
}

pub export fn DirectSoundCreate() win.FARPROC {
    return w.GetProcAddress(getReal(), "DirectSoundCreate");
}
pub export fn DirectSoundEnumerateA() win.FARPROC {
    return w.GetProcAddress(getReal(), "DirectSoundEnumerateA");
}
pub export fn DirectSoundEnumerateW() win.FARPROC {
    return w.GetProcAddress(getReal(), "DirectSoundEnumerateW");
}
pub export fn DllCanUnloadNow() win.FARPROC {
    return w.GetProcAddress(getReal(), "DllCanUnloadNow");
}
pub export fn DllGetClassObject() win.FARPROC {
    return w.GetProcAddress(getReal(), "DllGetClassObject");
}
pub export fn DirectSoundCaptureCreate() win.FARPROC {
    return w.GetProcAddress(getReal(), "DirectSoundCaptureCreate");
}
pub export fn DirectSoundCaptureEnumerateA() win.FARPROC {
    return w.GetProcAddress(getReal(), "DirectSoundCaptureEnumerateA");
}
pub export fn DirectSoundCaptureEnumerateW() win.FARPROC {
    return w.GetProcAddress(getReal(), "DirectSoundCaptureEnumerateW");
}
pub export fn GetDeviceID() win.FARPROC {
    return w.GetProcAddress(getReal(), "GetDeviceID");
}
pub export fn DirectSoundFullDuplexCreate() win.FARPROC {
    return w.GetProcAddress(getReal(), "DirectSoundFullDuplexCreate");
}
pub export fn DirectSoundCreate8() win.FARPROC {
    return w.GetProcAddress(getReal(), "DirectSoundCreate8");
}
pub export fn DirectSoundCaptureCreate8() win.FARPROC {
    return w.GetProcAddress(getReal(), "DirectSoundCaptureCreate8");
}

pub fn getReal() win.HMODULE { //THOSE WHO KNOW
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const alloc1 = std.heap.page_allocator;

    const sys: win.LPWSTR = undefined;
    _ = w.GetSystemDirectoryW(sys, win.MAX_PATH);
    const system32: []u8 = undefined;
    _ = std.unicode.wtf16LeToWtf8(system32, std.mem.span(sys));
    const ILoveFemboys = pathAppend(allocator, system32, dll);
    alloc1.free(system32);

    dllPath = std.unicode.utf8ToUtf16LeAllocZ(alloc1, ILoveFemboys) catch unreachable;
    defer alloc1.free(dllPath);

    std.debug.print("DLL: {d}", .{dllPath});
    // dllPath = @as([*:0]const u16, dllPath.ptr);

    const realDll: win.HMODULE = win.LoadLibraryW(dllPath) catch unreachable;

    return realDll;
}

pub export fn _DllMainCRTStartup(hInstance: win.HMODULE, nReason: win.DWORD, lpvReserved: win.LPVOID) win.BOOL {
    _ = hInstance;
    _ = lpvReserved;
    const realDll = getReal();
    _ = realDll;

    ////////////////

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    _ = allocator;

    ////////////////

    // const a: [*:0]u16 = "hello";
    // const b: [*:0]u16 = "guys";
    // const result = pathAppend(allocator, a, b);
    // defer allocator.free(result);

    switch (nReason) {
        w.DLL_PROCESS_ATTACH => {
            // std.debug.print("Test: {s}\n", .{result});
        },
        else => {},
    }

    return win.TRUE;
}
