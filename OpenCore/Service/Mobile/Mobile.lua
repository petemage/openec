local Mobile = {
  Id = nil,
  
  Create = function (self, id)
    local m = {}
    setmetatable(m, self)
    m.Id = id
    return m
  end,
  
  GetId = function (self)
    return self.Id
  end
}
Mobile.__index = Mobile
OpenCore:RegisterClass("Mobile.Mobile", Mobile)