const std = @import("std");
pub fn main() !void {
    // Example:
    // 3   4 -> difference is 1
    // 4   3 -> difference is 1
    // 2   5 -> difference is 3
    // 1   3 -> difference is 2
    // 3   9 -> difference is 6
    // 3   3 -> difference is 0
    // 1 + 1 + 3 + 2 + 6 + 0 = 13

    // first we get the current working directory
    const cwd: std.fs.Dir = std.fs.cwd();

    // try to open the file
    const file = try cwd.openFile("input.txt", .{});
    defer file.close();
}
