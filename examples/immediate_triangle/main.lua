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

gl = eiga.alias.gl()
glfw = eiga.alias.glfw()

function eiga.load ( args )
end

function eiga.update ( dt )
end

function eiga.draw ()
  gl.Begin( gl.TRIANGLES )
    gl.Color3f( 1, 0, 0 )
    gl.Vertex2f( 0, 100 )
    gl.Color3f( 0, 1, 0 )
    gl.Vertex2f( -100, -50 )
    gl.Color3f( 0, 0, 1 )
    gl.Vertex2f( 100, -50 )
  gl.End()
end

function eiga.mousepressed ( button )
end

function eiga.mousereleased ( button )
end

function eiga.keypressed ( key )
  if key == glfw.KEY_ESC then
    eiga.event.push("quit")
  end
end

function eiga.keyreleased ( key )
end

function eiga.resized ( width, height )
  gl.MatrixMode( gl.PROJECTION_MATRIX )
  gl.LoadIdentity()
  gl.Viewport( 0, 0, width, height )
  gl.Ortho( -width / 2, width / 2, -height / 2, height / 2, 0, 1 )
  gl.MatrixMode( gl.MODELVIEW_MATRIX )
end

function eiga.quit()
end

