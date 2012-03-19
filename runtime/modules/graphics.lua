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

if not eiga.graphics then eiga.graphics = {} end

local glfw = eiga.alias.glfw()
local glew = eiga.alias.glew()
local gl = eiga.alias.gl()


function eiga.graphics.init ()
  assert( glfw.Init() )
  -- disable automatic polling of events
  glfw.Disable( glfw.AUTO_POLL_EVENTS )
  eiga.graphics.has_set_mode = false
  eiga.graphics.screen = {
    width = -1;
    height = -1;
  }
end

function eiga.graphics.window_resize_callback ( width, height )
  eiga.event.push("resized", width, height)
end

function eiga.graphics.set_mode ( mode )
  local fullscreen = mode.fullscreen and glfw.FULLSCREEN or glfw.WINDOW
  glfw.OpenWindowHint( glfw.FSAA_SAMPLES, mode.fsaa )
  glfw.OpenWindow(mode.width, mode.height,
                  mode.red, mode.green, mode.blue, mode.alpha,
                  mode.depth, mode.stencil, fullscreen)

  local swap_interval = mode.vsync and 1 or 0
  glfw.SwapInterval( swap_interval )

  local window_title = mode.title or eiga._versionstring
  glfw.SetWindowTitle( window_title )

  eiga.graphics.screen = mode

  if not eiga.graphics.has_set_mode then
    jit.off(
      glfw.SetWindowSizeCallback( eiga.graphics.window_resize_callback )
    )
    glew.Init()
    eiga.graphics.has_set_mode = true
  end
end

function eiga.graphics.clear ()
  gl.Clear( bit.bor( gl.COLOR_BUFFER_BIT, gl.DEPTH_BUFFER_BIT ) )
end

function eiga.graphics.present ()
  glfw.SwapBuffers()
end

function eiga.graphics.deinit ()
  glfw.Terminate()
end

return eiga.graphics
