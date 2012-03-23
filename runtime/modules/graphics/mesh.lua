local Mesh = {}
Mesh.__index = Mesh

local ffi = require 'ffi'

local gl = eiga.alias.gl()

local VALID_DESCRIPTORS = {
  ["IndexPositionColor"] = true;
  ["IndexPositionTexCoord"] = true;
}

local constructor = {
  ["IndexPositionColor"] = function ()
    return {
      vertex_array = eiga.graphics.newVertexArray();
      buffers = {
        index = eiga.graphics.newIndexBuffer( 1024 );
        position = eiga.graphics.newArrayBuffer( "v4f", 1024 );
        color = eiga.graphics.newArrayBuffer( "c4f", 1024 );
      };
    }
  end;
  ["IndexPositionTexCoord"] = function ()
    return {
      vertex_array = eiga.graphics.newVertexArray();
      buffers = {
        index = eiga.graphics.newIndexBuffer( 1024 );
        position = eiga.graphics.newArrayBuffer( "v4f", 1024 );
        texcoord = eiga.graphics.newArrayBuffer( "t2f", 1024 );
      };
    }
  end;
}

local function new ( format )
  assert( VALID_DESCRIPTORS[ format ], string.format("Format (%s) unknown", format) )

  local obj = constructor[format]()

  return setmetatable( obj, Mesh )
end

function Mesh:compile( effect )
  gl.BindVertexArray( self.vertex_array[0] )
    for _, buffer in pairs( self.buffers ) do
      buffer:enable( effect )
    end
    self.buffers.index:enable()
  gl.BindVertexArray( 0 )
end

function Mesh:draw( count, effect )
  eiga.graphics.useEffect( effect )
  gl.BindVertexArray( self.vertex_array[0] )
  gl.DrawElements( gl.TRIANGLES, count, gl.UNSIGNED_SHORT, nil);
  gl.BindVertexArray( 0 )
  eiga.graphics.useEffect()
end

return setmetatable(
  {
    new = new
  },
  {
    __call = function( _, ... ) return new( ... )  end
  }
)
