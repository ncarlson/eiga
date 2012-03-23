local ArrayBuffer = {}
ArrayBuffer.__index = ArrayBuffer

local ffi = require 'ffi'

local gl = eiga.alias.gl()

local BUFFER_LENGTH = 1024 -- 256 vertices, 4-component vectors

local EFFECT_ATTRIBUTE_STRING = {
  v = "Position",
  n = "Normal",
  c = "Color",
  t = "TexCoord"
}

local BUFFER_DATA_TYPE = {
  i = gl.INT,
  I = gl.UNSIGNED_INT,
  f = gl.FLOAT
}

local FFI_LENGTH_SIGNATURE = {
  [gl.INT] = "GLint[?]",
  [gl.UNSIGNED_INT] = "GLuint[?]",
  [gl.FLOAT] = "GLfloat[?]",
}

local TYPE_IDENTIFIER = {
  [gl.INT] = "GLint",
  [gl.UNSIGNED_INT] = "GLuint",
  [gl.FLOAT] = "GLfloat",
}

local function parse ( format )
  if format:find( "[vcnt]" ) then
    local attribute_type, component_count, component_type = format:match("(%C)(%d)(%C)")
    assert( attribute_type )
    assert( component_count )
    assert( component_type )
    return attribute_type, tonumber(component_count), component_type
  else
    error( "parse: Array buffer format not understood\n" )
  end
end

local function new ( format, size )
  local attribute_type, component_count, component_type = parse( format )
  assert( component_type )
  if attribute_type ~= "t" then
    assert( component_count == 4, string.format("For now, buffers need to be homogeneous: %d", component_count) )
  end

  local attribute_pointer_type = BUFFER_DATA_TYPE[ component_type ]
  local ffi_length_signature = FFI_LENGTH_SIGNATURE[ attribute_pointer_type ]
  local type_size = ffi.sizeof( TYPE_IDENTIFIER[ attribute_pointer_type ] )
  local buffer_size = type_size * size
  local buffer_id = ffi.new ( "GLuint[1]" )
  local attribute_string = EFFECT_ATTRIBUTE_STRING[ attribute_type ]
  local component_count = component_count

  gl.GenBuffers( 1, buffer_id  )
  gl.BindBuffer( gl.ARRAY_BUFFER, buffer_id[0] )
  gl.BufferData( gl.ARRAY_BUFFER, buffer_size , nil, gl.STATIC_DRAW )
  gl.BindBuffer( gl.ARRAY_BUFFER, 0 )

  local obj = {
    lua_data = {};
    c_data = {};
    buffer_id = buffer_id;
    attribute_string = attribute_string;
    buffer_size = buffer_size;
    type_size = type_size;
    ffi_length_signature = ffi_length_signature;
    attribute_pointer_type = attribute_pointer_type;
    component_count = component_count;
  }

  return setmetatable( obj, ArrayBuffer )
end

function ArrayBuffer:setData( data )
  -- check if our buffer has enough room the incoming data
  if #data * self.type_size > self.buffer_size then
    -- compute new size of buffer
    self.buffer_size = #data * self.type_size
    gl.BindBuffer( gl.ARRAY_BUFFER, self.buffer_id[0] )
    -- set the buffer to a null pointer, essentially flagging it for gc
    gl.BufferData( gl.ARRAY_BUFFER, self.buffer_size , nil, gl.STATIC_DRAW )
    -- Map the buffer, and add memcopy data
    do
      ffi.copy(
        gl.MapBuffer( gl.ARRAY_BUFFER, gl.WRITE_ONLY ),
        ffi.new( self.ffi_length_signature, #data, data ),
        self.buffer_size)
      gl.UnmapBuffer( gl.ARRAY_BUFFER )
    end
    gl.BindBuffer( gl.ARRAY_BUFFER, 0 )
  else
    -- The incoming data will fit into our existing buffer.
    gl.BindBuffer( gl.ARRAY_BUFFER, self.buffer_id[0] )
    -- Map the buffer and memcopy
    ffi.copy(
      gl.MapBuffer( gl.ARRAY_BUFFER, gl.WRITE_ONLY ),
      ffi.new( self.ffi_length_signature, #data, data ),
      self.buffer_size)
    gl.UnmapBuffer( gl.ARRAY_BUFFER )
    gl.BindBuffer( gl.ARRAY_BUFFER, 0 )
  end
end


function ArrayBuffer:enable( effect )
  gl.BindBuffer( gl.ARRAY_BUFFER, self.buffer_id[0] )
  if not self.attribute_location then
    self.attribute_location = gl.GetAttribLocation( effect.program, self.attribute_string )
  end
  gl.VertexAttribPointer( self.attribute_location, self.component_count, self.attribute_pointer_type, gl.FALSE, 0, nil )
  gl.EnableVertexAttribArray( self.attribute_location )
  gl.BindBuffer( gl.ARRAY_BUFFER, 0 )
end

return setmetatable(
  {
    new = new
  },
  {
    __call = function( _, ... ) return new( ... )  end
  }
)
