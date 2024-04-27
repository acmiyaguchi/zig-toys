// This is an implementation of a counter, following the first of the 7guis. This
// was tricker to implement than expected due to issues with the raygui bindings
// and failures in the zig cImport system [1]. Instead of including the implementation
// in the header, we build a static library that we include during the build process.
//
// The actual implementation here is quite simple due to intermediate mode graphics. This
// means that we don't have to worry about callback hell and other issues that come with
// general GUI programming. Here, we just share mutable state between elements and deal
// with synchronous events.
//
// [1]: https://ziggit.dev/t/using-raygui-with-raylib/3399/7
const std = @import("std");
const raygui = @cImport(@cInclude("raygui.h"));

pub fn main() !void {
    raygui.InitWindow(200, 50, "Counter");
    raygui.SetTargetFPS(60);
    var counter: c_int = 0;

    while (!raygui.WindowShouldClose()) {
        raygui.BeginDrawing();
        defer raygui.EndDrawing();
        raygui.ClearBackground(raygui.RAYWHITE);
        _ = raygui.GuiValueBox(
            raygui.Rectangle{
                .x = 10,
                .y = 10,
                .width = 80,
                .height = 30,
            },
            null,
            &counter,
            0,
            100,
            false,
        );
        if (raygui.GuiButton(
            raygui.Rectangle{
                .x = 110,
                .y = 10,
                .width = 80,
                .height = 30,
            },
            "Count",
        ) > 0) {
            counter += 1;
        }
    }
}
