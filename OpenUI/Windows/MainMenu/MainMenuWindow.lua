local MainMenuWindow = {
  WindowName = "OpenUI.MainMenuWindow",

  OnInitialize = function ()
    local items = OpenCore.MainMenu:GetItems()
    local self = OpenUI.MainMenuWindow
    local y = 5
    for key, menuItem in pairs(items) do 
      local window = "OpenUI.MainMenuWindow."..menuItem:GetAlias()
      CreateWindowFromTemplate(window, "OpenUI.MainMenuItem", "OpenUI.MainMenuWindow")
      ButtonSetText(window..".Button", menuItem:GetLabel())
      WindowAddAnchor(window, "top", "OpenUI.MainMenuWindow", "top", 0, y)
      y = y + 45
    end
    local w, h = WindowGetDimensions(self.WindowName)
    WindowSetDimensions(self.WindowName, w, y + 5)
  end,
  
  OnShutdown = function ()
  
  end,
  
  OnClick = function ()
    local alias = SystemData.ActiveWindow.name:split(".")[3]
    OpenCore.MainMenu:TriggerItem(alias)
  end
}

OpenUI.MainMenuWindow = MainMenuWindow