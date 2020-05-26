local Container = {
  Id = nil,
  Opened = false,
  MaxSlots = 0,
  
  Create = function (self, id)
    local ct = {}
    setmetatable(ct, self)
    ct.Id = id
    ct.Opened = false
    ct.MaxSlots = 0
    return ct
  end,

  Open = function (self)
    if self.Opened then
      return
    end
    RegisterWindowData(WindowData.ContainerWindow.Type, self.Id)
    self.Opened = true
  end,
  
  Close = function (self)
    if not self.Opened then
      return
    end
    UnregisterWindowData(WindowData.ContainerWindow.Type, self.Id)
    self.Opened = false
  end,
  
  IsOpen = function (self)
    return self.Opened == true
  end,
  
  IsCorpse = function (self)
    local data = WindowData.ContainerWindow[self.Id]
    return data.isCorpse
  end,
  
  IsSnooped = function (self)
    local data = WindowData.ContainerWindow[self.Id]
    return data.isSnooped
  end,
  
  GetItems = function (self)
    local data = WindowData.ContainerWindow[self.Id]
    return data.ContainedItems
  end,
  
  GetItemCount = function (self)
    local data = WindowData.ContainerWindow[self.Id]
    return tonumber(data.numItems)
  end,
  
  GetMaxSlots = function (self)
    if self.MaxSlots and self.MaxSlots > 0 then    
      return self.MaxSlots
    else
      return self:GetItemCount()
    end
  end,
  
  GetGumpNum = function (self)
    local data = WindowData.ContainerWindow[self.Id]
    return data.gumpNum
  end,
  
  GetName = function (self)
    return WStringToString(self:GetLabel() or L"")
  end,
  
  GetLabel = function (self)
    local data = WindowData.ContainerWindow[self.Id]
    if data then
      return data.containerName
    else
      return nil
    end
  end,
  
  GetId = function (self)
    return self.Id
  end,
  
  GetData = function (self)
    return WindowData.ContainerWindow[self.Id]
  end
}
Container.__index = Container

OpenCore:RegisterClass("Container.Container", Container)