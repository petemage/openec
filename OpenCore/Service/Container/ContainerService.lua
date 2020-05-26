local ContainerService = {

  EVENT_WINDOW_INITIALIZE = 0,
  EVENT_WINDOW_SHUTDOWN = 1,
    
  AddWindowListener = function (self, alias, listener)
    self.WindowListeners[alias] = listener
  end,
  
  RemoveWindowListener = function (self, alias)
    self.WindowListeners[alias] = nil
  end,
  
  AddUpdateListener = function (self, id, listener)
    self.UpdateListeners[id] = self.UpdateListeners[id] or {}
    table.insert(self.UpdateListeners[id], listener)
  end,
  
  RemoveUpdateListener = function (self, id)
    self.UpdateListeners[id] = {}
  end,

  -- Listeners when new container windows are requested
  WindowListeners = {},
  
  -- Listeners when containers get updated
  UpdateListeners = {},
  
  -- Map of all container objects (indexed by id)
  Containers = {},
  
  Initialize = function (self)
    LoadResources( 
      "./UserInterface/"..SystemData.Settings.Interface.customUiName.."/OpenCore/Service/Container", 
      "ContainerWindow.xml", 
      "ContainerWindow.xml" 
    )
    self.OnInitializeWindowWrap = function ()
      self:InitializeWindow()
      OpenCore.CloseOnUpdate = OpenCore.Window:GetActiveWindowName()
    end
    self.OnContainerUpdateWrap = function ()
      self:OnContainerUpdate()
    end
    WindowRegisterEventHandler("Root", WindowData.ContainerWindow.Event, "OpenCore.Container.OnContainerUpdateWrap")
  end,
  
  Shutdown = function (self)
    WindowUnregisterEventHandler("Root", WindowData.ContainerWindow.Event, "OpenCore.Container.OnContainerUpdateWrap")
  end,
  
  GetContainer = function (self, id)
    local container = self.Containers[id]
    if container == nil then
      container = OpenCore.Classes.Container.Container:Create(id)
      self.Containers[id] = container
    end
    return container
  end,
  
  OnContainerUpdate = function (self)
    local id = WindowData.UpdateInstanceId
    local ct = self:GetContainer(id)
    -- TODO: buffer events
    --OpenCore:Chat("update ct: " .. ct:GetId())
    local listeners = self.UpdateListeners[id] or {}
    for i, listener in pairs(listeners) do
      pcall(listener, self, ct)
    end
  end,
  
  InitializeWindow = function (self)
    local id = SystemData.DynamicWindowId
    local ct = self:GetContainer(id)
    ct.MaxSlots = SystemData.ActiveContainer.NumSlots
    for alias, listener in pairs(self.WindowListeners) do
      pcall(listener, self, self.EVENT_WINDOW_INITIALIZE, ct)
    end
  end
}

OpenCore:RegisterServiceClass("Container.ContainerService", "Container", ContainerService)
