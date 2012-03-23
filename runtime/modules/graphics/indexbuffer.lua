local IndexBuffer = {}
IndexBuffer.__index = IndexBuffer

local ffi = require 'ffi'

local gl = eiga.alias.gl()

local function new ( size )
  local ffi_length_signature = "GLushort[?]"
  local type_size = ffi.sizeof( "GLushort" )
  local buffer_size = type_size * size
  local buffer_id = ffi.new ( "GLuint[1]" )

  gl.GenBuffers( 1, buffer_id  )
  gl.BindBuffer( gl.ELEMENT_ARRAY_BUFFER, buffer_id[0] )
  gl.BufferData( gl.ELEMENT_ARRAY_BUFFER, buffer_size, nil, gl.STATIC_DRAW )
  gl.BindBuffer( gl.ELEMENT_ARRAY_BUFFER, 0 )

  local obj = {
    buffer_id = buffer_id;
    buffer_size = buffer_size;
    type_size = type_size;
    ffi_length_signature = ffi_length_signature;
  }

  return setmetatable( obj, IndexBuffer )
end

function IndexBuffer:setData( data )
  gl.BindBuffer( gl.ELEMENT_ARRAY_BUFFER, self.buffer_id[0] )
  ffi.copy(
    gl.MapBuffer( gl.ELEMENT_ARRAY_BUFFER, gl.WRITE_ONLY ),
    ffi.new( self.ffi_length_signature, #data, data ),
    self.type_size * #data )
  gl.UnmapBuffer( gl.ELEMENT_ARRAY_BUFFER )
  gl.BindBuffer( gl.ELEMENT_ARRAY_BUFFER, 0 )
end


function IndexBuffer:enable( )
  gl.BindBuffer( gl.ELEMENT_ARRAY_BUFFER, self.buffer_id[0] )
end

return setmetatable(
  {
    new = new
  },
  {
    __call = function( _, ... ) return new( ... )  end
  }
)
