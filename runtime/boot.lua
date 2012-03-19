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

if not eiga then eiga = {} end

eiga.path = {}
eiga.arg = {}

local arg = {...}

__VERSION = {
  MAJOR = "0";
  MINOR = "0";
  POINT = "1";
}

local function preload()
  local ffi = require("ffi")

  local clib_ext = jit.os == "Windows" and "dll" or
                   jit.os == "OSX" and "dylib" or
                   jit.os == "Linux" and "so"
  package.path = package.path .. ";runtime/lua/?.lua;runtime/modules/?.lua"
  package.cpath = package.cpath .. ";runtime/"..jit.os.."/clibs/?.".. clib_ext ..";"

  local lfs = require("lfs")
  local working_directory = lfs.currentdir()
  eiga.arg.argv0 = ffi.new("char[?]", #working_directory, working_directory)
  src_dir = eiga.path.add_final_slash(
        eiga.path.normalize_slashes( working_directory .. '/' .. arg[1] )
      )

  eiga.arg.c_src_dir = ffi.new("char[?]", #src_dir, src_dir)
  package.path = package.path .. ";"..src_dir.."/?.lua;"..src_dir.."/?/init.lua"

  package.preload['eiga'] = function () end

  for k,v in pairs({
    "filesystem",
    "graphics",
    "event",
    "timer",
    "keyboard",
    "mouse",
    "image",
    "font",
    "audio",
    "sound",
    "physics",
    "network"
  }) do
    package.preload['eiga.'..v] = function ()
      require( v )
    end
  end

end

-- @brief Backslashes are replaced with forward slashes
-- @param p string path
-- @return string with \ changed to /
-- @credit Love2d (https://bitbucket.org/rude/love/)
function eiga.path.normalize_slashes( p )
  return string.gsub( p, "\\", "/" )
end

-- @brief Adds a slash to the end of path p
-- @param p path
-- @return string with one trailing slash
-- @credit Love2d (https://bitbucket.org/rude/love/)
function eiga.path.add_final_slash( p )
  if string.sub( p, string.len( p ) - 1 ) ~= "/" then
    assert( p[-1] ~= "/" )
    return p .. "/"
  else
    assert( p[-1] == "/" )
    return p
  end
end

-- @brief Determine if path is an absolute path or relative path
-- @param p string path
-- @return boolean true if p is an absolute path, else false
-- @credit Love2d (https://bitbucket.org/rude/love/)
function eiga.path.is_absolute( p )
  local tmp = eiga.path.normalize_slashes( p )
  -- Does path start with forward slash?
  if string.find( tmp, "/" ) == 1 then
    return true
  end
  -- Does the path start with a letter followed by a colon?
  if string.find( tmp, "%a:" ) == 1 then
    return true
  end
  return false
end

-- @brief Construct the absolute path of the input path
-- @param p string path
-- @return string absolute path of p
-- @credit Love2d (https://bitbucket.org/rude/love/)
function eiga.path.get_absolute_path( p )
  if eiga.path.is_absolute( p ) then
    return eiga.path.normalize_slashes( p )
  end

  local working_directory = eiga.filesystem.get_working_directory()
  working_directory = eiga.path.normalize_slashes( working_directory )
  working_directory = eiga.path.add_final_slash( working_directory )

  local absolute_path = eiga.path.normalize_slashes( p )

  -- Remove trailing forward slash
  return absolute_path:match( "(.-)/%.$" ) or absolute_path
end

-- @brief Find and return the leaf of the input path
-- @param p string path
-- @return string the leaf path of p
-- @credit Love2d (https://bitbucket.org/rude/love/)
function eiga.path.leaf( p )
  local dir = 1
  local last = p

  while dir do
    dir = string.find( p, "/", dir + 1 )

    if dir then
      last = string.sub( p, dir + 1)
    end
  end

  return last
end

-- @brief Finds the lowest integral key of input table.
-- @param t table
-- @return number key with lowest integral index
-- @credit Love2d (https://bitbucket.org/rude/love/)
function eiga.arg.get_lowest( t )
  local m = math.huge
  for k,v in pairs( t ) do
    if k < m then
      m = k
    end
  end
  return t[m]
end

-- @brief
-- @param m
-- @param i
-- @return
function eiga.arg.parse_option(m, i)
  m.set = true

  if m.a > 0 then
    m.arg = {}
    for j=i,i+m.a-1 do
      table.insert(m.arg, arg[j])
      i = j
    end
  end

  return i
end

-- @brief
function eiga.arg.parse_options()

  local game
  local argc = #arg

  for i=1,argc do
    -- Look for options.
    local s, e, m = string.find(arg[i], "%-%-(.+)")

    if m and eiga.arg.options[m] then
      i = eiga.arg.parse_option(eiga.arg.options[m], i+1)
    elseif not game then
      game = i
    end
  end

  if not eiga.arg.options.game.set then
    eiga.arg.parse_option(eiga.arg.options.game, game or 0)
  end
end

-- @brief
function eiga.create_handlers()
  eiga.handlers = setmetatable({
    keypressed = function ( keycode, state )
      if eiga.keypressed then eiga.keypressed( keycode ) end
    end,
    keyreleased = function ( keycode, state )
      if eiga.keyreleased then eiga.keyreleased( keycode ) end
    end,
    mousepressed = function ( button )
      if eiga.mousepressed then eiga.mousepressed( button ) end
    end,
    mousereleased = function ( button )
      if eiga.mousereleased then eiga.mousereleased( button ) end
    end,
    resized = function ( width, height )
      if eiga.resized then eiga.resized( width, height ) end
    end,
    quit = function ()
      return
    end,
  }, {
    __index = function(self, name)
      error("Unknown event: " .. name)
    end,
  })

end

-- @brief
function eiga.boot()
  require 'eiga'

  -- load the ffi libraries
  eiga.ffi = {
    glfw = require 'glfw';
    gl = require 'glewgl';
    physfs = require 'physfs';
  }

  do
    --[[
    A table of helper functions which return aliases to the ffi libraries.
    Example:

       without alias:
           local gl = eiga.ffi.gl
           gl.glEnable( gl.GL_DEPTH_TEST )

       with alias:
           local gl = eiga.alias.gl()
           gl.Enable( gl.DEPTH_TEST )
    --]]
    eiga.alias = {
      glfw = function ()
        local alias = {}
        setmetatable(alias, { __index = function(t, n)
          return n:find('[a-z]') and eiga.ffi.glfw['glfw'..n] or
                                     eiga.ffi.glfw['GLFW_'..n] or nil
        end })
        return alias
      end;

      glew = function ()
        local alias = {}
        setmetatable(alias, { __index = function(t, n)
          return n:find('[a-z]') and eiga.ffi.gl['glew'..n] or nil
        end })
        return alias
      end;

      gl = function ()
        local alias = {}
        setmetatable(alias, { __index = function(t, n)
          return n:find('[a-z]') and eiga.ffi.gl['gl'..n] or
                                     eiga.ffi.gl['GL_'..n] or nil
        end })
        return alias
      end;

      physfs = function ()
        local alias = {}
        setmetatable(alias, { __index = function(t, n)
          return n:find('[a-z]') and eiga.ffi.physfs['PHYSFS_'..n] or nil
        end })
        return alias
      end;
    }
  end

  require 'eiga.filesystem'

  eiga.filesystem.init( eiga.arg.argv0 )



  eiga.filesystem.set_source( eiga.arg.c_src_dir )
end

-- @brief
function eiga.init()
  eiga._versionstring = string.format( "eiga (%d.%d.%d)", __VERSION.MAJOR,
                                                          __VERSION.MINOR,
                                                          __VERSION.POINT)
  local options = {
    screen = {
      width = 640;
      height = 480;
      fullscreen = false;
      red = 8;
      green = 8;
      blue = 8;
      alpha = 8;
      depth = 24;
      stencil = 8;
    }
  }

  require 'config'

  if eiga.config then
    eiga.config( options )
  else
    error( "config file not found" )
  end

  for k,v in pairs({
    "graphics",
    "event",
    "timer",
    "keyboard",
    "mouse",
    "image",
    "font",
    "audio",
    "sound",
    "physics",
    "network"
  }) do
    require ('eiga.' .. v)
  end

  eiga.create_handlers()

  if eiga.graphics then
    eiga.graphics.init()
    eiga.graphics.set_mode( options.screen )
  end

  if eiga.timer then
    eiga.timer.init()
    eiga.timer.step()
  end

  if eiga.event then
    eiga.event.init()
  end

  if eiga.keyboard then
    eiga.keyboard.init()
  end

  if eiga.mouse then
    eiga.mouse.init()
  end

  require 'main'
end

-- @brief
function eiga.run()
  if eiga.load then eiga.load( eiga.arg ) end

  local dt = 0

  while true do
    if eiga.event then
      eiga.event.pump()
      for e,a,b,c,d in eiga.event.poll() do
        if e == "quit" then
          if not eiga.quit or not eiga.quit() then
            if eiga.audio then
              eiga.audio.stop()
            end
            return
          end
        end
        if eiga.handlers[e] then
          eiga.handlers[e](a,b,c,d)
        end
      end
    end

    if eiga.timer then
      eiga.timer.step()
      dt = eiga.timer.get_delta()
    end

    if eiga.update then eiga.update(dt) end

    if eiga.graphics then
      eiga.graphics.clear()
      if eiga.draw then eiga.draw() end
    end

    if eiga.timer then eiga.timer.sleep(0.001) end
    if eiga.graphics then eiga.graphics.present() end
  end
end

function eiga.shutdown ()
  eiga.graphics.deinit()
end

preload()
eiga.boot()
eiga.init()
eiga.run()
eiga.shutdown()
