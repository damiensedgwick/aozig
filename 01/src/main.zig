const std = @import("std");
pub fn main() !void {
    // Example:
    // 3   4 -> left: 3, right: 4
    // 4   3 -> left: 4, right: 3
    // 2   5 -> left: 2, right: 5
    // 1   3 -> left: 1, right: 3
    // 3   9 -> left: 3, right: 9
    // 3   3 -> left: 3, right: 3
    // After sorting: left: [1,2,3,3,3,4], right: [3,3,3,4,5,9]
    // Pairs: (1,3)=2, (2,3)=1, (3,3)=0, (3,4)=1, (3,5)=2, (4,9)=5
    // Total: 2+1+0+1+2+5 = 11

    // first we get the current working directory
    const cwd: std.fs.Dir = std.fs.cwd();

    // try to open the file
    const file = try cwd.openFile("src/input.txt", .{});
    defer file.close();

    // read the file
    const file_contents = try file.readToEndAlloc(std.heap.page_allocator, 1024 * 1024);
    defer std.heap.page_allocator.free(file_contents);

    // split the file contents into lines
    var lines = std.mem.splitSequence(u8, file_contents, "\n");

    // create arrays to store the left and right numbers
    var left_list = std.ArrayList(i32).init(std.heap.page_allocator);
    defer left_list.deinit();

    var right_list = std.ArrayList(i32).init(std.heap.page_allocator);
    defer right_list.deinit();

    // iterate over the lines
    while (lines.next()) |line| {
        if (line.len == 0) continue; // skip empty lines

        // split the line into two numbers
        var numbers = std.mem.splitSequence(u8, line, "   "); // three spaces as separator

        const first_str = numbers.next() orelse continue;
        const second_str = numbers.next() orelse continue;

        // parse the numbers
        const first = std.fmt.parseInt(i32, first_str, 10) catch continue;
        const second = std.fmt.parseInt(i32, second_str, 10) catch continue;

        // add to respective lists
        left_list.append(first) catch continue;
        right_list.append(second) catch continue;
    }

    // sort both lists
    std.mem.sort(i32, left_list.items, {}, std.sort.asc(i32));
    std.mem.sort(i32, right_list.items, {}, std.sort.asc(i32));

    // calculate total distance by pairing sorted numbers
    var total_distance: i32 = 0;
    for (left_list.items, right_list.items) |left_num, right_num| {
        const distance = if (left_num > right_num) left_num - right_num else right_num - left_num;
        total_distance += distance;
    }

    // print the total distance
    std.debug.print("Total distance: {}\n", .{total_distance});
}
