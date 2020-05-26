OpenCore = {
  Version = "2019-08-29",
  Classes = {},
  Classes2 = {},
  TimePassed = 0,
  CloseOnUpdate = nil,
  ClassRegistrationFinished = false,
  
  Initialize = function (self)
    self.ClassRegistrationFinished = true
  
    self.Debug:Initialize()
    self.MainMenu:Initialize()
    self.StaticText:Initialize()
    self.OverheadText:Initialize()
    self.ContextMenu:Initialize()
    self.Player:Initialize()
    self.Mobile:Initialize()
    self.Hotbar:Initialize()
    self.Viewport:Initialize()
    self.Window:Initialize()
    self.Container:Initialize()
    self.Targeting:Initialize()
    self.Shop:Initialize()
    self.Skills:Initialize()
    self.Paperdoll:Initialize()
    self.TipoftheDay:Initialize()
    self.Spellbook:Initialize()
    self.GenericGump:Initialize()
    self.Logging:Initialize()
    
  end,
  
  Shutdown = function (self)
    self.Debug:Shutdown()
    self.MainMenu:Shutdown()
    self.StaticText:Shutdown()
    self.OverheadText:Shutdown()
    self.ContextMenu:Shutdown()
    self.Player:Shutdown()
    self.Mobile:Shutdown()
    self.Hotbar:Shutdown()
    self.Viewport:Shutdown()
    self.Window:Shutdown()
    self.Targeting:Shutdown()
    self.Shop:Shutdown()
    self.Skills:Shutdown()
    self.Paperdoll:Shutdown()
    self.TipoftheDay:Shutdown()
    self.Spellbook:Shutdown()
    self.GenericGump:Shutdown()
    self.Logging:Shutdown()
  end,
  
  Update = function (self, timePassed) 
    if self.CloseOnUpdate ~= nil then
      self.Window:Close(OpenCore.CloseOnUpdate)
      self.CloseOnUpdate = nil
    end
    
    self.TimePassed = self.TimePassed + timePassed
  end,
  
  GetServiceDir = function (self)
    return "./UserInterface/"..SystemData.Settings.Interface.customUiName.."/OpenCore/Service"
  end,
  
  Now = function (self)
    return self.TimePassed
  end,
  
  Chat = function (self, ...)
    self.Debug:Chat(...)
  end,
  
  GetScale = function (self)
    return self.Client:GetScale()
  end,
  
  GetMousePosition = function (self)
    return self.Client:GetMousePosition()
  end,
  
  GetWindowData = function (self, name)
    return self.Window:GetWindowData(name)
  end,
  
  GetActiveDialog = function (self)
    return self.Window:GetActiveDialog()
  end,
  
  GetActiveWindow = function (self)
    return self.Window:GetActiveWindowName()
  end,
  
  PrintBanner = function (self)
    self:Chat("OpenEC version " .. self.Version)
    --self.Debug:DumpToChat("OpenEC.Classes", self.Classes, {}, 1)
    self:Chat("InterfaceScale = " .. self.Client:GetScale())
  end,
  
  RegisterClass = function (self, namespace, class)
    local n = namespace .. "."
    local names = {}
    for name in n:gmatch("(.-)%.") do
      table.insert(names, name)
    end
    local namespacesCount = table.getn(names)
    local currentNamespace = self.Classes
    for i = 0, namespacesCount-2 do
      local name = names[i+1]
      currentNamespace[name] = currentNamespace[name] or {}
      currentNamespace = currentNamespace[name]
    end
    currentNamespace[names[namespacesCount]] = class
  end,
  
  RegisterService = function (self, name, service)
    self[name] = service
  end,
  
  RegisterServiceClass = function (self, namespace, name, service)
    self:RegisterClass(namespace, service)
    self:RegisterService(name, service)  
  end,
  
  DefineClass = function (self, class)
    return class
  end
}

OpenCore.ImplicitCreateTable = function (t, index)
    if OpenCore.ClassRegistrationFinished then
      return nil
    end
    --OpenCore:Chat("Implictely creating table: " .. index)
    local new = {}
    setmetatable(new, {
      __index = OpenCore.ImplicitCreateTable
    })
    return new
end

setmetatable(OpenCore.Classes2, {
  __index = OpenCore.ImplicitCreateTable
})

TextLogSetIncrementalSaving("UiLog", true, "logs/ui.log")

function OpenCoreRegisterService (name, service)
  OpenCore:RegisterService(name, service)
end

string.split = function (str, pattern)
  local full = str .. pattern
  local all = {}
  if (pattern == ".") then
    pattern = "%."
  end
  for match in full:gmatch("(.-)"..pattern) do
    table.insert(all, match)
  end
  return all
end

wstring.split = function (str, pattern)
  local full = str .. pattern
  local all = {}
  if (pattern == L".") then
    pattern = L"%."
  end
  for match in full:gmatch(L"(.-)"..pattern) do
    table.insert(all, match)
  end
  return all
end