local isInstanceOf
isInstanceOf = require([[logic]]).isInstanceOf
local Types
Types = require([[constants]]).Types
local clamp
clamp = function(v, l, u)
  if l == nil then
    l = 0
  end
  if u == nil then
    u = 1
  end
  return math.max(l, math.min(v, u))
end
local sign
sign = function(v)
  return (v < 0 and -1 or 1)
end
local sigmoid
sigmoid = function(v)
  return (1 / (1 + math.exp(-v)))
end
local distance
distance = function(x, y, x2, y2)
  return math.abs(math.sqrt(math.pow(x2 - x, 2) + math.pow(y2 - y, 2)))
end
local angleBetween
angleBetween = function(x, y, x2, y2)
  return math.abs(math.atan2(y2 - y, x2 - x))
end
local invLerp
invLerp = function(a, b, d)
  return ((d - a) / (b - a))
end
local cerp
cerp = function(a, b, d)
  local pi = (math.pi or 3.1415)
  local f = (1 - math.cos(d * pi) * 0.5)
  return (a * (1 - f) + (b * f))
end
local lerp
lerp = function(a, b, d)
  return (a + (b - a) * clamp(d))
end
local smooth
smooth = function(a, b, d)
  local t = clamp(d)
  local m = t * t * (3 - 2 * t)
  return (a + (b - a) * m)
end
local pingPong
pingPong = function(x)
  return (1 - math.abs(1 - x % 2))
end
local isWithinRegion
isWithinRegion = function(x, y, oX, oY, lX, lY)
  return ((x > oX and y < lX) and (y > oY and y < lY))
end
local isWithinCircle
isWithinCircle = function(x, y, oX, oY, oR)
  return (distance(x, y, oX, oY) < oR)
end
local Dyad
do
  local _class_0
  local _base_0 = {
    lerp = function(self, o, d, d1)
      if isInstanceOf(o, 'Dyad') then
        self.Position.x = lerp(self.Position.x, o.Position.x, tonumber(d))
        self.Position.y = lerp(self.Position.y, o.Position.y, tonumber(d))
      elseif (type(o) == Types.NUMBER) then
        self.Position.x = lerp(self.Position.x, o, d1)
        self.Position.x = lerp(self.Position.y, d, d1)
      end
      return (self)
    end,
    get = function(self)
      return (self.Position.x), (self.Position.y)
    end,
    equals = function(self, o, o2)
      if (o == nil) then
        return (false)
      elseif ((type(o) ~= Types.TABLE) and (o2 == nil)) then
        return (false)
      elseif isInstanceOf(o, 'Dyad') then
        return ((self.Position.x == o.Position.x) and (self.Position.y == o.Position.y))
      elseif ((type(o2) == Types.NUMBER) and (o ~= nil)) then
        return ((self.Position.x == o) and (self.Position.y == o2))
      end
      return (false)
    end,
    distance = function(self, o, o2)
      if o == nil then
        o = 0
      end
      if o2 == nil then
        o2 = 0
      end
      if ((type(o) == Types.NUMBER) and (type(o2) == Types.NUMBER)) then
        return distance(self.Position.x, self.Position.y, o, o2)
      end
      if isInstanceOf(o, 'Dyad') then
        return self:distance(o.Position.x, o.Position.y)
      end
      return (nil)
    end,
    __tostring = function(self)
      return ("D{" .. tostring(self.Position.x) .. ", " .. tostring(self.Position.y) .. "}")
    end,
    set = function(self, x, y)
      self.Position = self.Position or { }
      self.Position.x, self.Position.y = tonumber(x or 0), tonumber(y or 0)
      return (self)
    end,
    __call = function(self, x, y)
      return self:set(x, y)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y)
      return self(x, y)
    end,
    __base = _base_0,
    __name = "Dyad"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Dyad = _class_0
end
local Tetrad
do
  local _class_0
  local _parent_0 = Dyad
  local _base_0 = {
    lerp = function(self, o, d)
      if isInstanceOf(o, 'Tetrad') then
        _class_0.__parent.lerp(self, o, d)
        self.Velocity.x = lerp(self.Velocity.x, o.Position.x, tonumber(d))
        self.Velocity.y = lerp(self.Velocity.y, o.Position.y, tonumber(d))
      end
      return (self)
    end,
    distance = function(self, o)
      return (_class_0.__parent.distance(self, o))
    end,
    set = function(self, x, y, xV, yV)
      _class_0.__parent.set(self, x, y)
      self.Velocity = self.Velocity or { }
      self.Velocity.x, self.Velocity.y = tonumber(xV or 0), tonumber(yV or 0)
    end,
    get = function(self)
      return unpack({
        self.Position.x,
        self.Position.y,
        self.Velocity.x,
        self.Velocity.y
      })
    end,
    update = function(self, dT)
      if dT == nil then
        dT = (1 / 60)
      end
      self.Position.x = self.Position.x + (self.Velocity.x * dT)
      self.Position.y = self.Position.y + (self.Velocity.y * dT)
    end,
    impulse = function(self, angle, force)
      local v = (math.cos(angle) * force)
      self.Velocity.x = self.Velocity.x + v
      self.Velocity.y = self.Velocity.y + v
    end,
    __tostring = function(self)
      return ("T{" .. tostring(self.Velocity.x) .. ", " .. tostring(self.Velocity.y) .. ", " .. tostring(_class_0.__parent.__tostring(self)) .. "}")
    end,
    __call = function(self, x, y, xV, yV)
      self:set(x, y, xV, yV)
      return (self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, xV, yV)
      return self(x, y, xV, yV)
    end,
    __base = _base_0,
    __name = "Tetrad",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Tetrad = _class_0
end
local Hexad
do
  local _class_0
  local _parent_0 = Tetrad
  local _base_0 = {
    set = function(self, x, y, xV, yV, r, rV)
      _class_0.__parent.set(self, x, y, xV, yV)
      self.Rotator = self.Rotator or { }
      self.Rotator.value, self.Rotator.inertia = tonumber(r or 0), tonumber(rV or 0)
      return (self)
    end,
    get = function(self)
      return unpack({
        self.Position.x,
        self.Position.y,
        self.Velocity.x,
        self.Velocity.y,
        self.Rotator.value,
        self.Rotator.inertia
      })
    end,
    update = function(self, dT)
      if dT == nil then
        dT = (1 / 60)
      end
      _class_0.__parent.update(self, dT)
      self.Rotator.value = self.Rotator.value + (self.Rotator.inertia * dT)
      return (self)
    end,
    torque = function(self, by)
      self.Rotator.inertia = self.Rotator.inertia + tonumber(by)
      return (self)
    end,
    __tostring = function(self)
      return ("H{" .. tostring(self.Rotator.value) .. ", " .. tostring(self.Rotator.inertia) .. ", " .. tostring(_class_0.__parent.__tostring(self)) .. "}")
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, xV, yV, r, rV)
      return (self:set(x, y, xV, yV, r, rV))
    end,
    __base = _base_0,
    __name = "Hexad",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Hexad = _class_0
end
local Octad
do
  local _class_0
  local _parent_0 = Hexad
  local _base_0 = {
    set = function(self, x, y, xV, yV, r, rV, dA, dE)
      _class_0.__parent.set(self, x, y, xV, yV, r, rV)
      self.Dimensional = self.Dimensional or { }
      self.Dimensional.address, self.Dimensional.entropy = tonumber(dA or 0), tonumber(dE or 0)
      return (self)
    end,
    get = function(self)
      return unpack({
        self.Position.x,
        self.Position.y,
        self.Velocity.x,
        self.Velocity.y,
        self.Rotator.value,
        self.Rotator.inertia,
        self.Dimensional.address,
        self.Dimensional.entropy
      })
    end,
    shake = function(self, by)
      self.Dimensional.entropy = self.Dimensional.entropy + tonumber(by)
    end,
    update = function(self, dT)
      if dT == nil then
        dT = (1 / 60)
      end
      _class_0.__parent.update(self, dT)
      self.Dimensional.address = self.Dimensional.address + (self.Dimensional.entropy * dT)
      return (self)
    end,
    __tostring = function(self)
      return ("O{" .. tostring(self.Dimensional.address) .. ", " .. tostring(self.Dimensional.entropy) .. ", " .. tostring(_class_0.__parent.__tostring(self)) .. "}")
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, xV, yV, r, rV, dA, dE)
      return (self:set(x, y, xV, yV, r, rV, dA, dE))
    end,
    __base = _base_0,
    __name = "Octad",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Octad = _class_0
end
local Shape
do
  local _class_0
  local _base_0 = {
    set = function(self, oX, oY)
      self.Origin = self.Origin or Dyad(tonumber(oX or 0), tonumber(oY or 0))
      return (self)
    end,
    __tostring = function(self)
      return ("S{" .. tostring(tostring(self.Origin)) .. "}")
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, oX, oY)
      error()
      return (self:set(oX, oY))
    end,
    __base = _base_0,
    __name = "Shape"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Shape = _class_0
end
local Circle
do
  local _class_0
  local _parent_0 = Shape
  local _base_0 = {
    set = function(self, oX, oY, radi)
      _class_0.__parent.set(self, oX, oY)
      self.Radius = tonumber(radi or math.pi)
      return (self)
    end,
    draw = function(self, mode)
      local love = (love or nil)
      if (love == nil) then
        error('missing LOVE2D!')
      end
      love.graphics.circle(mode, self.Origin.x, self.Origin.y, self.Radius)
      return (self)
    end,
    __tostring = function(self)
      return ("C{" .. tostring(self.Radius) .. ", " .. tostring(_class_0.__parent.__tostring(self)) .. "}")
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, rad)
      return (self:set(x, y, rad))
    end,
    __base = _base_0,
    __name = "Circle",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Circle = _class_0
end
local Line
do
  local _class_0
  local _parent_0 = Shape
  local _base_0 = {
    set = function(self, oX, oY, eX, eY)
      _class_0.__parent.set(self, oX, oY)
      self.Ending = Dyad(eX, eY)
      return (self)
    end,
    get = function(self)
      return unpack({
        self.Origin.Position.x,
        self.Origin.Position.y,
        self.Ending.Position.x,
        self.Ending.Position.x
      })
    end,
    getLength = function(self)
      local sOX, sOY = self.Origin:get()
      local sEX, sEY = self.Ending:get()
      return (math.sqrt(math.pow(sEX - sOX, 2) + math.pow(sEY - sOY, 2)))
    end,
    getSlope = function(self)
      return ((self.Ending.Position.x - self.Origin.Position.x) / (self.Ending.Position.y - self.Origin.Position.y))
    end,
    intersects = function(self, o)
      return error()
    end,
    __tostring = function(self)
      return ("[{" .. tostring(tostring(self.Origin)) .. "}-(" .. tostring(self:getLength()) .. ")->{" .. tostring(tostring(self.Ending)) .. "}]")
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, oX, oY, eX, eY)
      return (self:set(oX, oY, eX, eY))
    end,
    __base = _base_0,
    __name = "Line",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Line = _class_0
end
local Rectangle
do
  local _class_0
  local _parent_0 = Shape
  local _base_0 = {
    set = function(self, oX, oY, lX, lY)
      _class_0.__parent.set(self, oX, oY)
      self.Limits = self.Limits or Dyad(lX, lY)
      return (self)
    end,
    get = function(self)
      return unpack({
        self.Origin.Position.x,
        self.Origin.Position.y,
        self.Limits.Position.x,
        self.Limits.Position.y
      })
    end,
    area = function(self)
      return (self.Limits.Position.x * self.Limits.Position.y)
    end,
    perimeter = function(self)
      return ((2 * (self.Limits.Position.x)) + (2 * (self.Limits.Position.y)))
    end,
    diagonal = function(self)
      return math.sqrt(((self.Limits.Position.x) ^ 2) + ((self.Limits.Position.y) ^ 2))
    end,
    contains = function(self, o)
      if isInstanceOf(o, 'Dyad') then
        local sOX, sOY, sLX, sLY = self:get()
        local oPX, oPY = o:get()
        return isWithinRegion(oPX, oPY, sOX, sOY, sLX, sLY)
      elseif isInstanceOf(o, 'Line') then
        return (self:contains(o.Origin) and self:contains(o.Ending))
      elseif isInstanceOf(o, 'Rectangle') then
        for i, l in ipairs(o:getLines()) do
          if (self:contains(l) == false) then
            return (false)
          end
        end
        return (true)
      end
      return (nil)
    end,
    render = function(self)
      local sOX, sOY, sLX, sLY = self:get()
      return ({
        sOX,
        sOY,
        sOX,
        sLY,
        sOX,
        sLY,
        sLX,
        sLY,
        sLX,
        sLY,
        sLX,
        sOY,
        sLX,
        sOY,
        sOX,
        sOY
      })
    end,
    getLines = function(self)
      local sOX, sOY, sLX, sLY = self:get()
      return ({
        Line(sOX, sOY, sOX, sLY),
        Line(sOX, sLY, sLX, sLY),
        Line(sLX, sLY, sLX, sOY),
        Line(sLX, sOY, sOX, sOY)
      })
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, oX, oY, lX, lY)
      return (self:set(oX, oY, lX, lY))
    end,
    __base = _base_0,
    __name = "Rectangle",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Rectangle = _class_0
end
local Polygon
do
  local _class_0
  local _parent_0 = Shape
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      return error()
    end,
    __base = _base_0,
    __name = "Polygon",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Polygon = _class_0
end
return {
  sign = sign,
  sigmoid = sigmoid,
  angleBetween = angleBetween,
  lerp = lerp,
  inverseLerp = inverseLerp,
  cosineLerp = cosineLerp,
  smooth = smooth,
  pingPong = pingPong,
  isWithinRegion = isWithinRegion,
  isWithinCircle = isWithinCircle,
  Dyad = Dyad,
  Tetrad = Tetrad,
  Hexad = Hexad,
  Octad = Octad,
  Shape = Shape,
  Line = Line,
  Circle = Circle,
  Rectangle = Rectangle,
  Polygon = Polygon
}
