const std = @import("std");

pub fn resolve(buffer: *std.ArrayList(u8), jump_addresses: *std.StringHashMap(usize), label_addresses: *std.StringHashMap(usize)) !void {
    var it = jump_addresses.iterator();
    while (it.next()) |entry| {
        const x = @constCast(&label_addresses.get(entry.key_ptr.*).?);
        const value: *u8 = @ptrCast(x);
        buffer.items[entry.value_ptr.*] = value.*;
    }
}
