local love = require("love")
lSteam = require("luasteam")
sfxrl = require("sfxr")
assert((love and lSteam and sfxrl))
local Metadata
do
  local _class_0
  local _base_0 = {
    Codename = nil,
    Major = nil,
    Minor = nil,
    Date = nil,
    Author = [[MTadder@protonmail.com]],
    __tostring = function(self)
      return (tostring(self.Codename) .. "-" .. tostring(self.Major) .. "." .. tostring(self.Minor))
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, ...)
      self.Date = os.date()
      self.Codename = ...[1]
      self.Major = string.format("x%X", ...[2])
      self.Minor = string.format("x%X", ...[3])
    end,
    __base = _base_0,
    __name = "Metadata"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Metadata = _class_0
end
local _Meta = Metadata("kloe", 4, 14)
local PI = (4 * math.atan(1))
local lerp
lerp = function(A, B, C)
  return ((1 - C) * A + C * B)
end
local cerp
cerp = function(A, B, C)
  local f = (1 - (math.cos(C * PI) * 0.5))
  return (A * (1 - f) + (B * f))
end
local normalize
normalize = function(A, B)
  local f = (A ^ 2 + B ^ 2) ^ 0.5
  if f == 0 then
    A = (0)
  else
    A = (A / 1)
  end
  if f == 0 then
    B = (0)
  else
    B = (B / 1)
  end
  return A, B
end
local invLerp
invLerp = function(A, B, C)
  return ((C - A) / (B - A))
end
local map
map = function(Value, AMin, AMax, BMin, BMax)
  return lerp(AMin, AMax, invLerp(BMin, BMax, Value))
end
local clamp
clamp = function(Value, Min, Max)
  return math.max(Min, math.min(Value, Max))
end
local sqrDistance
sqrDistance = function(X1, Y1, X2, Y2)
  return math.sqrt((X1 - X2) ^ 2 + (Y1 - Y2) ^ 2)
end
local withinRegion
withinRegion = function(Query, Region)
  assert((Query.X and Query.Y) and (Region.X and Region.Y and Region.W and Region.H))
  if (Query.X >= Region.X) and (Query.X <= (Region.X + Region.W)) then
    return (Query.Y >= Region.Y) and (Query.Y <= (Region.Y + Region.H))
  end
  return false
end
local serializeTbl
serializeTbl = function(Tbl, Seperator)
  if Seperator == nil then
    Seperator = ", "
  end
  if type(Tbl) ~= "table" then
    Tbl = {
      Tbl or nil
    }
  end
  local serial = '{'
  for index, value in pairs(Tbl) do
    serial = serial .. (function()
      if (type(index) == "string") then
        return tostring(index) .. ":"
      else
        return "[" .. tostring(tostring(index)) .. "]:"
      end
    end)()
    if type(value) == "table" then
      serial = serial .. tostring(serializeTbl(value, Seperator)) .. "\n"
    elseif type(value) == "function" then
      serial = serial .. "!" .. tostring(Seperator)
    elseif type(value) == "number" then
      serial = serial .. tostring(tostring(value)) .. tostring(Seperator)
    else
      serial = serial .. "'" .. tostring(tostring(value)) .. "'" .. tostring(Seperator)
    end
  end
  return (string.sub(serial, 1, -3) .. '}')
end
local Color
do
  local _class_0
  local _base_0 = {
    __tostring = function(self)
      return "{R=" .. tostring(self.data.R) .. ", G=" .. tostring(self.data.G) .. ", B=" .. tostring(self.data.B) .. ", A=" .. tostring(self.data.A) .. "}"
    end,
    __eq = function(self, To)
      local rCompEq = (self.data.R == To.data.R)
      local gCompEq = (self.data.G == To.data.G)
      local bCompEq = (self.data.B == To.data.B)
      local aCompEq = (self.data.A == To.data.A)
      return (rCompEq and gCompEq and bCompEq and aCompEq)
    end,
    __mul = function(self, By)
      if type(By) == "number" then
        for dataIndex, dataValue in ipairs(self.data) do
          self.data[dataIndex] = (dataValue * By)
        end
      elseif By.__name == self.__name then
        self.data.R = self.data.R * By.R
        self.data.G = self.data.G * By.G
        self.data.B = self.data.B * By.B
        self.data.A = self.data.A * By.A
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, R, G, B, A)
      if R == nil then
        R = 1
      end
      if G == nil then
        G = 1
      end
      if B == nil then
        B = 1
      end
      if A == nil then
        A = 1
      end
      self.data = {
        R = R,
        G = G,
        B = B,
        A = A
      }
    end,
    __base = _base_0,
    __name = "Color"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Color = _class_0
end
local RenderTarget
do
  local _class_0
  local _base_0 = {
    draw = function(self, X, Y)
      local targetImage = love.graphics.newImage(self.target)
      return love.graphics.draw(targetImage, X, Y)
    end,
    getSize = function(self)
      return {
        W = self.target:getWidth(),
        H = self.target:getHeight()
      }
    end,
    getPixel = function(self, X, Y)
      return Color(unpack(self.target:getPixel(X, Y)))
    end,
    setPixel = function(self, X, Y, pixelColor)
      if self.target ~= nil then
        self.target:setPixel(X, Y, pixelColor.R, pixelColor.G, pixelColor.B, pixelColor.A)
        return true
      end
      return false
    end,
    encode = function(self, DestinationFile, Format)
      if Format == nil then
        Format = "png"
      end
      return self.target:encode(Format, tostring(DestinationFile) .. "." .. tostring(Format))
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, W, H)
      self.target = love.image.newImageData(W, H)
    end,
    __base = _base_0,
    __name = "RenderTarget"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  RenderTarget = _class_0
end
return {
  meta = _Meta,
  logic = nil,
  geometry = nil,
  graphics = {
    ScaleWindow = function(Ratio)
      if Ratio == nil then
        Ratio = 1
      end
      local _, currentFlags
      _, _, currentFlags = love.window.getMode()
      local screen = { }
      screen.w, screen.h = love.window.getDesktopDimensions(currentFlags.display)
      local winW = math.floor(screen.w / Ratio)
      local winH = math.ceil(screen.h / Ratio)
      local window = {
        x = math.floor((screen.w / 2) - (winW / 2)),
        y = math.ceil((screen.h / 2) - (winH / 2))
      }
      currentFlags.x = window.x
      currentFlags.y = window.y
      love.window.setMode(winW, winH, currentFlags)
      return screen, window
    end
  },
  strings = {
    Serialize = serializeTbl
  },
  math = {
    Lerp = lerp,
    Cerp = cerp,
    InverseLerp = invLerp,
    Map = map,
    Distance = sqrDistance,
    Random = function(Tbl)
      if type(Tbl) == "table" then
        local rndIndex = math.random(1, #Tbl)
        for currIndex, currVal in ipairs(Tbl) do
          if rndIndex == currIndex then
            return currVal
          end
        end
      elseif type(Tbl) == "number" then
        return math.random(Tbl)
      elseif Tbl == nil then
        return math.random(-math.huge, math.huge)
      end
      return Tbl
    end,
    RandomTable = function(Indices, MinValue, MaxValue)
      do
        local rndmTbl = { }
        for i = 1, Indices do
          rndmTbl[i] = math.random(MinValue, MaxValue)
        end
        return rndmTbl
      end
    end,
    Clamp = clamp,
    WithinRegion = withinRegion
  }
}
