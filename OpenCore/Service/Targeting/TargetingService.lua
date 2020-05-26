local TargetingService = {

  TYPE_TARGET = 0,
  TYPE_MOBILE = 2,
  TYPE_OBJECT = 3,
  TYPE_CORPSE = 4,

  Listeners = {},
  Previous = nil,

  Initialize = function (self)
    RegisterWindowData(WindowData.CurrentTarget.Type, 0)
    self.OnUpdateTargetWrap = function ()
      self:OnUpdateTarget()
    end
    WindowRegisterEventHandler("Root", WindowData.CurrentTarget.Event, "OpenCore.Targeting.OnUpdateTargetWrap")
  end,
  
  Shutdown = function (self)
    WindowUnregisterEventHandler("Root", WindowData.CurrentTarget.Event, "OpenCore.Targeting.OnUpdateTargetWrap")
    UnregisterWindowData(WindowData.CurrentTarget.Type, 0)  
  end,
  
  OnUpdateTarget = function (self)
    -- Unload previous target
    if self.Previous ~= nil then
      self.Previous:Unload()
    end 
    -- create new target object, load it and store as new previous
    local target = self:GetTarget()
    if target then
      target:Load()
      self.Previous = target
      -- call registered listeners with target and type arguments
      for alias, listener in pairs(self.Listeners) do
        pcall(listener, target, self:GetType())
      end
    end
  end,
  
  AddListener = function (self, alias, listener) 
    self.Listeners[alias] = listener
  end,
  
  RemoveListener = function (self, alias)
    self.Listeners[alias] = nil
  end,
  
  GetId = function (self)
    return WindowData.CurrentTarget.TargetId
  end,
  
  GetType = function (self)
    return WindowData.CurrentTarget.TargetType
  end,
  
  HasTarget = function (self)
    return WindowData.CurrentTarget.HasTarget
  end,
  
  GetTarget = function (self)
    if not self:HasTarget() then
      return nil
    end
    
    local id = self:GetId()
    local object = OpenCore.Object:GetObject(id)
    return object
  end
}
OpenCore:RegisterServiceClass("Targeting.TargetingService", "Targeting", TargetingService)