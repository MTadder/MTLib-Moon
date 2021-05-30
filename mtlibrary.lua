local META_INFO = [[KL0E]]
local state
local State
do
  local _class_0
  local _base_0 = {
    members = { },
    _include = function(self, members)
      for i, k in pairs(members) do
        self.members[i] = k
      end
      return self
    end,
    __add = function(left, right)
      if type(right) == type(left) then
        if (left.__class == right.__class) then
          left:_include(right.members)
        else
          do
            left:_include(right)
          end
        end
        return left
      end
    end,
    __call = function(self, member, ...)
      for i, k in pairs(self.members) do
        if (i == member) then
          return k(...)
        end
      end
      return nil
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, source)
      local _exp_0 = (type(source))
      if "table" == _exp_0 then
        do
          return (self + source)
        end
      elseif "string" == _exp_0 then
        do
          local data = require(source)
          return (self + dat)
        end
      end
    end,
    __base = _base_0,
    __name = "State"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  State = _class_0
  state = _class_0
end
local MTLibrary = {
  Logic = {
    State = state
  },
  Math = {
    Quadra = (function()
      local Quadra
      do
        local _class_0
        local _base_0 = {
          __tostring = function(self)
            return ("x=" .. tostring(self.x) .. ", y=" .. tostring(self.y) .. ", o=" .. tostring(self.o) .. ", t=" .. tostring(self.t))
          end,
          __add = function(left, right)
            local _exp_0 = (type(left))
            if "number" == _exp_0 then
              do
                return Quadra(left + right.x, left + right.y, left + right.o, left + right.t)
              end
            elseif "table" == _exp_0 then
              do
                if type(right) == "number" then
                  return Quadra(left.x + right, left.y + right, left.o + right, left.t + right)
                end
                if (left.__class ~= nil) then
                  if (left.__name == right.__name) then
                    return Quadra(left.x + right.x, left.y + right.y, left.o + right.o, left.t + right.t)
                  end
                end
              end
            end
            return error("Invalid addition! (" .. tostring(type(left)) .. " + " .. tostring(type(right)) .. ")")
          end,
          __sub = function(left, right)
            local _exp_0 = (type(left))
            if "number" == _exp_0 then
              do
                return Quadra(left - right.x, left - right.y, left - right.o, left - right.t)
              end
            elseif "table" == _exp_0 then
              do
                if type(right) == "number" then
                  return Quadra(left.x - right, left.y - right, left.o - right, left.t - right)
                end
                if (left.__class ~= nil) then
                  if (left.__name == right.__name) then
                    return Quadra(left.x - right.x, left.y - right.y, left.o - right.o, left.t - right.t)
                  end
                end
              end
            end
            return error("Invalid subtraction! (" .. tostring(type(left)) .. " - " .. tostring(type(right)) .. ")")
          end,
          __mul = function(left, right)
            local _exp_0 = (type(left))
            if "number" == _exp_0 then
              do
                return Quadra(left * right.x, left * right.y, left * right.o, left * right.t)
              end
            elseif "table" == _exp_0 then
              do
                if type(right) == "number" then
                  return Quadra(left.x * right, left.y * right, left.o * right, left.t * right)
                end
                if (left.__class ~= nil) then
                  if (left.__name == right.__name) then
                    return Quadra(left.x * right.x, left.y * right.y, left.o * right.o, left.t * right.t)
                  end
                end
              end
            end
            return error("Invalid multiplication! (" .. tostring(type(left)) .. " * " .. tostring(type(right)) .. ")")
          end,
          __div = function(left, right)
            local _exp_0 = (type(left))
            if "number" == _exp_0 then
              do
                return Quadra(left / right.x, left / right.y, left / right.o, left / right.t)
              end
            elseif "table" == _exp_0 then
              do
                if type(right) == "number" then
                  return Quadra(left.x / right, left.y / right, left.o / right, left.t / right)
                end
                if (left.__class ~= nil) then
                  if (left.__name == right.__name) then
                    return Quadra(left.x / right.x, left.y / right.y, left.o / right.o, left.t / right.t)
                  end
                end
              end
            end
            return error("Invalid division! (" .. tostring(type(left)) .. " / " .. tostring(type(right)) .. ")")
          end,
          __unm = function(self)
            return Quadra(-self.x, -self.y, -self.o, -self.t)
          end
        }
        _base_0.__index = _base_0
        _class_0 = setmetatable({
          __init = function(self, X, Y, O, T)
            self.x = (tonumber(X) or 0)
            self.y = (tonumber(Y) or 0)
            self.o = (tonumber(O) or 0)
            self.t = (tonumber(T) or 0)
            return self
          end,
          __base = _base_0,
          __name = "Quadra"
        }, {
          __index = _base_0,
          __call = function(cls, ...)
            local _self_0 = setmetatable({}, _base_0)
            cls.__init(_self_0, ...)
            return _self_0
          end
        })
        _base_0.__class = _class_0
        Quadra = _class_0
        return _class_0
      end
    end)(),
    truncate = function(value)
      if (value == nil) then
        return nil
      end
      if (value >= 0) then
        return math.floor(value + 0.5)
      else
        do
          return math.ceil(value - 0.5)
        end
      end
    end
  }
}
local BinaryFormat = package.cpath:match("%p[\\|/]?%p(%a+)")
if describe ~= nil then
  describe("MTLibrary", function()
    it("has no nil-errors", function()
      return assert.has_no.errors(function()
        local recurse
        recurse = function(target)
          for _, member in pairs(target) do
            if (type(member) == "function") then
              member(nil)
            elseif (type(member) == "table") then
              if (member.__class == nil) then
                recurse(member)
              end
            end
          end
        end
        return recurse(MTLibrary)
      end)
    end)
    it("supports Quadra mathematics", function()
      return assert.has_no.errors(function()
        local m1 = MTLibrary.Math.Quadra()
        m1 = m1 + 256
        local m2 = -m1 / 256
        return print(m1, m2)
      end)
    end)
    return it("supports Stately mechanisms", function()
      return assert.has_no.errors(function()
        local s1 = MTLibrary.Logic.State({
          'default'
        })
        s1 = s1 + {
          foo = function()
            return print("yeet")
          end,
          woo = function(...)
            return print(...)
          end
        }
        s1('foo')
        return s1('woo', 420, 'etc', 520)
      end)
    end)
  end)
  print("MTLibrary(" .. tostring(META_INFO) .. ")-" .. tostring(BinaryFormat) .. "-busted")
  return true
end
if love ~= nil then
  MTLibrary.Graphics = {
    fit = function(monitorRatio)
      if monitorRatio == nil then
        monitorRatio = 1
      end
      local oldW, oldH, currentFlags = love.window.getMode()
      local screen, window = { }, { }
      screen.w, screen.h = love.window.getDesktopDimensions(currentFlags.display)
      local newWindowWidth = truncate(screen.w / monitorRatio)
      local newWindowHeight = truncate(screen.h / monitorRatio)
      if (oldW == newWindowWidth) and (oldH == newWindowHeight) then
        return nil, nil
      end
      window.display, window.w = currentFlags.display, newWindowWidth
      window.h = newWindowHeight
      window.x = truncate((screen.w * 0.5) - (window.w * 0.5))
      window.y = truncate((screen.h * 0.5) - (window.h * 0.5))
      currentFlags.x, currentFlags.y = window.x, window.y
      love.window.setMode(window.w, window.h, currentFlags)
      return screen, window
    end,
    getCenter = function(offset, offsetY)
      local w, h = love.graphics.getDimensions()
      return ((w - offset) * 0.5), ((h - (offsetY or offset)) * 0.5)
    end
  }
  print("MTLibrary(" .. tostring(META_INFO) .. ")-" .. tostring(BinFormat) .. "-LOVE")
end
return (MTLibrary) or error("MTLibrary failure!")
