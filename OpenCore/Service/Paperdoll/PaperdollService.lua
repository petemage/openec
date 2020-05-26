local PaperdollService ={
  Listeners = {},
  Paperdolls = {},
  
  Initialize = function (self)
    LoadResources( 
      "./UserInterface/"..SystemData.Settings.Interface.customUiName.."/OpenCore/Service/Paperdoll", 
      "PaperdollWindow.xml", 
      "PaperdollWindow.xml" 
    )
  end,
  
  Shutdown = function (self)
  
  end,
  
  Get = function (self, id, name)
    if self.Paperdolls[id] == nil then
      self.Paperdolls[id] = OpenCore.Classes.Paperdoll.Paperdoll:Create(id, name)
    end
    return self.Paperdolls[id]
  end,
  
  AddListener = function (self, alias, listener) 
    self.Listeners[alias] = listener
  end,
  
  RemoveListener = function (self, alias)
    self.Listeners[alias] = nil
  end,
  
  OnWindowInitialize = function ()
    local self = OpenCore.Paperdoll
    local id = SystemData.Paperdoll.Id
    local name = WStringToString(SystemData.Paperdoll.Name or L"")
    local paperdoll = self:Get(id, name)
    for alias, listener in pairs(self.Listeners) do
      pcall(listener, paperdoll)
    end
    OpenCore.CloseOnUpdate = OpenCore:GetActiveDialog()
  end,
  
  OnWindowShutdown = function ()
    local self = OpenCore.Paperdoll
  end
}
OpenCore:RegisterServiceClass("Paperdoll.PaperdollService", "Paperdoll", PaperdollService)