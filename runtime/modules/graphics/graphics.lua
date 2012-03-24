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
local soil = eiga.ffi.soil

local Effect = require 'graphics.effect'
local ArrayBuffer = require 'graphics.arraybuffer'
local IndexBuffer = require 'graphics.indexbuffer'
local Mesh = require 'graphics.mesh'

local ffi = require 'ffi'

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
  glfw.OpenWindowHint( glfw.FSAA_SAMPLES, mode.fsaa )
  glfw.OpenWindow(mode.width, mode.height,
                  mode.red, mode.green, mode.blue, mode.alpha,
                  mode.depth, mode.stencil,
                  mode.fullscreen and glfw.FULLSCREEN or glfw.WINDOW)
  glfw.SwapInterval( mode.vsync and 1 or 0 )
  glfw.SetWindowTitle( mode.title or eiga._versionstring )

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

function eiga.graphics.newEffect( vertex_shader_path, fragment_shader_path )
  local vs_src = eiga.filesystem.read( vertex_shader_path )
  local fs_src = eiga.filesystem.read( fragment_shader_path )
  return Effect( vs_src, fs_src )
end

function eiga.graphics.newVertexArray ()
  local vertex_array_name = ffi.new( "GLuint[1]" )
  gl.GenVertexArrays( 1, vertex_array_name )
  return vertex_array_name
end

function eiga.graphics.useVertexArray ( vertex_array_name )
  gl.BindVertexArray( vertex_array_name )
end

function eiga.graphics.newArrayBuffer ( format, size )
  return ArrayBuffer( format, size )
end

function eiga.graphics.newIndexBuffer ( size )
  return IndexBuffer( size )
end

function eiga.graphics.useEffect( effect )
  gl.UseProgram( effect and effect.program or 0 )
end

function eiga.graphics.draw ( primitive_type, index_count, index_type )
  gl.DrawElements( primitive_type, index_count, index_type, nil);
end

function eiga.graphics.newMesh ( format )
  return Mesh( format )
end

function eiga.graphics.newTexture ( path, near_filter, far_filter )
  local buffer, size = eiga.filesystem.read( path )
  local tex_2d = soil.SOIL_load_OGL_texture_from_memory(
    buffer,
    size,
    soil.SOIL_LOAD_AUTO,
    soil.SOIL_CREATE_NEW_ID,
    0
  );
  gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, near_filter)
  gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, far_filter)

  return tex_2d
end

function eiga.graphics.newImage( path )
  local buffer, size = eiga.filesystem.read( path )
  local width, height = ffi.new("int[1]"), ffi.new("int[1]")
  local channels = ffi.new("int[1]")
  local image = soil.SOIL_load_image_from_memory( buffer, size, width, height,
                                                  channels, 0 )
  return {
    data = image;
    size = size;
    width = width;
    height = height;
    channels = channels;
  }
end

return eiga.graphics
