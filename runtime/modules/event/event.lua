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

if not eiga.event then eiga.event = {} end

local glfw = eiga.alias.glfw()

local queue = {}

function eiga.event.init ()
end

function eiga.event.push ( event, ... )
  table.insert( queue, { event, unpack( {...} ) } )
end

function eiga.event.pump ()
  glfw.PollEvents()
  if glfw.GetWindowParam( glfw.OPENED ) == glfw.FALSE then
    eiga.event.push( "quit" )
  end
end

function eiga.event.poll ( )
  return function ( )
    if #queue < 1 then
      return nil
    else
      return unpack( table.remove( queue, 1 ) )
    end
  end
end

function eiga.event.deinit ()
end

return eiga.event
