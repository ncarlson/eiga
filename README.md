# Eiga

Eiga is a small framework for writing cross-platform games, graphical demos, and interactive art.

The framework is built upon the insanely fast LuaJIT compiler and it's native FFI functionality.

## Examples

* [Immediate Mode Triangle](http://github.com/ncarlson/eiga/blob/master/examples/immediate_triangle/main.lua)
* [Immediate Mode Cube](http://github.com/ncarlson/eiga/blob/master/examples/immediate_cube/main.lua)
* [Dynamic Verticex Buffer](http://github.com/ncarlson/eiga/blob/master/examples/vao_map_unmap_dynamic/main.lua)
* [Shader Centric Rendering](http://github.com/ncarlson/eiga/blob/master/examples/vertex_array_object_cube/main.lua)

## Running the examples

Open a terminal/command-line and cd into eiga's top level director.

###Mac OS X

    ./bin/OSX/x64/luajit runtime/boot.lua examples/immediate_triangle/

###Windows

__64 Bit__

    bin\Windows\x64\luajit.exe runtime\boot.lua examples\immediate_triangle\

__32 Bit__

    bin\Windows\x86\luajit.exe runtime\boot.lua examples\immediate_triangle\

###Linux
__64 Bit__

    ./bin/Linux/x64/luajit runtime/boot.lua examples/immediate_triangle/
__32 Bit__

    ./bin/Linux/x86/luajit runtime/boot.lua examples/immediate_triangle/

## Influences

Eiga's API is heavily influenced by that of [LÖVE](https://love2d.org/), another Lua-based framework.

## Current Status

This project is still very young, and many features still need to be implemented. Feedback, suggestions and bug reports are greatly appreciated.

## License

[MIT License](http://www.opensource.org/licenses/mit-license.html) where applicable. See the docs/legal/ folder.
