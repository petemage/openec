local DebugWindow = {
  Count = 0,
  CurrentTab = 2,
  Tabs = {},

  AddTab = function (self, tab)
    table.insert(self.Tabs, tab)
  end,

  OnGetWindowName = function (self)
    OpenUI.DebugWindow.Count = OpenUI.DebugWindow.Count + 1
    return "OpenUI.DebugWindow." .. OpenUI.DebugWindow.Count
  end,
  
  OnGetTemplate = function (self)
    return "OpenUI.DebugWindow"
  end,

  OnInitialize = function (self)
    OpenCore.Window:RestorePosition()
    
    local parent = self.Name
    
    -- Initialize Tabs
    local tabs = parent..".Tabs"
    self:InitializeChatTab(tabs)
    self:InitializeTextureTab(tabs)
    self:InitializeLuaTab(tabs)
    self:InitializeModsTab(tabs)
    
    self:ShowCurrentTab()
  end,
  
  OnShutdown = function (self)
    OpenCore.Window:SavePosition()
  end,
  
  OnPreviousTab = function (self)
    self.CurrentTab = self.CurrentTab - 1
    if self.CurrentTab < 1 then
      self.CurrentTab = table.getn(self.Tabs)
    end
    self:ShowCurrentTab()
  end,
  
  OnNextTab  = function (self)
    self.CurrentTab = self.CurrentTab + 1
    if self.CurrentTab > table.getn(self.Tabs) then
      self.CurrentTab = 1
    end
    self:ShowCurrentTab()
  end,
  
  ShowCurrentTab = function (self)
    for i, tab in pairs(self.Tabs) do
      if DoesWindowExist(self.Name..".Tabs."..tab.Name) then
        WindowSetShowing(self.Name..".Tabs."..tab.Name, i ==  self.CurrentTab)
      end
      if i == self.CurrentTab then
        LabelSetText(self.Name..".Title", L"Debug - " .. StringToWString(tab.Title))
      end
    end
  end
}
DebugWindow.__index = function (table, index)
  if rawget(table, index) ~= nil then
    return rawget(table, index)
  end
  if OpenUI.DebugWindow[index] ~= nil then
    return OpenUI.DebugWindow[index]
  end
  for i, tab in pairs(OpenUI.DebugWindow.Tabs) do
    if tab[index] ~= nil then
      return tab[index]
    end
  end
  return nil
end
DebugWindow.Handler = OpenCore.Window.Handler
OpenUI.DebugWindow = DebugWindow