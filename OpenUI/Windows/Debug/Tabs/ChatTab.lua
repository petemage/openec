local ChatTab = {
  Name = "ChatTab",
  Title = "Log",

  ShowSystem = true,
  ShowDebug = true,
  ShowFunction = false,
  ShowWarning = true,
  ShowError = true,

  InitializeChatTab = function (self, parent)
    local chatTab = parent..".ChatTab"
    OpenCore.Window:CreateFromTemplate(chatTab, "OpenUI.DebugWindow.Chat", parent)
    
    self:SetLabel(chatTab..".Footer.System", L"System")
    ButtonSetPressedFlag(chatTab..".Footer.System.Button", self.ShowSystem)
    self:SetLabel(chatTab..".Footer.Error", L"Error")
    ButtonSetPressedFlag(chatTab..".Footer.Error.Button", self.ShowError)
    self:SetLabel(chatTab..".Footer.Debug", L"Debug")
    ButtonSetPressedFlag(chatTab..".Footer.Debug.Button", self.ShowDebug)
    self:SetLabel(chatTab..".Footer.Warning", L"Warning")
    ButtonSetPressedFlag(chatTab..".Footer.Warning.Button", self.ShowWarning)
    self:SetLabel(chatTab..".Footer.Function", L"Function")
    ButtonSetPressedFlag(chatTab..".Footer.Function.Button", self.ShowFunction)
    
    local logDisplay = chatTab..".LogDisplay"
    -- Display Settings
    LogDisplaySetShowTimestamp(logDisplay, false )
    LogDisplaySetShowLogName(logDisplay, true )
    LogDisplaySetShowFilterName(logDisplay, true )

     -- Add the Lua Log
    LogDisplayAddLog(logDisplay, "UiLog", true)
    
    LogDisplaySetFilterState(logDisplay, "UiLog", OpenCore.Logging.FILTER_SYSTEM, self.ShowSystem)
    LogDisplaySetFilterState(logDisplay, "UiLog", OpenCore.Logging.FILTER_DEBUG, self.ShowDebug)
    LogDisplaySetFilterState(logDisplay, "UiLog", OpenCore.Logging.FILTER_FUNCTION, self.ShowFunction)
    LogDisplaySetFilterState(logDisplay, "UiLog", OpenCore.Logging.FILTER_WARNING, self.ShowWarning)
    LogDisplaySetFilterState(logDisplay, "UiLog", OpenCore.Logging.FILTER_ERROR, self.ShowError)
    
    LogDisplaySetFilterColor(logDisplay, "UiLog", OpenCore.Logging.FILTER_SYSTEM, 200, 200, 200)
    LogDisplaySetFilterColor(logDisplay, "UiLog", OpenCore.Logging.FILTER_DEBUG, 255, 255, 255)
    LogDisplaySetFilterColor(logDisplay, "UiLog", OpenCore.Logging.FILTER_FUNCTION, 153, 153, 153)
    LogDisplaySetFilterColor(logDisplay, "UiLog", OpenCore.Logging.FILTER_WARNING, 255, 191, 0)
    LogDisplaySetFilterColor(logDisplay, "UiLog", OpenCore.Logging.FILTER_ERROR, 255, 64, 0)
    
    WindowSetShowing(chatTab, false)
  end,
  
  SetLabel = function (self, name, text)
    LabelSetText(name..".Label", text)
    local wl, hl = LabelGetTextDimensions(name..".Label")
    local wb, hb = WindowGetDimensions(name..".Button")
    WindowSetDimensions(name, wl + wb + 2, hb)
  end,

  OnToggleSystem = function (self)
    self.ShowSystem = not self.ShowSystem
    self:Toggle("System", OpenCore.Logging.FILTER_SYSTEM, self.ShowSystem)
  end,
  
  OnToggleError = function (self)
    self.ShowError = not self.ShowError
    self:Toggle("Error", OpenCore.Logging.FILTER_ERROR, self.ShowError)
  end,
  
  OnToggleWarning = function (self)
    self.ShowWarning = not self.ShowWarning
    self:Toggle("Warning", OpenCore.Logging.FILTER_WARNING, self.ShowWarning)
  end,
  
  OnToggleDebug = function (self)
    self.ShowDebug = not self.ShowDebug
    self:Toggle("Debug", OpenCore.Logging.FILTER_DEBUG, self.ShowDebug)
  end,

  OnToggleFunction = function (self)
    self.ShowFunction = not self.ShowFunction
    self:Toggle("Function", OpenCore.Logging.FILTER_FUNCTION, self.ShowFunction)
  end,
  
  Toggle = function (self, name, filter, value)
    ButtonSetPressedFlag(
      self.Name..".Tabs.ChatTab.Footer."..name..".Button", 
      value
    )
    LogDisplaySetFilterState(
      self.Name..".Tabs.ChatTab.LogDisplay", 
      "UiLog", 
      filter, 
      value
    )
  end
}
OpenUI.DebugWindow.ChatTab = ChatTab
OpenUI.DebugWindow:AddTab(ChatTab)
