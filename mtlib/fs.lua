fileExists = function(filename)
  local ioF = io.open(filename, 'r+')
  local result = (ioF ~= nil)
  if result then
    ioF:close()
  end
  return (result)
end
fileLines = function(filename)
  if not (fileExists(filename)) then
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
do
  local _class_0
  local _base_0 = {
    isValid = function(self)
      return (self.file_stream ~= nil)
    end,
    exists = function(self)
      assert(self.file_name, "no file name")
      return (fileExists(self.file_name))
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
return { }
