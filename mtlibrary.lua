local _meta = {
  name = 'MTLibrary',
  author = 'MTadder',
  date = 'April 11th, 2024',
  version = {
    0,
    63,
    39,
    'GoHome'
  }
}
local _nop
_nop = function()
  return (nil)
end
local _isCallable
_isCallable = function(obj)
  if (type(obj) == 'function') then
    return (true)
  end
  do
    local mt = getmetatable(obj)
    if mt then
      return (mt.__call ~= nil)
    end
  end
  return (false)
end
local _copy
_copy = function(obj)
  if (type(obj) ~= 'table') then
    return (obj)
  end
  if (#obj == 0) then
    return ({ })
  end
  local c = { }
  for k, v in pairs(obj) do
    c[_copy(k)] = _copy(v)
  end
  return (setmetatable(c, getmetatable(obj)))
end
local _combine
_combine = function(t1, t2)
  if ((t1 == nil) or (t2 == nil)) then
    return ((t1 or t2) or nil)
  end
  if ((type(t1) == 'table') and type(t1) == type(t2)) then
    local r = _copy(t1)
    for k, v in pairs(t2) do
      r[k] = v
    end
    return r
  else
    return (t1 + t2)
  end
end
local _is
_is = function(val, ofClass)
  if ((val ~= nil) and (ofClass ~= nil)) then
    if (type(val) ~= 'table') then
      return (false)
    end
    if (val.__class ~= nil) then
      if (ofClass.__class ~= nil) then
        return (val.__class.__name == ofClass.__class.__name)
      end
      return (val.__class.__name == ofClass)
    end
  end
  return (false)
end
local _isAncestor
_isAncestor = function(val, ofClass)
  if (val == nil or ofClass == nil) then
    return (false)
  end
  if (val.__parent) then
    if (type(ofClass) == 'string') then
      return (obj.__parent.__name == ofClass)
    end
    if (ofClass.__class) then
      if (val.__parent == ofClass.__class) then
        return (true)
      end
      if (val.__parent.__name == ofClass.__class.__name) then
        return (true)
      else
        return (_isAncestor(val.__parent, ofClass))
      end
    end
  end
  return (false)
end
local _are
_are = function(tbl, ofClass)
  for i, v in pairs(tbl) do
    if (_is(v, ofClass) == false) then
      return (false)
    end
  end
  return (true)
end
local _areAncestors
_areAncestors = function(tbl, ofClass)
  for i, v in pairs(tbl) do
    if (_isAncestor(v, ofClass) == false) then
      return (false)
    end
  end
  return (true)
end
local _newArray
_newArray = function(count, fillWith)
  return ((function()
    local _accum_0 = { }
    local _len_0 = 1
    for i = 1, count do
      _accum_0[_len_0] = (fillWith or 0)
      _len_0 = _len_0 + 1
    end
    return _accum_0
  end)())
end
local _getAddress
_getAddress = function(f, l)
  if ((l == nil) and (type(f) == 'function')) then
    l = true
  end
  return (tostring(((l and '0x') or '')) .. tostring((tostring(f):gsub('%a*:%s*0?', ''):upper())))
end
local _serialize
_serialize = function(v, max_recursion, iteration)
  if max_recursion == nil then
    max_recursion = 4
  end
  if iteration == nil then
    iteration = 0
  end
  local tokens = {
    ['nil'] = function()
      return ('nil')
    end,
    ['boolean'] = function(b)
      return ((tostring(b)):lower())
    end,
    ['string'] = function(s)
      return string.format('%q', s)
    end,
    ['userdata'] = function(u)
      return ("UserData @ " .. tostring(_getAddress(u)))
    end,
    ['function'] = function(f)
      return ("Function @ " .. tostring(_getAddress(f)))
    end,
    ['thread'] = function(t)
      return ("Thread @ " .. tostring(_getAddress(t)))
    end,
    ['number'] = function(n)
      local huge = (math.huge or (1 / 0))
      if (n ~= n) then
        return ('NaN')
      end
      if (n == huge) then
        return ('INF')
      end
      if (n > huge) then
        return ('INF+')
      end
      if (n == -huge) then
        return ('-INF')
      end
      if (n > 9999) then
        return ("0x" .. tostring(string.format("%x", n):upper()))
      else
        return string.format('%d', n)
      end
    end,
    ['table'] = function(t, s)
      if s == nil then
        s = { }
      end
      local rtn = { }
      s[t] = true
      for k, m in pairs(t) do
        if (s[m] == true) then
          rtn[((#rtn) + 1)] = ("...")
        else
          rtn[((#rtn) + 1)] = ("[" .. tostring(_serialize(k, s)) .. "] = " .. tostring(_serialize(m, s)))
        end
      end
      s[t] = nil
      return ("{" .. tostring(table.concat(rtn, ', ')) .. "}")
    end
  }
  return (tokens[type(v)](v))
end
local List
do
  local _class_0
  local _base_0 = {
    combine = function(self, withTbl)
      if (type(ofItems) == 'table') then
        for k, v in pairs(withTbl) do
          self:add(v, k)
        end
      end
    end,
    __tostring = function(self)
      return _serialize(self.Items, ', ')
    end,
    __len = function(self)
      local c = 0
      for k, v in pairs(self.Items) do
        c = c + 1
      end
      return (c)
    end,
    __add = function(v1, v2)
      if (type(v1) ~= 'table') then
        return (v2:add(v1))
      elseif (type(v2) ~= 'table') then
        return (v1:add(v2))
      end
      if (v1.__name == 'List') then
        if (v2.__name == 'List') then
          for k, v in pairs(v2.Items) do
            v1:add(v, k)
          end
          return (v1)
        else
          local v2L = List(v2)
          return (v1 + v2L)
        end
      elseif (v2.__name == 'List') then
        local v1L = List(v1)
        return (v1L + v2)
      end
      return (nil)
    end,
    __index = function(self, k)
      return (self.Items[k] or nil)
    end,
    contains = function(self, value, atKey)
      if (atKey ~= nil) then
        do
          local v = self.Items[atKey]
          if v then
            return (value == v)
          end
        end
      else
        for k, v in pairs(self.Items) do
          if (v == value) then
            return (true)
          end
        end
      end
      return (false)
    end,
    removeAt = function(self, idx)
      self.Items[idx] = nil
      return (true)
    end,
    remove = function(self, item)
      for k, v in pairs(self.Items) do
        if (v == item) then
          self.Items[k] = nil
          return (true)
        end
      end
      return (false)
    end,
    forEach = function(self, doFunc, iterations)
      if iterations == nil then
        iterations = 1
      end
      for k, v in pairs(self.Items) do
        for i = 1, iterations do
          self.Items[k] = (doFunc(v, i, k) or v)
        end
      end
      return (nil)
    end,
    add = function(self, v, k)
      k = (k or (#self.Items + 1))
      self.Items[k] = _copy(v)
      self.Top = self.Items[k]
      return (nil)
    end,
    topKey = function(self)
      local lK = nil
      for k, v in pairs(self.Items) do
        lK = k
      end
      return (lK)
    end,
    top = function(self)
      if (self.Top ~= nil) then
        return (self.Top)
      end
      return (self.Items[self:topKey()] or nil)
    end,
    pop = function(self, atKey)
      return table.remove(self.Items, (atKey or #self.Items))
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, ofItems)
      self.Items = _copy(ofItems or { })
    end,
    __base = _base_0,
    __name = "List"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  List = _class_0
end
local Timer
do
  local _class_0
  local _base_0 = {
    update = function(self, dT)
      local now = os.clock()
      if (love ~= nil) then
        dT = (dT or love.timer.getDelta())
      else
        dT = (dT or (now - (self.last_update or now)))
      end
      self.Remainder = self.Remainder - dT
      self.last_update = now
      if (self.Remainder <= 0) then
        if (self.Looping == true) then
          self:restart()
        end
        self:On_Completion()
        return (true)
      end
      return (false)
    end,
    isComplete = function(self)
      return ((self.Remainder <= 0) and (self.Looping == false))
    end,
    restart = function(self)
      self.Remainder = self.Duration
      return (self)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, duration, on_complete, looping)
      if looping == nil then
        looping = false
      end
      self.Duration, self.Looping = duration, looping
      self.last_update = os.clock()
      self.On_Completion = (on_complete or _nop)
      self:restart()
      return (self)
    end,
    __base = _base_0,
    __name = "Timer"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Timer = _class_0
end
local file_exists
file_exists = function(filename)
  local ioF = io.open(filename, 'r+')
  local result = (ioF ~= nil)
  if result then
    ioF:close()
  end
  return (result)
end
local file_lines
file_lines = function(filename)
  if not (_fileExists(filename)) then
    return { }
  end
  return ((function()
    local _accum_0 = { }
    local _len_0 = 1
    for line in io.lines(filename) do
      _accum_0[_len_0] = line
      _len_0 = _len_0 + 1
    end
    return _accum_0
  end)())
end
local FileToucher
do
  local _class_0
  local _base_0 = {
    isValid = function(self)
      return (self.file_stream ~= nil)
    end,
    exists = function(self)
      assert(self.file_name, "no file name")
      return (file_exists(self.file_name))
    end,
    write = function(self, data)
      assert(data, "no data for write")
      assert(self:isValid(), "invalid file stream")
      self.file_stream:write(data)
      return (self)
    end,
    read = function(self, what)
      assert(self:isValid(), "invalid file stream")
      return (self.file_stream:read((what or "*all")))
    end,
    close = function(self)
      if self:isValid() then
        self.file_stream:close()
      end
      return (self)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, file_name, mode)
      assert(file_name, "no file name")
      self.file_name = file_name
      self.file_stream = io.open(file_name, mode or 'rw')
      return (self)
    end,
    __base = _base_0,
    __name = "FileToucher"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  FileToucher = _class_0
end
local _uuid
_uuid = function()
  local fn
  fn = function(x)
    local r = (math.random(16) - 1)
    r = ((x == 'x') and (r + 1) or (r % 4) + 9)
    return (("0123456789abcdef"):sub(r, r))
  end
  return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end
local _isUUID
_isUUID = function(v)
  if (type(v) ~= 'string') then
    return (false)
  end
  return (#({
    v:match("^(.+)-(.+)-(.+)-(.+)-(.+)$")
  }) == 5)
end
local _clamp
_clamp = function(v, l, u)
  if l == nil then
    l = 0
  end
  if u == nil then
    u = 1
  end
  return math.max(l, math.min(v, u))
end
local _sign
_sign = function(v)
  return (v < 0 and -1 or 1)
end
local _sigmoid
_sigmoid = function(v)
  return (1 / (1 + math.exp(-v)))
end
local _dist
_dist = function(x, y, x2, y2)
  return math.abs(math.sqrt(math.pow(x2 - x, 2) + math.pow(y2 - y, 2)))
end
local _angleBetween
_angleBetween = function(x, y, x2, y2)
  return math.abs(math.atan2(y2 - y, x2 - x))
end
local _invLerp
_invLerp = function(a, b, d)
  return ((d - a) / (b - a))
end
local _cerp
_cerp = function(a, b, d)
  local pi = (math.pi or 3.1415)
  local f = (1 - math.cos(d * pi) * 0.5)
  return (a * (1 - f) + (b * f))
end
local _lerp
_lerp = function(a, b, d)
  return (a + (b - a) * _clamp(d))
end
local _smooth
_smooth = function(a, b, d)
  local t = _clamp(d)
  local m = t * t * (3 - 2 * t)
  return (a + (b - a) * m)
end
local _pingPong
_pingPong = function(x)
  return (1 - math.abs(1 - x % 2))
end
local _isWithinRegion
_isWithinRegion = function(x, y, oX, oY, lX, lY)
  return ((x > oX and y < lX) and (y > oY and y < lY))
end
local _isWithinCircle
_isWithinCircle = function(x, y, oX, oY, oR)
  return (_dist(x, y, oX, oY) < oR)
end
local _intersects
_intersects = function(o1x, o1y, e1x, e1y, o2x, o2y, e2x, e2y)
  local s1x, s1y = (e1x - o1x), (e1y - o1y)
  local s2x, s2y = (e2x - o2x), (e2y - o2y)
  local s = (-s1y * (o1x - o2x) + s1x * (o1y - o2y)) / (-s2x * s1y + s1x * s2y)
  local t = (s2x * (o1y - o2y) - s2y * (o1x - o2x)) / (-s2x * s1y + s1x * s2y)
  return ((s >= 0) and (s <= 1) and (t >= 0) and (t <= 1))
end
local Dyad
do
  local _class_0
  local _base_0 = {
    lerp = function(self, o, d, d1)
      if _is(o, 'Dyad') then
        self.Position.x = _lerp(self.Position.x, o.Position.x, tonumber(d))
        self.Position.y = _lerp(self.Position.y, o.Position.y, tonumber(d))
      elseif (type(o) == 'number') then
        self.Position.x = _lerp(self.Position.x, o, d1)
        self.Position.x = _lerp(self.Position.y, d, d1)
      end
      return (self)
    end,
    get = function(self)
      return (self.Position.x), (self.Position.y)
    end,
    equals = function(self, o, o2)
      if (o == nil) then
        return (false)
      elseif ((type(o) ~= 'table') and (o2 == nil)) then
        return (false)
      elseif _is(o, 'Dyad') then
        return ((self.Position.x == o.Position.x) and (self.Position.y == o.Position.y))
      elseif ((type(o2) == 'number') and (o1 ~= nil)) then
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
      if ((type(o) == 'number') and (type(o2) == 'number')) then
        return _dist(self.Position.x, self.Position.y, o, o2)
      end
      if _is(o, 'Dyad') then
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
      if _is(o, 'Tetrad') then
        _class_0.__parent.lerp(self, o, d)
        self.Velocity.x = _lerp(self.Velocity.x, o.Position.x, tonumber(d))
        self.Velocity.y = _lerp(self.Velocity.y, o.Position.y, tonumber(d))
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
      return self(x, p2, xV, yV)
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
    __init = function(self, x, y, xV, yV, r, rv)
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
    __init = function(self, x, y, xV, yV, r, rv, dA, dE)
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
    distance = function(self, o, o2)
      return error("TODO")
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
      if _is(o, 'Dyad') then
        local sOX, sOY, sEX, sEY = self:get()
        local oPX, oPY = o:get()
        local slope = self:getSlope()
        return ((slope * sOX + oPX == 0) or (slope * sEX + sPY == 0))
      elseif _is(o, 'Line') then
        local sOX, sOY, sEX, sEY = self:get()
        local oOX, oOY, oEX, oEY = o:get()
        if (_intersects(sOX, sOY, sEX, sEY, oOX, oOY, oEX, oEY)) then
          return (true)
        end
      elseif _is(o, 'Rectangle') then
        if (o:contains(self.Origin) or o:contains(self.Ending)) then
          return (true)
        end
        for i, l in ipairs(o:getLines()) do
          if (self:intersects(l)) then
            return (true)
          end
        end
      end
      return (false)
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
      if _is(o, 'Dyad') then
        local sOX, sOY, sLX, sLY = self:get()
        local oPX, oPY = o:get()
        return _isWithinRegion(oPX, oPY, sOX, sOY, sLX, sLY)
      elseif _is(o, 'Line') then
        return (self:contains(o.Origin) and self:contains(o.Ending))
      elseif _is(o, 'Rectangle') then
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
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
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
local MTLibrary = {
  _meta = _meta,
  logic = {
    Timer = Timer,
    List = List,
    NOP = _nop,
    copy = _copy,
    combine = _combine,
    newArray = _newArray,
    isCallable = _isCallable,
    is = _is,
    isAncestor = _isAncestor,
    are = _are,
    areAncestors = _areAncestors
  },
  io = {
    FileToucher = FileToucher
  },
  math = {
    UUID = _uuid,
    isUUID = _isUUID,
    random = function(tbl)
      if (type(tbl) == 'table') then
        return (tbl[math.random(#tbl)])
      end
      return (math.random(tonumber(tbl or 1)))
    end,
    ifs = {
      sin = function(x, y)
        return math.sin(x), math.sin(y)
      end,
      sphere = function(x, y)
        local fac = (1 / (math.sqrt((x * x) + (y * y))))
        return (fac * x), (fac * y)
      end,
      swirl = function(x, y)
        local rsqr = math.sqrt((x * x) + (y * y))
        local res_x = ((x * math.sin(rsqr)) - (y * math.cos(rsqr)))
        local res_y = ((x * math.cos(rsqr)) + (y * math.sin(rsqr)))
        return res_x, res_y
      end,
      horseshoe = function(x, y)
        local factor = (1 / (math.sqrt((x * x) + (y * y))))
        return (factor * ((x - y) * (x + y))), (factor * (2 * (x * y)))
      end,
      polar = function(x, y)
        return (math.atan(x / y) * math.pi), (((x * x) + (y * y)) - 1)
      end,
      handkerchief = function(x, y)
        local r = math.sqrt((x * x) + (y * y))
        local arcTan = math.atan(x / y)
        return (r * math.sin(arcTan + r)), (r * math.cos(arcTan - r))
      end,
      heart = function(x, y)
        local r = math.sqrt((x * x) + (y * y))
        local arcTan = math.atan(x / y)
        return (r * math.sin(arcTan * r)), (r * (-math.cos(arcTan * r)))
      end,
      disc = function(x, y)
        local r = math.sqrt((x * x) + (y * y))
        local arcTan = math.atan(x / y)
        local arctanPi = (arcTan * math.pi)
        return (arctanPi * (math.sin(math.pi * r))), (arctanPi * (math.cos(math.pi * r)))
      end,
      spiral = function(x, y)
        local r = math.sqrt((x * x) + (y * y))
        local factor = (1 / (math.sqrt((x * x) + (y * y))))
        local arcTan = math.atan(x / y)
        return (factor * (math.cos(arcTan) + math.sin(r))), (factor * (math.sin(arcTan - math.cos(r))))
      end,
      hyperbolic = function(x, y)
        local r = math.sqrt((x * x) + (y * y))
        local arcTan = math.atan(x / y)
        return (math.sin(arcTan) / r), (r * math.cos(arcTan))
      end,
      diamond = function(x, y)
        local r = math.sqrt((x * x) + (y * y))
        local arcTan = math.atan(x / y)
        return (math.sin(arcTan * math.cos(r))), (math.cos(arcTan * math.sin(r)))
      end,
      ex = function(x, y)
        local r = math.sqrt((x * x) + (y * y))
        local arcTan = math.atan(x / y)
        local p0 = math.sin(arcTan + r)
        p0 = math.pow(p0, 3)
        local p1 = math.cos(arcTan - r)
        p1 = math.pow(p1, 3)
        return (r * (p0 + p1)), (r * (p0 - p1))
      end,
      julia = function(x, y)
        local r = math.sqrt((x * x) + (y * y))
        local arcTan = math.atan(x / y)
        local omega
        if (math.random() >= 0.5) then
          omega = math.pi
        else
          omega = 0
        end
        local res_x = (r * (math.cos((arcTan * 0.5) + omega)))
        local res_y = (r * (math.sin((arcTan * 0.5) + omega)))
        return res_x, res_y
      end,
      bent = function(x, y)
        if (x < 0 and y >= 0) then
          return (x * 2), (y)
        elseif (x >= 0 and y < 0) then
          return (x), (y * 0.5)
        elseif (x < 0 and y < 0) then
          return (x * 2), (y * 0.5)
        end
        return (x), (y)
      end,
      waves = function(x, y, a, b, c, d, e, f)
        return (x + b * math.sin(y / (c * c))), (y + e * math.sin(x / (f * f)))
      end,
      fisheye = function(x, y)
        local r = math.sqrt((x * x) + (y * y))
        local factor = ((r + 1) * 0.5)
        return (factor * y), (factor * x)
      end,
      eyefish = function(x, y)
        local r = math.sqrt((x * x) + (y * y))
        local factor = ((r + 1) * 0.5)
        return (factor * x), (factor * y)
      end,
      popcorn = function(x, y, a, b, c, d, e, f)
        return (x + c * math.sin(math.tan(3 * y))), (y + f * math.sin(math.tan(3 * x)))
      end,
      power = function(x, y)
        local r = math.sqrt((x * x) + (y * y))
        local arcTan = math.atan(x / y)
        local factor = r ^ (math.sin(arcTan))
        return (factor * (math.cos(arcTan))), (math.sin(arcTan))
      end,
      cosine = function(x, y)
        local res_x = (math.cos(math.pi * x) * math.cosh(y))
        local res_y = (-(math.sin(math.pi * x) * math.sinh(y)))
        return res_x, res_y
      end,
      rings = function(x, y, a, b, c, d, e, f)
        local r = math.sqrt((x * x) + (y * y))
        local arcTan = math.atan(x / y)
        local factor = (r + (c * c)) % (2 * (c * c) - (c * c) + r * (1 - (c * c)))
        return (factor * math.cos(arcTan)), (factor * math.sin(arcTan))
      end,
      fan = function(x, y, a, b, c, d, e, f)
        local t = (math.pi * (c * c))
        local r = math.sqrt((x * x) + (y * y))
        local arcTan = math.atan(x / y)
        if ((arcTan + f) % t) > (t * 0.5) then
          return (r * math.cos(arcTan - (t * 0.5))), (r * math.sin(arcTan - (t * 0.5)))
        end
        return (r * math.cos(arcTan + (t * 0.5))), (r * math.sin(arcTan + (t * 0.5)))
      end,
      blob = function(x, y, b)
        local r = math.sqrt((x * x) + (y * y))
        local arcTan = math.atan(x / y)
        local factor = r * (b.Low + ((b.High - b.Low) * 0.5) * math.sin(b.Waves * arcTan) + 1)
        return (factor * math.cos(arcTan)), (factor * math.sin(arcTan))
      end,
      pdj = function(x, y, a, b, c, d, e, f)
        return (math.sin(a * y) - math.cos(b * x)), (math.sin(c * x) - math.cos(d * y))
      end,
      bubble = function(x, y)
        local r = math.sqrt((x * x) + (y * y))
        local factor = (4 / ((r * r) + 4))
        return (factor * x), (factor * y)
      end,
      cylinder = function(x, y)
        return (math.sin(x)), (y)
      end,
      perspective = function(x, y, angle, dist)
        local factor = dist / (dist - (y * math.sin(angle)))
        return (factor * x), (factor * (y * math.cos(angle)))
      end,
      noise = function(x, y)
        local rand = math.random(0, 1)
        local rand2 = math.random(0, 1)
        local res_x = (rand * (x * math.cos(2 * math.pi * rand2)))
        local res_y = (rand * (y * math.sin(2 * math.pi * rand2)))
        return res_x, res_y
      end,
      pie = function(x, y, slices, rotation, thickness)
        local t1 = truncate(math.random() * slices)
        local t2 = rotation + ((2 * math.pi) / (slices)) * (t1 + math.random() * thickness)
        local r0 = math.random()
        return (r0 * math.cos(t2)), (r0 * math.sin(t2))
      end,
      ngon = function(x, y, power, sides, corners, circle)
        local p2 = (2 * math.pi) / sides
        local iArcTan = math.atan(y / x)
        local t3 = (iArcTan - (p2 * math.floor(iArcTan / p2)))
        local t4
        if (t3 > (p2 * 0.5)) then
          t4 = t3
        else
          t4 = (t3 - p2)
        end
        local k = (corners * (1 / (math.cos(t4)) + circle)) / (math.pow(r, power))
        return (k * x), (k * y)
      end,
      curl = function(x, y, c1, c2)
        local t1 = (1 + (c1 * x) + c2 * ((x * x) - (y * y)))
        local t2 = (c1 * y) + (2 * c2 * x * y)
        local factor = (1 / ((t1 * t1) + (t2 * t2)))
        return (factor * ((x * t1) + (y * t2))), (factor * ((y * t1) - (x * t2)))
      end,
      rectangles = function(x, y, rX, rY)
        return (((2 * math.floor(x / rX) + 1) * rX) - x), (((2 * math.floor(y / rY) + 1) * rY) - y)
      end,
      tangent = function(x, y)
        return (math.sin(x) / math.cos(y)), (math.tan(y))
      end,
      cross = function(x, y)
        local factor = math.sqrt(1 / (((x * x) - (y * y)) * ((x * x) - (y * y))))
        return (factor * x), (factor * y)
      end
    },
    Dyad = Dyad,
    Tetrad = Tetrad,
    Hexad = Hexad,
    Octad = Octad,
    Shape = Shape,
    shapes = {
      Circle = Circle,
      Line = Line,
      Rectangle = Rectangle,
      Polygon = Polygon
    }
  },
  string = {
    serialize = _serialize,
    getAddress = _getAddress
  },
  authy = { },
  generative = { }
}
if love then
  local ShaderCode
  do
    local _class_0
    local _base_0 = {
      validate = function(self)
        assert(love, '')
        return (self)
      end
    }
    _base_0.__index = _base_0
    _class_0 = setmetatable({
      __init = function(self, src) end,
      __base = _base_0,
      __name = "ShaderCode"
    }, {
      __index = _base_0,
      __call = function(cls, ...)
        local _self_0 = setmetatable({}, _base_0)
        cls.__init(_self_0, ...)
        return _self_0
      end
    })
    _base_0.__class = _class_0
    ShaderCode = _class_0
  end
  local Projector
  do
    local _class_0
    local _base_0 = {
      setup = function(self) end,
      push = function(self) end,
      pop = function(self)
        if (love ~= nil) then
          return love.graphics.pop()
        end
      end
    }
    _base_0.__index = _base_0
    _class_0 = setmetatable({
      __init = function(self)
        return (self)
      end,
      __base = _base_0,
      __name = "Projector"
    }, {
      __index = _base_0,
      __call = function(cls, ...)
        local _self_0 = setmetatable({}, _base_0)
        cls.__init(_self_0, ...)
        return _self_0
      end
    })
    _base_0.__class = _class_0
    Projector = _class_0
  end
  local View
  do
    local _class_0
    local _base_0 = {
      configure = function(self, param, value)
        self.Conf[param] = value
        return (self)
      end,
      renderTo = function(self, func)
        self.Canvas:renderTo(func)
        return (self)
      end
    }
    _base_0.__index = _base_0
    _class_0 = setmetatable({
      __init = function(self, oX, oY, w, h)
        self.Position = Hexad(oX, oY)
        self.Conf = {
          margin = 0
        }
        self.Canvas = love.graphics.newCanvas(w, h)
        return (self)
      end,
      __base = _base_0,
      __name = "View"
    }, {
      __index = _base_0,
      __call = function(cls, ...)
        local _self_0 = setmetatable({}, _base_0)
        cls.__init(_self_0, ...)
        return _self_0
      end
    })
    _base_0.__class = _class_0
    View = _class_0
  end
  local ListView
  do
    local _class_0
    local _parent_0 = View
    local _base_0 = { }
    _base_0.__index = _base_0
    setmetatable(_base_0, _parent_0.__base)
    _class_0 = setmetatable({
      __init = function(self)
        self.Conf = {
          marg = 0,
          align = 'center'
        }
        self.Items = { }
        return (self)
      end,
      __base = _base_0,
      __name = "ListView",
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
    ListView = _class_0
  end
  local GridView
  do
    local _class_0
    local _parent_0 = ListView
    local _base_0 = { }
    _base_0.__index = _base_0
    setmetatable(_base_0, _parent_0.__base)
    _class_0 = setmetatable({
      __init = function(self)
        self.Conf = {
          rows = 0,
          cols = 0,
          marg = 0
        }
        self.Items = { }
        return (self)
      end,
      __base = _base_0,
      __name = "GridView",
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
    GridView = _class_0
  end
  local Element
  do
    local _class_0
    local _base_0 = { }
    _base_0.__index = _base_0
    _class_0 = setmetatable({
      __init = function(self)
        self.Position = Hexad()
        return (self)
      end,
      __base = _base_0,
      __name = "Element"
    }, {
      __index = _base_0,
      __call = function(cls, ...)
        local _self_0 = setmetatable({}, _base_0)
        cls.__init(_self_0, ...)
        return _self_0
      end
    })
    _base_0.__class = _class_0
    Element = _class_0
  end
  local Label
  do
    local _class_0
    local _parent_0 = Element
    local _base_0 = {
      draw = function(self)
        if (love.graphics.isActive() == false) then
          return (nil)
        end
        love.graphics.printf(self.Text, self.Position:get(), love.window.toPixels(#self.Text))
        return (self)
      end
    }
    _base_0.__index = _base_0
    setmetatable(_base_0, _parent_0.__base)
    _class_0 = setmetatable({
      __init = function(self, text, alignment)
        if alignment == nil then
          alignment = 'center'
        end
        self.Text = (tostring(text) or 'NaV')
        self.Align = alignment
        return (self)
      end,
      __base = _base_0,
      __name = "Label",
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
    Label = _class_0
  end
  local Button
  do
    local _class_0
    local _parent_0 = Element
    local _base_0 = { }
    _base_0.__index = _base_0
    setmetatable(_base_0, _parent_0.__base)
    _class_0 = setmetatable({
      __init = function(self, ...)
        return _class_0.__parent.__init(self, ...)
      end,
      __base = _base_0,
      __name = "Button",
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
    Button = _class_0
  end
  local Textbox
  do
    local _class_0
    local _parent_0 = Element
    local _base_0 = { }
    _base_0.__index = _base_0
    setmetatable(_base_0, _parent_0.__base)
    _class_0 = setmetatable({
      __init = function(self, ...)
        return _class_0.__parent.__init(self, ...)
      end,
      __base = _base_0,
      __name = "Textbox",
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
    Textbox = _class_0
  end
  local Picture
  do
    local _class_0
    local _parent_0 = Element
    local _base_0 = {
      draw = function(self, x, y, r, sX, sY)
        love.graphics.draw(self.Image, x, y, r, sX, sY)
        return (self)
      end,
      getPixel = function(self, x, y)
        return (self.Image:getData()):getPixel(x, y)
      end,
      setPixel = function(self, x, y, color, c2, c3, c4)
        if (type(color) == 'table') then
          local c0 = color
          local c1
          c1, c2, c3, c4 = c0[1], c0[2](c0[3], c0[4])
        end
        local iD = self.Image:getData()
        iD:setPixel(x, y, c1, c2, c3, c4)
        self.Image = love.graphics.newImage(iD)
        return (self)
      end,
      map = function(self, func, x, y, w, h)
        if (_isCallable(func)) then
          local iD = self.Image:getData()
          iD:mapPixel(func, x, y, w, h)
          self.Image = love.graphics.newImage(iD)
          return (self)
        end
      end,
      encode = function(self, f, format)
        return (self.Image:getData()):encode(format, f)
      end
    }
    _base_0.__index = _base_0
    setmetatable(_base_0, _parent_0.__base)
    _class_0 = setmetatable({
      __init = function(self, f)
        self.Image = love.graphics.newImage(f)
        return (self)
      end,
      __base = _base_0,
      __name = "Picture",
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
    Picture = _class_0
  end
  local PictureBatch
  do
    local _class_0
    local _parent_0 = Element
    local _base_0 = {
      draw = function(self, id, x, y, r, sX, sY)
        if x == nil then
          x = 0
        end
        if y == nil then
          y = 0
        end
        if r == nil then
          r = 0
        end
        if sX == nil then
          sX = 0
        end
        if sY == nil then
          sY = 0
        end
        love.graphics.draw(self.Image, (self.Quads[id] or nil), x, y, r, sX, sY)
        return (self)
      end
    }
    _base_0.__index = _base_0
    setmetatable(_base_0, _parent_0.__base)
    _class_0 = setmetatable({
      __init = function(self, f, sprites)
        do
          self.Image = love.graphics.newImage(f)
          if self.Image then
            self.Quads = { }
            for k, v in pairs(sprites) do
              assert(v.x and v.y and v.w and v.h)
              self.Quads[k] = love.graphics.newQuad(v.x, v.y, v.w, v.h, self.Image:getDimensions())
            end
          end
        end
        return (self)
      end,
      __base = _base_0,
      __name = "PictureBatch",
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
    PictureBatch = _class_0
  end
  MTLibrary.graphics = {
    View = View,
    ListView = ListView,
    GridView = GridView,
    Element = Element,
    Label = Label,
    Button = Button,
    Textbox = Textbox,
    Picture = Picture,
    PictureBatch = PictureBatch,
    Projector = Projector,
    patternColorizer = function(str, colors)
      return (nil)
    end,
    fit = function(monitorRatio)
      if monitorRatio == nil then
        monitorRatio = 1
      end
      local oldW, oldH, currentFlags = love.window.getMode()
      local screen, window = { }, { }
      screen.w, screen.h = love.window.getDesktopDimensions(currentFlags.display)
      local newWindowWidth = truncate(screen.w / monitorRatio)
      local newWindowHeight = truncate(screen.h / monitorRatio)
      if ((oldW == newWindowWidth) and (oldH == newWindowHeight)) then
        return (nil), (nil)
      end
      window.display, window.w = currentFlags.display, newWindowWidth
      window.h = newWindowHeight
      window.x = math.floor((screen.w * 0.5) - (window.w * 0.5))
      window.y = math.floor((screen.h * 0.5) - (window.h * 0.5))
      currentFlags.x, currentFlags.y = window.x, window.y
      love.window.setMode(window.w, window.h, currentFlags)
      return (screen), (window)
    end,
    getCenter = function(offset, offsetY)
      local w, h = love.graphics.getDimensions()
      return (error())
    end
  }
end
return (MTLibrary)
