local Effect = {}
Effect.__index = Effect

local ffi = require 'ffi'

local gl = eiga.alias.gl()

local function checkProgram (program)
  if not program then return false end
  local result = ffi.new("GLint[1]", gl.FALSE)
  gl.GetProgramiv(program, gl.LINK_STATUS, result)
  local infologlength = ffi.new("int[1]")
  gl.GetProgramiv(program, gl.INFO_LOG_LENGTH, infologlength)
  local infolog = ffi.new("char[?]", infologlength[0])
  gl.GetProgramInfoLog(program, infologlength[0], nil, infolog)
  if result[0] ~= gl.TRUE then
    error(string.format("Link error %s:", ffi.string(infolog)))
  end
end

local function checkShader (shader)
  if not shader then return false end
  local result = ffi.new("GLint[1]", gl.FALSE)
  gl.GetShaderiv(shader, gl.COMPILE_STATUS, result)
  local infologlength = ffi.new("int[1]")
  gl.GetShaderiv(shader, gl.INFO_LOG_LENGTH, infologlength)
  local infolog = ffi.new("char[?]", infologlength[0])
  gl.GetShaderInfoLog(shader, infologlength[0], nil, infolog)
  if result[0] ~= gl.TRUE then
    error(string.format("Compile error %s:", ffi.string(infolog)))
  end
end

local function compile(type, source)
  local shader = gl.CreateShader(type)
  local cptr_source = ffi.new("const char*[1]", source)
  gl.ShaderSource(shader, 1, cptr_source, nil )
  gl.CompileShader(shader)
  checkShader(shader)
  return shader
end

local function new ( vs_src, fs_src )
  local obj = {
    source = {
      vs = vs_src;
      fs = fs_src;
    };
    shader = {
      vs = compile( gl.VERTEX_SHADER, vs_src );
      fs = compile( gl.FRAGMENT_SHADER, fs_src );
    };
    program = gl.CreateProgram();
    l_cache = {};
    c_cache = {};
    gl_cache = {};
  }

  gl.AttachShader( obj.program, obj.shader.vs )
  gl.AttachShader( obj.program, obj.shader.fs )
  gl.LinkProgram( obj.program )

  return setmetatable( obj, Effect )
end

function Effect:sendMatrix4 ( matrix, name )
  eiga.graphics.useEffect( self )
  if matrix ~= self.l_cache[name] then
    self.l_cache[name] = matrix
    self.c_cache[name] = ffi.new( "GLfloat[?]", 16, matrix )
    self.gl_cache[name] = gl.GetUniformLocation(self.program, name)
    assert( self.gl_cache[name] ~= -1, name )
  end

  gl.UniformMatrix4fv( self.gl_cache[name], 1, gl.FALSE, self.c_cache[name] )
  eiga.graphics.useEffect()
end

function Effect:sendTexture ( texture, name )
  eiga.graphics.useEffect( self )
  if not self.l_cache[name] then
    self.l_cache[name] = texture
    self.gl_cache[name] = gl.GetUniformLocation(self.program, name)
    assert( self.gl_cache[name] ~= -1, name )
  end

  gl.Uniform1i( self.gl_cache[name], texture )
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

