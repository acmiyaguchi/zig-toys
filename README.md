# zig toy projects

This is a playground for me to learn zig, which is appealing due to the self-contained nature of the compiler and a build-system that's not based on Makefiles and CC.

## notes

### sources

- https://www.reddit.com/r/Zig/comments/16r0fj6/ysk_you_can_use_native_raylib_directly_in_zig_for/
  - Getting raylib to work directly in zig without a wrapper
- https://github.com/raysan5/raylib/tree/master
  - raylib source code
- https://github.com/raysan5/raylib/issues/3895
  - it turns out that the code changed two weeks before I started building the first project. We need to use the `try` keyword to unwrap the results.
- https://github.com/charles-l/zig-odin-raylib-template
  - A non-trivial example of creating a wasm project with zig, raylib, and emscripten.
- https://ziggit.dev/t/using-raygui-with-raylib/3399/7
  - A discussion on why there's so much struggle to get raygui to work, and a solution further down.
- https://github.com/Durobot/raylib-zig-examples/tree/main/zig-raylib-43-shapes-draw-circle_sector
  - Source for `raygui_impl.c`
