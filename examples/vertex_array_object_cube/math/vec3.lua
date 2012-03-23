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

local vec3 = {}
vec3.__index = vec3

local function new(x,y,z)
  local v = {x, y, z}
  setmetatable(v, vec3)
  return v
end

local function from_table( t )
  return new( t[1], t[2], t[3] )
end

local function from_c_table( t )
  return new( t[0], t[1], t[2] )
end

local function isvec3(v)
  return getmetatable(v) == vec3
end

function vec3:clone()
  return new(self[1], self[2], self[3])
end

function vec3:unpack()
  return self[1], self[2], self[3]
end

function vec3:__tostring()
  return string.format("(%.4f, %.4f, %.4f)", self[1], self[2], self[3])
end

function vec3.__unm(a)
  return new(-a[1], -a[2], -a[3])
end

function vec3.__add(a,b)
  assert(isvec3(a) and isvec3(b), "Add: wrong argument types (<vec3> expected)")
  return new(a[1]+b[1], a[2]+b[2], a[3]+b[3])
end

function vec3.__sub(a,b)
  assert(isvec3(a) and isvec3(b), "Sub: wrong argument types (<vec3> expected)")
  return new(a[1]-b[1], a[2]-b[2], a[3]-b[3])
end

function vec3.__mul(a,b)
  if type(a) == "number" then
    return new(a*b[1], a*b[2], a*b[3])
  elseif type(b) == "number" then
    return new(b*a[1], b*a[2], b*a[3])
  else
    assert(isvec3(a) and isvec3(b), "Mul: wrong argument types (<vec3> or <number> expected)")
    return a[1]*b[1] + a[2]*b[2] + a[3]*b[3]
  end
end

function vec3.__div(a,b)
  assert(isvec3(a) and type(b) == "number", "wrong argument types (expected <vec3> / <number>)")
  return new(a[1] / b, a[2] / b, a[3] / b)
end
function vec3:compmul(b)
  return new(self[1] * b[1], self[2] * b[2], self[3] * b[3])
end

function vec3.__eq(a,b)
  return a[1] == b[1] and a[2] == b[2] and a[3] == b[3]
end

function vec3:square()
  return self[1] * self[1] + self[2] * self[2] + self[3] * self[3]
end

function vec3:length()
  return sqrt(self[1] * self[1] + self[2] * self[2] + self[3] * self[3])
end

local function dist (a, b)
  local x, y, z = a[1]-b[1], a[2]-b[2], a[3]-b[3]
  return sqrt(x*x + y*y + z*z)
end

local function dir (a, b)
  local x, y, z = a[1]-b[1], a[2]-b[2], a[3]-b[3]
  local l = sqrt(x*x + y*y + z*z)
  if l == 0 then
    return new(0, 0, 0)
  else
    return new(x/l, y/l, z/l)
  end
end

function vec3:normalize ()
  local l = self:length()
  if l ~= 0 then
    self[1] = self[1] / l
    self[2] = self[2] / l
    self[3] = self[3] / l
  end
  return self
end

function vec3:cross(other)
  return new(self[2] * other[3] - other[2] * self[3],
             self[3] * other[1] - other[3] * self[1],
             self[1] * other[2] - other[1] * self[2])
end

local function cross(a, b)
  return new(a[2] * b[3] - b[2] * a[3],
             a[3] * b[1] - b[3] * a[1],
             a[1] * b[2] - b[1] * a[2])
end

function vec3:dot (b)
  return self[1] * b[1] + self[2] * b[2] + self[3] * b[3]
end

function vec3:unit ()
  local l = sqrt(self[1] * self[1] + self[2] * self[2] + self[3] * self[3])
  return new(self[1] / l, self[2] / l, self[3] / l)
end

function vec3:rotateX(r)
  local c = cos(r)
  local s = sin(r)
  self[2] = c * self[2] - s * self[3]
  self[3] = s * self[2] + c * self[3]
  return self
end

function vec3:rotateY(r)
  local c = cos(r)
  local s = sin(r)
  self[3] = c * self[3] - s * self[1]
  self[1] = s * self[3] + c * self[1]
  return self
end

function vec3:rotateZ(r)
  local c = cos(r)
  local s = sin(r)
  self[1] = c * self[1] - s * self[2]
  self[2] = s * self[1] + c * self[2]
  return self
end

function vec3:rotatev(axis, r)
  local x, y, z = self[1], self[2], self[3]
  local u, v, w = axis[1], axis[2], axis[3]
  local ux = u * x
  local vy = v * y
  local wz = w * z
  local s = sin(r)
  local c = cos(r)


  self[1] = u * (ux + vy + wz) * (1 - c) + x * c + (-w * y + v * z) * s
  self[2] = v * (ux + vy + wz) * (1 - c) + y * c + (w * x - u * z) * s
  self[3] = w * (ux + vy + wz) * (1 - c) + z * c + (-v * x + u * y) * s
end

local function rotateX(v, r)
  return v:clone():rotateX(r)
end

local function rotateY(v, r)
  return v:clone():rotateY(r)
end

local function rotateZ(v, r)
  return v:clone():rotateZ(r)
end

-- rotate vector about axis
-- @precondition axis is a vec3 of unit length
-- @param vector vec3 to rotate
-- @param axis vec3 representing axis of rotation
-- @param r number radians to rotate
local function rotatev(vector, axis, r)
  local x, y, z = vector[1], vector[2], vector[3]
  local u, v, w = axis[1], axis[2], axis[3]
  local ux = u * x
  local vy = v * y
  local wz = w * z
  local s = sin(r)
  local c = cos(r)

  return new(
    u * (ux + vy + wz) * (1 - c) + x * c + (-w * y + v * z) * s,
    v * (ux + vy + wz) * (1 - c) + y * c + (w * x - u * z) * s,
    w * (ux + vy + wz) * (1 - c) + z * c + (-v * x + u * y) * s)
end

return setmetatable(
  {
    new = new,
    from_table = from_table,
    from_c_table = from_c_table,
    isvec3 = isvec3,
    cross = cross,
    dir = dir,
    dist = dist,
    unit = unit,
    rotatev = rotatev,
    rotateX = rotateX,
    rotateY = rotateY,
    rotateZ = rotateZ
  },
  {__call = function(_,...) return new(...) end})

