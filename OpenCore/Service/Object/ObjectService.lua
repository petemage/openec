local ObjectService = {
  Objects = {},

  Initialize = function (self)
    self.OnUpdateObjectWrap = function ()
      self:OnUpdateObject()
    end
    self.OnUpdateQuantityWrap = function ()
      self:OnUpdateQuantity()
    end
    WindowRegisterEventHandler("Root", WindowData.ObjectInfo.Event, "OpenCore.Object.OnUpdateObjectWrap")
    WindowRegisterEventHandler("Root", WindowData.ObjectTypeQuantity.Event, "OpenCore.Object.OnUpdateQuantityWrap")
    
  end,
  
  Shutdown = function (self)
    WindowUnregisterEventHandler("Root", WindowData.ObjectInfo.Event, "OpenCore.Object.OnUpdateObjectWrap")
    WindowUnregisterEventHandler("Root", WindowData.ObjectTypeQuantity.Event, "OpenCore.Object.OnUpdateQuantityWrap")
  end,
  
  OnUpdateObject = function (self)
  
  end,
  
  OnUpdateQuantity = function (self)
    OpenCore:Chat("quantity update eek")
  end,
  
  GetObject = function (self, id, load)
    if id == nil then
      return nil
    end
    local object = self.Objects[id]
    load = load or false
    if object ~= nil then
      return object
    end
    object = OpenCore.Classes.Object.Object:Create(id)
    self.Objects[id] = object
    if load then
      object:Load()
    end
    return object
  end,
  
  Debug = function (self)
    for id, object in pairs(self.Objects) do
      OpenCore:Chat("" .. id .. ": " .. object.LoadCount)
    end
  end
}
OpenCore:RegisterServiceClass("Object.ObjectService", "Object", ObjectService)