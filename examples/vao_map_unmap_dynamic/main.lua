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

local ffi = require 'ffi'

local gl = eiga.alias.gl()
local glfw = eiga.alias.glfw()

local data = {
  position = { 10, 10, 0, 1,
             10, 100, 0, 1,
             100, 100, 0, 1,
             100, 10, 0, 1  };
  color = { 1, .1, 0, 1,
             1, 1, 0, 1,
             0, .1, 1, 1,
             1, 0, 1, 1 };
  index = { 0, 1, 2, 0, 2, 3 };
}

local mesh = eiga.graphics.newMesh( "IndexPositionColor" )

local effect = eiga.graphics.newEffect( "assets/effect.vert",
                                        "assets/effect.frag" );

function eiga.load ( args )
  gl.Enable( gl.CULL_FACE )
  gl.Enable( gl.DEPTH_TEST )
  gl.DepthFunc( gl.LESS )

  for i=#data.position+1, 1024 do data.position[i] = 0 end
  mesh.buffers.position:setData( data.position )
  for i=#data.color+1, 1024 do data.color[i] = 0 end
  mesh.buffers.color:setData( data.color )
  mesh.buffers.index:setData( data.index )

  mesh:compile( effect )
end

function eiga.update ( dt )
  data.position[9], data.position[10] = eiga.mouse.getPosition()
  mesh.buffers.position:setData( data.position )
end

function eiga.draw ()
  mesh:draw( #data.index, effect )
end

function eiga.keypressed ( key )
  if key == glfw.KEY_ESC then
    eiga.event.push("quit")
  end
end

function eiga.resized ( width, height )
  gl.Viewport( 0, 0, width, height )
  gl.MatrixMode(gl.PROJECTION)
  gl.LoadIdentity()
  gl.Ortho( 0, width, height, 0, 0, 1 )
  gl.MatrixMode(gl.MODELVIEW)
  gl.LoadIdentity()
end
