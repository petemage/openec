local Paperdoll = {
  Id = nil,
  Name = "",
  
  Create = function (self, id, name)
    local p = {}
    setmetatable(p, self)
    p.Id = id
    p.Name = name
    return p
  end,
  
  GetId = function (self)
    return self.Id
  end,
  
  GetName = function (self)
    return self.Name or ""
  end,
  
  GetTextureData = function (self)
    return SystemData.PaperdollTexture[self.Id]
  end,
  
  GetTextureName = function (self)
    return "paperdoll_texture" .. self.Id
  end,
  
  Load = function (self)
    RegisterWindowData(WindowData.Paperdoll.Type, self.Id)
  end,
  
  Unload = function (self)
    UnregisterWindowData(WindowData.Paperdoll.Type, self.Id)
  end
}
Paperdoll.__index = Paperdoll
OpenCore:RegisterClass("Paperdoll.Paperdoll", Paperdoll)