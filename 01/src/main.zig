const std = @import("std");
pub fn main() !void {
    const cwd: std.fs.Dir = std.fs.cwd();

    const file = try cwd.openFile("src/input.txt", .{});
    defer file.close();

    const file_contents = try file.readToEndAlloc(std.heap.page_allocator, 1024 * 1024);
    defer std.heap.page_allocator.free(file_contents);

    var lines = std.mem.splitSequence(u8, file_contents, "\n");

    var left_list = std.ArrayList(i32).init(std.heap.page_allocator);
    defer left_list.deinit();

    var right_list = std.ArrayList(i32).init(std.heap.page_allocator);
    defer right_list.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        var numbers = std.mem.splitSequence(u8, line, "   "); // three spaces as separator

        const first_str = numbers.next() orelse continue;
        const second_str = numbers.next() orelse continue;

        const first = std.fmt.parseInt(i32, first_str, 10) catch continue;
        const second = std.fmt.parseInt(i32, second_str, 10) catch continue;

        left_list.append(first) catch continue;
        right_list.append(second) catch continue;
    }

    var similarity_score: i32 = 0;
    for (left_list.items) |left_num| {
        var count: i32 = 0;
        for (right_list.items) |right_num| {
            if (left_num == right_num) {
                count += 1;
            }
        }
        similarity_score += left_num * count;
    }

    std.debug.print("Similarity score: {}\n", .{similarity_score});
}
