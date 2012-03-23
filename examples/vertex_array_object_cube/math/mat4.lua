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

local sqrt, cos, sin, tan = math.sqrt, math.cos, math.sin, math.tan

local vec3 = require 'math.vec3'
local vec4 = require 'math.vec4'

local mat4 = {}
mat4.__index = mat4

local function new(...)
  local m = {...}
  setmetatable(m, mat4)
  return m
end

local function identity ()
  local m = {
    1.0, 0, 0, 0,
    0, 1.0, 0, 0,
    0, 0, 1.0, 0,
    0, 0, 0, 1.0
  }
  setmetatable(m, mat4)
  return m
end

local function fromvec4 (x, y, z, w)
  local m = {
    x[1], x[2], x[3], x[4],
    y[1], y[2], y[3], y[4],
    z[1], z[2], z[3], z[4],
    w[1], w[2], w[3], w[4]
  }
  setmetatable(m, mat4)
  return m
end

local function ismat4(v)
  return getmetatable(v) == mat4
end

function mat4:clone()
  return new(self[1], self[2], self[3], self[4],
  self[5], self[6], self[7], self[8],
  self[9], self[10], self[11], self[12],
  self[13], self[14], self[15], self[16])
end

local function mulv(m, v)
  return new(
    self[1] * v[1], self[2] * v[2], self[3] * v[3], self[4] * v[4],
    self[5] * v[1], self[6] * v[2], self[7] * v[3], self[8] * v[4],
    self[9] * v[1], self[10] * v[2], self[11] * v[3], self[12] * v[4],
    self[13] * v[1], self[14] * v[2], self[15] * v[3], self[16] * v[4])
end

function mat4:unpack()
  return self[1], self[2], self[3], self[4],
         self[5], self[6], self[7], self[8],
         self[9], self[10], self[11], self[12],
         self[13], self[14], self[15], self[16]
end

function mat4:__tostring()
  return string.format([[
  %.4f, %.4f, %.4f, %.4f,
  %.4f, %.4f, %.4f, %.4f,
  %.4f, %.4f, %.4f, %.4f,
  %.4f, %.4f, %.4f, %.4f]],
  self[1], self[5], self[9], self[13],
  self[2], self[6], self[10], self[14],
  self[3], self[7], self[11], self[15],
  self[4], self[8], self[12], self[16])
end

function mat4.__unm(a)
end

function mat4.__add(a,b)
end

function mat4.__sub(a,b)
end

function mat4.__mul(a, b)
  return new(
    a[1]*b[1] + a[5]*b[2] + a[9]*b[3] + a[13]*b[4],
    a[2]*b[1] + a[6]*b[2] + a[10]*b[3] + a[14]*b[4],
    a[3]*b[1] + a[7]*b[2] + a[11]*b[3] + a[15]*b[4],
    a[4]*b[1] + a[8]*b[2] + a[12]*b[3] + a[16]*b[4],

    a[1]*b[5] + a[5]*b[6] + a[9]*b[7] + a[13]*b[8],
    a[2]*b[5] + a[6]*b[6] + a[10]*b[7] + a[14]*b[8],
    a[3]*b[5] + a[7]*b[6] + a[11]*b[7] + a[15]*b[8],
    a[4]*b[5] + a[8]*b[6] + a[12]*b[7] + a[16]*b[8],

    a[1]*b[9] + a[5]*b[10] + a[9]*b[11] + a[13]*b[12],
    a[2]*b[9] + a[6]*b[10] + a[10]*b[11] + a[14]*b[12],
    a[3]*b[9] + a[7]*b[10] + a[11]*b[11] + a[15]*b[12],
    a[4]*b[9] + a[8]*b[10] + a[12]*b[11] + a[16]*b[12],

    a[1]*b[13] + a[5]*b[14] + a[9]*b[15] + a[13]*b[16],
    a[2]*b[13] + a[6]*b[14] + a[10]*b[15] + a[14]*b[16],
    a[3]*b[13] + a[7]*b[14] + a[11]*b[15] + a[15]*b[16],
    a[4]*b[13] + a[8]*b[14] + a[12]*b[15] + a[16]*b[16])
end

function mat4.__div(a,b)
end

function mat4.__eq(a,b)
end

function mat4:transpose()
  self[2], self[5] = self[5], self[2]
  self[3], self[9] = self[9], self[3]
  self[4], self[13] = self[13], self[4]
  self[7], self[10] = self[10], self[7]
  self[8], self[14] = self[14], self[8]
  self[12], self[15] = self[15], self[12]
  return self
end

local function rotateX (radians)
  m = identity()
  local s = sin(radians)
  local c = cos(radians)
  m[6], m[10] = c, s
  m[7], m[11] = -s, c
  return m
end

local function rotateY (radians)
  m = identity()
  local s = sin(radians)
  local c = cos(radians)
  m[1], m[9] = c, -s
  m[3], m[11] = s, c
  return m
end

local function rotateZ (radians)
  m = identity()
  local s = sin(radians)
  local c = cos(radians)
  m[1], m[5] = c, -s
  m[2], m[6] = s, c
  return m
end

function mat4:rotate (radians, x, y, z)
  local d = sqrt(x*x + y*y + z*z)
  local s = sin(radians)
  local c = cos(radians)
  local t = 1.0 - c
  local x = x / d
  local y = y / d
  local z = z / d
  return new(
      x*x*t + c, x*y*t - z*s, x*z*t + y*s, 0,
      y*x*t + z*s, y*y*t + c, y*z*t - x*s, 0,
      z*x*t - y*s, z*y*t + x*s, z*z*t + c, 0,
      0, 0, 0, 1.0)
end

local function rotate (radians, x, y, z)
  local d = sqrt(x*x + y*y + z*z)
  local s = sin(radians)
  local c = cos(radians)
  local t = 1.0 - c
  local x = x / d
  local y = y / d
  local z = z / d
  return new(
      x*x*t + c, x*y*t - z*s, x*z*t + y*s, 0,
      y*x*t + z*s, y*y*t + c, y*z*t - x*s, 0,
      z*x*t - y*s, z*y*t + x*s, z*z*t + c, 0,
      0, 0, 0, 1.0)
end

local function translate (x, y, z)
  local m = identity()
  m[13] = x
  m[14] = y
  m[15] = z
  m[1], m[6], m[11], m[16] = 1, 1, 1, 1
  return m
end

local function lookat (eye, target, up)
  local z = vec3.dir(eye, target)
  local x = vec3.cross(up, z)
  local y = vec3.cross(z, x)
  x:normalize()
  y:normalize()
  return new(x[1], y[1], z[1], 0,
             x[2], y[2], z[2], 0,
             x[3], y[3], z[3], 0,
             (x[1] * -eye[1]) + (x[2] * -eye[2]) + (x[3] * -eye[3]),
             (y[1] * -eye[1]) + (y[2] * -eye[2]) + (y[3] * -eye[3]),
             (z[1] * -eye[1]) + (z[2] * -eye[2]) + (z[3] * -eye[3]),
             1)
end

function mat4:scale (x, y, z)
  self[1] = self[1] * x
  self[2] = self[2] * y
  self[3] = self[3] * z
  self[5] = self[5] * x
  self[6] = self[6] * y
  self[7] = self[7] * z
  self[9] = self[9] * x
  self[10] = self[10] * y
  self[11] = self[11] * z
  self[13] = self[13] * x
  self[14] = self[14] * y
  self[15] = self[15] * z
  return self
end

local function scale (x, y, z)
  local m = identity()
  m[1] = m[1] * x
  m[2] = m[2] * y
  m[3] = m[3] * z
  m[5] = m[5] * x
  m[6] = m[6] * y
  m[7] = m[7] * z
  m[9] = m[9] * x
  m[10] = m[10] * y
  m[11] = m[11] * z
  m[13] = m[13] * x
  m[14] = m[14] * y
  m[15] = m[15] * z
  return m
end

function mat4:translate (x, y, z)
  self[13] = self[13] + (self[1] * x) + (self[5] * y) + (self[9] * z)
  self[14] = self[14] + (self[2] * x) + (self[6] * y) + (self[10] * z)
  self[15] = self[15] + (self[3] * x) + (self[7] * y) + (self[11] * z)
  self[16] = self[16] + (self[4] * x) + (self[8] * y) + (self[12] * z)
  return self
end

local function ortho (l, r, b, t, n, f)
  return new(
      2.0 / (r - l),      0,                  0,                 0,
      0,                  2.0 / (t - b),      0,                 0,
      0,                  0,                  2.0 / (n - f),     0,
      (r + l) / (l - r),  (t + b) / (b - t),  (f + n) / (n - f), 1.0)
end

local function frustum (l, r, b, t, n, f)
  return new(
      2.0 * n / (r - l), 0, (r + l) / (r - l), 0,
      0, 2.0 * n / (t - b), (t + b) / (t - b), 0,
      0, 0, (f + n) / (n - f), -1,
      0, 0, 2.0 * f * n / (n - f), 0)
end

local function perspectiveFov(fov, aspect, znear, zfar)
  local xymax = znear * tan(fov * 3.14159265 / 360)
  local ymin = -xymax
  local xmin = -xymax

  local width = xymax - xmin
  local height = xymax - ymin

  local depth = zfar - znear
  local q = -(zfar + znear) / depth
  local qn = -2 * (zfar * znear) / depth

  local w = 2 * znear / width
  w = w / aspect;
  local h = 2 * znear / height

  return new(w,      0,      0,     0,
             0,      h,      0,     0,
             0,      0,      q,    -1,
             0,      0,      qn,    0)
end

local function perspective (fov, aspect, near, far)
  local top = tan(fov * 3.14159265 / 360) * near
  local right = top * aspect
  local left = -right
  local bottom = -top
  -- return frustum(left, right, bottom, top, near, far)
  return new(
    -- column 1
    2 * near / (right - left), 0, 0, 0,
    -- column 2
    0, 2 * near / (top - bottom), 0, 0,
    -- column 3
    (right + left) / (right - left),
    (top + bottom) / (top - bottom),
    -(far + near) / (far - near),
    -1,
    -- column 4
    0, 0, (-2 * far * near) / (far - near), 0)

end

return setmetatable(
  {
    new = new,
    ismat4 = ismat4,
    mulm = mulm,
    mulv = mulv,
    scale = scale,
    identity = identity,
    fromvec4 = fromvec4,
    ortho = ortho,
    frustum = frustum,
    perspective = perspective,
    perspectiveFov = perspectiveFov,
    translate = translate,
    rotateX = rotateX,
    rotateY = rotateY,
    rotateZ = rotateZ,
    rotate = rotate,
    lookat = lookat
  },
  {__call = function(_, ...) return new(...) end})
