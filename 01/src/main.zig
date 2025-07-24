const std = @import("std");
pub fn main() !void {
    // Part 2 Example:
    // 3   4 -> left: 3, right: 4
    // 4   3 -> left: 4, right: 3
    // 2   5 -> left: 2, right: 5
    // 1   3 -> left: 1, right: 3
    // 3   9 -> left: 3, right: 9
    // 3   3 -> left: 3, right: 3
    // Left list: [3,4,2,1,3,3], Right list: [4,3,5,3,9,3]
    // For each left number, count occurrences in right list:
    // 3 appears 3 times in right: 3*3=9
    // 4 appears 1 time in right: 4*1=4
    // 2 appears 0 times in right: 2*0=0
    // 1 appears 0 times in right: 1*0=0
    // 3 appears 3 times in right: 3*3=9
    // 3 appears 3 times in right: 3*3=9
    // Total similarity score: 9+4+0+0+9+9 = 31

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

    // calculate similarity score
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

    // print the similarity score
    std.debug.print("Similarity score: {}\n", .{similarity_score});
}
