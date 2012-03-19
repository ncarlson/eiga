local ffi = require 'ffi'
ffi.cdef [[

]]

return ffi.load( jit.os == "OSX" and "runtime/OSX/todo" or
                 jit.os == "Linux" and "runtime/Linux/todo" or
                 jit.os == "Windows" and "runtime/Windows/freetype249.dll")

