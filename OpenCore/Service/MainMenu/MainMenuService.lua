local MainMenuService = {
  
  --
  -- Public
  --
  
  EVENT_MENU_SHOW = 1,
  EVENT_MENU_HIDE = 2,
  
  AddMenuItem = function (self, alias, label, handler)
    if type(label) == "string" then
      label = StringToWString(label)
    end
    self.MenuItems[alias] = OpenCore.Classes.MainMenu.MenuItem:Create(alias, label, handler)
  end,
  
  RemoveMenuItem = function (self, alias)
    self.MenuItems[alias] = nil
  end,

  GetItems = function (self)
    return self.MenuItems
  end,
  
  TriggerItem = function (self, alias)
    if self.MenuItems[alias] ~= nil then
      local handler = self.MenuItems[alias]:GetHandler()
      handler()
    end
  end,
  
  AddListener = function (self, alias, listener) 
    self.MainMenuListeners[alias] = listener
  end,
  
  RemoveListener = function (self, alias)
    self.MainMenuListeners[alias] = nil
  end,
  
  -- 
  -- Private
  --
  
  MenuItems = {},
  MainMenuListeners = {},
  
  Initialize = function (self)
    LoadResources( 
      "./UserInterface/"..SystemData.Settings.Interface.customUiName.."/OpenCore/Service/MainMenu", 
      "MainMenuWindow.xml", 
      "MainMenuWindow.xml" 
    )
    -- We need to create the global name "MainMenuWindow" as this is the hardcoded callback into the UI code
    MainMenuWindow = {}
    MainMenuWindow.OnShow = function ()
      self:NotifyShown ()
    end
    MainMenuWindow.OnHide = function ()
      self:NotifyHidden ()
    end
    CreateWindow("MainMenuWindow", false)
  end,
  
  Shutdown = function (self)
  
  end,
  
  NotifyShown = function (self)
    for alias, listener in pairs(self.MainMenuListeners) do
      pcall(listener, self.EVENT_MENU_SHOW)
    end
  end,
  
  NotifyHidden = function (self)
    for alias, listener in pairs(self.MainMenuListeners) do
      pcall(listener, self.EVENT_MENU_HIDE)
    end
  end
}

OpenCore:RegisterClass("MainMenu.MainMenuService", MainMenuService)
OpenCoreRegisterService("MainMenu", MainMenuService)
