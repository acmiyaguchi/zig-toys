const std = @import("std");
const raylib = @cImport(@cInclude("raylib.h"));

const Vector3 = raylib.Vector3;

pub fn main() !void {
    raylib.InitWindow(960, 540, "Tree");
    raylib.SetTargetFPS(60);
    defer raylib.CloseWindow();

    var camera = raylib.Camera{
        .position = Vector3{ .x = 10.0, .y = 10.0, .z = 10.0 },
        .target = Vector3{ .x = 0.0, .y = 0.0, .z = 0.0 },
        .up = Vector3{ .x = 0.0, .y = 1.0, .z = 0.0 },
        .fovy = 45.0,
        .projection = raylib.CAMERA_PERSPECTIVE,
    };

    while (!raylib.WindowShouldClose()) {
        if (raylib.IsKeyDown(raylib.KEY_Z)) {
            camera.target = .{ .x = 0.0, .y = 0.0, .z = 0.0 };
        }
        raylib.UpdateCamera(&camera, raylib.CAMERA_THIRD_PERSON);

        raylib.BeginDrawing();
        raylib.ClearBackground(raylib.WHITE);
        raylib.BeginMode3D(camera);
        // draw a brown cylinder with a green cone on top
        raylib.DrawCylinder(Vector3{ .x = 0.0, .y = 0.0, .z = 0.0 }, 1.0, 1.0, 2.0, 10, raylib.BROWN);
        raylib.DrawCylinder(Vector3{ .x = 0.0, .y = 2.0, .z = 0.0 }, 0.0, 2.0, 4.0, 10, raylib.GREEN);
        raylib.DrawGrid(10, 1.0);
        raylib.EndMode3D();
        raylib.DrawFPS(10, 10);
        raylib.EndDrawing();
    }
}
