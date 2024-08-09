local Types
Types = require([[mtlib.constants]]).Types
local UUID
do
  local _class_0
  local generate
  local _base_0 = {
    __tostring = function(self)
      return self.value or error()
    end,
    isUUID = function(self, value)
      if (type(value) ~= Types.STRING) then
        return (false)
      end
      return (#({
        value:match("^(.+)-(.+)-(.+)-(.+)-(.+)$")
      }) == 5)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, uuid)
      if uuid == nil then
        uuid = nil
      end
      error()
      self.value = uuid or generate()
    end,
    __base = _base_0,
    __name = "UUID"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  generate = function()
    local fn
    fn = function(x)
      local r = (math.random(16) - 1)
      r = ((x == 'x') and (r + 1) or (r % 4) + 9)
      return (("0123456789abcdef"):sub(r, r))
    end
    return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
  end
  UUID = _class_0
end
local getValueAddress
getValueAddress = function(f, l)
  if ((l == nil) and (type(f) == Types.FUNC)) then
    l = true
  end
  return (tostring(((l and '0x') or '')) .. tostring((tostring(f):gsub('%a*:%s*0?', ''):upper())))
end
local serialize
serialize = function(v, max_recursion, iteration)
  if max_recursion == nil then
    max_recursion = 4
  end
  if iteration == nil then
    iteration = 0
  end
  local tokens = {
    [Types.NIL] = function()
      return ('nil')
    end,
    [Types.BOOL] = function(b)
      return ((tostring(b)):lower())
    end,
    [Types.STRING] = function(s)
      return string.format('%q', s)
    end,
    [Types.USERDATA] = function(u)
      return ("UserData @ " .. tostring(_getAddress(u)))
    end,
    [Types.FUNC] = function(f)
      return ("Function @ " .. tostring(_getAddress(f)))
    end,
    [Types.THREAD] = function(t)
      return ("Thread @ " .. tostring(_getAddress(t)))
    end,
    [Types.NUMBER] = function(num)
      local huge = (math.huge or (1 / 0))
      if (num ~= num) then
        return ('NaN')
      end
      if (num == huge) then
        return ('INF')
      end
      if (num > huge) then
        return ('INF+')
      end
      if (num == -huge) then
        return ('-INF')
      end
      if ((num > 9999) or (num < -9999)) then
        return ("0x" .. tostring(string.format("%x", num):upper()))
      else
        return string.format('%d', num)
      end
    end,
    [Types.TABLE] = function(t, s)
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
return { }
