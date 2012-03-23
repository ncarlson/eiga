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

if not eiga.timer then eiga.timer = {} end

local glfw = eiga.alias.glfw()

function eiga.timer.init ()
  glfw.SetTime( 0 )
  eiga.timer.dt = 0
  eiga.timer.last_tick = 0
end

function eiga.timer.set_time ( seconds )
  glfw.SetTime( seconds )
  eiga.timer.dt = 0
  eiga.timer.last_tick = 0
end

function eiga.timer.get_time ()
  return glfw.GetTime()
end

function eiga.timer.step ()
  local current_time = glfw.GetTime()
  eiga.timer.dt = current_time - eiga.timer.last_tick
  eiga.timer.last_tick = current_time
end

function eiga.timer.get_delta ()
  return eiga.timer.dt
end

function eiga.timer.sleep ( seconds )
  glfw.Sleep( seconds )
end

function eiga.timer.deinit ()
end

return eiga.timer
