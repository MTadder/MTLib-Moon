local p
p = require([[moon.all]]).p
local Types
Types = require([[constants]]).Types
local NOP
NOP = function()
  return nil
end
local isCallable
isCallable = function(value)
  if (type(value) == Types.FUNC) then
    return (true)
  end
  do
    local mt = getmetatable(value)
    if mt then
      return (mt.__call ~= nil) and (type(mt.__call) == Types.FUNC)
    end
  end
  return (false)
end
local deepCopy
deepCopy = function(value)
  if (type(value) ~= Types.TABLE) then
    return (value)
  end
  if (#value == 0) then
    return ({ })
  end
  return (setmetatable((function()
    local _tbl_0 = { }
    for k, v in pairs(value) do
      _tbl_0[k] = v
    end
    return _tbl_0
  end)(), getmetatable(value)))
end
local isInstanceOf
isInstanceOf = function(value, of)
  if (value == (function()
    do
      local _class_0
      local _base_0 = { }
      _base_0.__index = _base_0
      _class_0 = setmetatable({
        __init = function() end,
        __base = _base_0,
        __name = nil
      }, {
        __index = _base_0,
        __call = function(cls, ...)
          local _self_0 = setmetatable({}, _base_0)
          cls.__init(_self_0, ...)
          return _self_0
        end
      })
      _base_0.__class = _class_0
      return _class_0
    end
  end)()) then
    return true
  end
  if (type(value) ~= Types.TABLE) then
    return (false)
  end
  if (value.__class ~= nil) then
    local val_class = value.__class
    if (of.__class ~= nil) then
      local of_class = of.__class
      return (val_class.__name == of_class.__name)
    end
    return (val_class.__name == of)
  end
  return (false)
end
local isAncestor
isAncestor = function(value, of)
  if (value == nil or of == nil) then
    return (false)
  end
  if (value.__parent) then
    if (type(of) == Types.STRING) then
      return (value.__parent.__name == of)
    end
    if (of.__class) then
      if (value.__parent == of.__class) then
        return (true)
      end
      if (value.__parent.__name == of.__class.__name) then
        return (true)
      else
        return (isAncestor(value.__parent, of))
      end
    end
  end
  return (false)
end
local are
are = function(tbl, of)
  for _, v in pairs(tbl) do
    if ((type(v) == of) == false) then
      return (false)
    end
  end
  return (true)
end
local areAncestors
areAncestors = function(tableOfValues, ofClass)
  for _, v in pairs(tableOfValues) do
    if (isAncestor(v, ofClass) == false) then
      return (false)
    end
  end
  return (true)
end
local newArray
newArray = function(count, fillWith)
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
local List
do
  local _class_0
  local _base_0 = {
    combine = function(self, withTbl)
      if (type(withTbl) == type.TABLE) then
        for k, v in pairs(withTbl) do
          self:add(v, k)
        end
      end
    end,
    __tostring = function(self)
      return p(self.Items, ', ')
    end,
    __len = function(self)
      return #self.Items
    end,
    __add = function(v1, v2)
      if (type(v1) ~= type.TABLE) then
        return (v2:add(v1))
      elseif (type(v2) ~= type.TABLE) then
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
        for _, v in pairs(self.Items) do
          if (v == value) then
            return (true)
          end
        end
      end
      return (false)
    end,
    removeAt = function(self, idx)
      self.Items[idx] = nil
      return (self.Items[idx] == nil)
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
      self.Items[k] = deepCopy(v)
      self.Top = self.Items[k]
      return (nil)
    end,
    topKey = function(self)
      local lK = nil
      for k, _ in pairs(self.Items) do
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
      error()
      do
        local _tbl_0 = { }
        for k, v in pairs(ofItems) do
          _tbl_0[k] = v
        end
        self.Items = _tbl_0
      end
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
      local love = (love or nil)
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
      self.On_Completion = (on_complete or NOP)
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
return {
  isCallable = isCallable,
  deepCopy = deepCopy,
  isInstanceOf = isInstanceOf,
  are = are,
  areAncestors = areAncestors,
  newArray = newArray,
  Timer = Timer
}
