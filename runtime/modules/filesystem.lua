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

if not eiga.filesystem then eiga.filesystem = {} end

------------------------
-- remove upon release
  local ffi = require 'ffi'
--------------------------------

local physfs = eiga.alias.physfs()

local function check_error( return_value, non_error_value, call, more )
  if return_value ~= non_error_value then
    local s = string.format("\n\nfilesystem.%s failed:\n\t%s\n\t%s\n", call,
      ffi.string( physfs.getLastError() ),
      ffi.string( more ) )
    error( s )
  end
end

function eiga.filesystem.init( argv0 )
  local err = physfs.init( argv0 )
  if err ~= 1 then
    error( physfs.getLastError() )
  end
end

function eiga.filesystem.set_source( c_path )
  local err = physfs.mount( c_path, nil, 1 )
  check_error( err, 1, "set_source", c_path )
end

return eiga.filesystem
