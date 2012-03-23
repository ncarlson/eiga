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

local gl = eiga.alias.gl()
local glfw = eiga.alias.glfw()

local cube_vertices = {
  back = { { .5, .5, -.5, }, { .5, -.5, -.5 }, { -.5, -.5, -.5 }, { -.5, .5, -.5 } },
  front = { { -.5, .5, .5, }, { -.5, -.5, .5 }, { .5, -.5, .5 }, { .5, .5, .5 } },
  left = { { -.5, .5, -.5, }, { -.5, -.5, -.5 }, { -.5, -.5, .5 }, { -.5, .5, .5 } },
  right = { { .5, .5, .5, }, { .5, -.5, .5 }, { .5, -.5, -.5 }, { .5, .5, -.5 } },
  top = { { .5, .5, .5, }, { .5, .5, -.5 }, { -.5, .5, -.5 }, { -.5, .5, .5 } },
  bottom = { { -.5, -.5, .5, }, { -.5, -.5, -.5 }, { .5, -.5, -.5 }, { .5, -.5, .5 } }
}

function eiga.load ( args )
  gl.Enable( gl.CULL_FACE )
  gl.Enable( gl.DEPTH_TEST )
  gl.DepthFunc( gl.LESS )
end

function eiga.draw ()
  gl.PushMatrix()
  gl.Translatef( 0, 0, -2 )
  gl.Rotatef( eiga.timer.get_time() * 31, 0, 1, 0 )
  gl.Rotatef( eiga.timer.get_time() * 17, 0, 0, 1 )
  gl.Begin( gl.QUADS )
    gl.Color3f( 1, 0, 0 )
    for _,v in pairs( cube_vertices.back ) do gl.Vertex3f( unpack( v ) ) end
    gl.Color3f( 1, 0, 1 )
    for _,v in pairs( cube_vertices.front ) do gl.Vertex3f( unpack( v ) ) end
    gl.Color3f( 0, 1, 0 )
    for _,v in pairs( cube_vertices.left ) do gl.Vertex3f( unpack( v ) ) end
    gl.Color3f( 0, 1, 1 )
    for _,v in pairs( cube_vertices.right ) do gl.Vertex3f( unpack( v ) ) end
    gl.Color3f( 0, 0, 1 )
    for _,v in pairs( cube_vertices.top ) do gl.Vertex3f( unpack( v ) ) end
    gl.Color3f( 1, 1, .5 )
    for _,v in pairs( cube_vertices.bottom ) do gl.Vertex3f( unpack( v ) ) end
  gl.End()
  gl.PopMatrix()
end

function eiga.keypressed ( key )
  if key == glfw.KEY_ESC then
    eiga.event.push("quit")
  end
end

function eiga.resized ( width, height )
  function perspective ( fov, aspect, near, far )
    local ymax = near * math.tan( fov * 3.14159265 / 360 )
    local ymin = -ymax
    local xmin = ymin * aspect
    local xmax = ymax * aspect
    gl.Frustum( xmin, xmax, ymin, ymax, near, far )
  end

  gl.Viewport( 0, 0, width, height )
  gl.MatrixMode( gl.PROJECTION )
  gl.LoadIdentity()
  perspective( 55, width / height, 0.1, 100 )
  gl.MatrixMode( gl.MODELVIEW )
end
