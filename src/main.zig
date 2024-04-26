const std = @import("std");
const raylib = @cImport(@cInclude("raylib.h"));

pub fn main() !void {
    raylib.InitWindow(960, 540, "Tree");
    raylib.SetTargetFPS(144);
    defer raylib.CloseWindow();

    while (!raylib.WindowShouldClose()) {
        raylib.BeginDrawing();
        raylib.ClearBackground(raylib.BLACK);
        raylib.EndDrawing();
    }
}
