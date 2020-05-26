local Object = {
  Id = nil,
  LoadCount = 0,

  Create = function (self, id)
    if id == nil then
      return nil
    end
    local object = {}
    setmetatable(object, self)
    object.Id = id
    object.LoadCount = 0
    return object
  end,
  
  Load = function (self)
    self.LoadCount = self.LoadCount + 1
    if self.LoadCount > 1 then
      return
    end
    RegisterWindowData(WindowData.ObjectInfo.Type, self.Id)
    RegisterWindowData(WindowData.ObjectTypeQuantity.Type, self.Id)
    --OpenCore:Chat(WindowData.ObjectInfo[self.Id])
  end,
  
  Unload = function (self)
    --self.LoadCount = self.LoadCount - 1
    if self.LoadCount > 0 then
      return
    end
    UnregisterWindowData(WindowData.ObjectInfo.Type, self.Id)
    UnregisterWindowData(WindowData.ObjectTypeQuantity.Type, self.Id)
    self.LoadCount = 0
  end,
  
  IsLoaded = function (self)
    return self.LoadCount > 0
  end,
  
  GetId = function (self)
    return self.Id
  end,
  
  GetName = function (self)
    if WindowData.ObjectInfo[self.Id] ~= nil then
      return WStringToString(WindowData.ObjectInfo[self.Id].name)
    end
    return nil  
  end,
  
  GetLabel = function (self)
    return WindowData.ObjectInfo[self.Id].name
  end,
  
  GetSellContainerId = function (self)
    return WindowData.ObjectInfo[self.Id].sellContainerId
  end,
  
  GetShopValue = function (self)
    return WindowData.ObjectInfo[self.Id].shopValue
  end,
  
  GetShopQuantity = function (self)
    return WindowData.ObjectInfo[self.Id].shopQuantity or 0
  end,
  
  GetQuantity = function (self)
    local data = WindowData.ObjectInfo[self.Id]
    if data ~= nil then
      return WindowData.ObjectInfo[self.Id].quantity or 0
    else
      return 0
    end
  end,
  
  GetTypeQuantity = function (self)
    local data = WindowData.ObjectTypeQuantity[self.Id]
    if data ~= nil then
      return WindowData.ObjectTypeQuantity[self.Id].quantity or 0
    else
      return 0
    end
  end,
  
  GetObjectType = function (self)
    return WindowData.ObjectInfo[self.Id].objectType
  end,
  
  GetData = function (self)
    return WindowData.ObjectInfo[self.Id]
  end
}
Object.__index = Object
OpenCore:RegisterClass("Object.Object", Object)