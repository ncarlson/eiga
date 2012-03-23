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

local sqrt, cos, sin = math.sqrt, math.cos, math.sin

local vec3 = require 'math.vec3'

local vec4 = {}
vec4.__index = vec4

local function new(x,y,z,w)
  local v = {x, y, z, w}
  setmetatable(v, vec4)
  return v
end

local function isvec4(v)
  return getmetatable(v) == vec4
end

function vec4:clone()
  return new(self[1], self[2], self[3], self[4])
end

function vec4:unpack()
  return self[1], self[2], self[3], self[4]
end

function vec4:__tostring()
  return string.format("(%.4f, %.4f, %.4f, %.4f)", self[1], self[2], self[3], self[4])
end

function vec4.__unm(a)
  return new(-a[1], -a[2], -a[3], -a[4])
end

function vec4.__add(a,b)
  assert(isvec4(a) and isvec4(b), "Add: wrong argument types (<vec4> expected)")
  return new(a[1]+b[1], a[2]+b[2], a[3]+b[3], a[4]+b[4])
end

function vec4.__sub(a,b)
  assert(isvec4(a) and isvec4(b), "Sub: wrong argument types (<vec4> expected)")
  return new(a[1]-b[1], a[2]-b[2], a[3]-b[3], a[4]-b[4])
end

function vec4.__mul(a,b)
  if type(a) == "number" then
    return new(a*b[1], a*b[2], a*b[3], a*b[4])
  elseif type(b) == "number" then
    return new(b*a[1], b*a[2], b*a[3], b*a[4])
  else
    assert(isvec4(a) and isvec4(b), "Mul: wrong argument types (<vec4> or <number> expected)")
    return a[1]*b[1] + a[2]*b[2] + a[3]*b[3] + a[4]*b[4]
  end
end

function vec4.__div(a,b)
  assert(isvec4(a) and type(b) == "number", "wrong argument types (expected <vec4> / <number>)")
  return new(a[1] / b, a[2] / b, a[3] / b, a[4] / b)
end

function vec4.__eq(a,b)
  return a[1] == b[1] and a[2] == b[2] and a[3] == b[3] and a[4] == b[4]
end

function vec4:len2()
  return self[1] * self[1] + self[2] * self[2] + self[3] * self[3] + self[4] * self[4]
end

function vec4:dot(a)
  return self[1] * a[1] + self[2] * a[2] + self[3] * a[3] + self[4] * a[4]
end

function vec4:len()
  return sqrt(self:len2())
end

function vec4.dist(a, b)
  assert(isvec4(a) and isvec4(b), "dist: wrong argument types (<vec4> expected)")
  return (b-a):len()
end

function vec4:normalize_inplace()
  local l = self:len()
  self[1], self[2], self[3] = self[1] / l, self[2] / l, self[3] / l, self[4] / l
  return self
end

local function normalize(a)
  return a / a:len()
end

function vec4:normalized()
  return self / self:len()
end

function vec4:rotatex_inplace(phi)
  local c = cos(phi)
  local s = sin(phi)
  self[2] = c * self[2] - s * self[3]
  self[3] = s * self[2] + c * self[3]
  return self
end

function vec4:rotatey_inplace(phi)
  local c = cos(phi)
  local s = sin(phi)
  self[3] = c * self[3] - s * self[1]
  self[1] = s * self[3] + c * self[1]
  return self
end

function vec4:rotatez_inplace(phi)
  local c = cos(phi)
  local s = sin(phi)
  self[1] = c * self[1] - s * self[2]
  self[2] = s * self[1] + c * self[2]
  return self
end

function vec4:rotatex(phi)
  return self:clone():rotatex_inplace(phi)
end

function vec4:rotatey(phi)
  return self:clone():rotatey_inplace(phi)
end

function vec4:rotatez(phi)
  return self:clone():rotatez_inplace(phi)
end

function vec4:rotate(v, a)
  x, y, z = self:unpack()
  u, v, w = v:normalized():unpack()

  local x_ = u * (u * x + v * y + w * z) * (1 - cos(a)) + x * cos(a) + (-w * y + v * z) * sin(a)
  local y_ = v * (u * x + v * y + w * z) * (1 - cos(a)) + y * cos(a) + (w * x - u * z) * sin(a)
  local z_ = w * (u * x + v * y + w * z) * (1 - cos(a)) + z * cos(a) + (-v * x + u * y) * sin(a)

  return new(x_, y_, z_)
end

function vec4:cross(other)
  local a = vec3(self[1], self[2], self[3])
  local b = vec3(0,0,0)
  local c = vec3(other[1], other[2], other[3])
  b[1] = (a[2] * c[3]) - (a[3] * c[2])
  b[2] = (a[3] * c[1]) - (a[1] * c[3])
  b[3] = (a[1] * c[2]) - (a[2] * c[1])
  return new(b[1], b[2], b[3], 1.0)
end

return setmetatable(
  {
    new = new,
    isvec4 = isvec4,
    normalize = normalize
  },
  {__call = function(_,...) return new(...) end})

