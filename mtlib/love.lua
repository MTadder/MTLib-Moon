local love = (love or nil)
if (love == nil) then
  return { }
end
local Hexad
Hexad = require([[mtlib.math]]).Hexad
local isCallable
isCallable = require([[mtlib.logic]]).isCallable
local ShaderCode
do
  local _class_0
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      return error()
    end,
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
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      return error()
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
      error()
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
      return error()
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
      return error()
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
      error()
      self.Text = (tostring(text) or [[NIL]])
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
    __init = function(self)
      return error()
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
    __init = function(self)
      return error()
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
    setPixel = function(self, x, y, color)
      assert(#color == 4, [[color table must have 4 values]])
      local iD = self.Image:getData()
      iD:setPixel(x, y, color[1], color[2], color[3], color[4])
      self.Image = love.graphics.newImage(iD)
      return (self)
    end,
    map = function(self, func, x, y, w, h)
      if isCallable(func) then
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
      error()
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
      error()
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
local _ = {
  ShaderCode = ShaderCode,
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
    return error()
  end,
  fit = function(monitorRatio)
    if monitorRatio == nil then
      monitorRatio = 1
    end
    return error()
  end,
  getCenter = function(offset, offsetY)
    return error()
  end
}
return { }
