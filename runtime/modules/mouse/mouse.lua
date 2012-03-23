-- Copyright (C) 2012 Nicholas Carlson
--
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the "Software"),
-- to deal in the Software without restriction, including without limitation
-- the rights to use, copy, modify, merge, publish, distribute, sublicense,
-- and/or sell copies of the Software, and to permit persons to whom the
-- Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.

if not eiga.mouse then eiga.mouse = {} end

local glfw = eiga.alias.glfw()

local ffi = require 'ffi'

function eiga.mouse.init ()
  jit.off( glfw.SetMouseButtonCallback( eiga.mouse.button_callback ) )
  eiga.mouse.x, eiga.mouse.y = ffi.new( "int[1]" ), ffi.new( "int[1]" )
end

function eiga.mouse.button_callback ( button, state )
  eiga.event.push(state == glfw.PRESS and "mousepressed" or
                                          "mousereleased", button)
end

function eiga.mouse.isdown ( keycode )
  return glfw.GetMouseButton( keycode or -1 ) == glfw.PRESS
end

function eiga.mouse.getPosition ()
  glfw.GetMousePos( eiga.mouse.x, eiga.mouse.y )
  return eiga.mouse.x[0], eiga.mouse.y[0]
end

function eiga.mouse.deinit ()
end

return eiga.event
