const std = @import("std");
const win = std.os.windows;

pub extern "kernel32" fn GetSystemDirectoryW(lpBuffer: win.LPWSTR, uSize: win.UINT) callconv(.winapi) win.UINT;
pub extern "kernel32" fn GetProcAddress(hModule: win.HMODULE, lpProcName: win.LPCSTR) callconv(.winapi) win.FARPROC;
// pub extern "kernel32" fn LoadLibraryA(lpLibFileName: win.LPSTR) win.HMODULE;
// pub extern "kernel32" fn PathAppendW(pszPath: win.LPWSTR, pszMore: win.LPCWSTR) callconv(.winapi) win.BOOL;

pub const DLL_PROCESS_ATTACH = 1;
