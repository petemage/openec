local LuaTab = {
  Name = "LuaTab",
  Title = "Lua",
  
  InitializeLuaTab = function (self, parent)
    local tabName = parent..".LuaTab"
    OpenCore.Window:CreateFromTemplate(tabName, "OpenUI.DebugWindow.LuaTab", parent)
  end,
  
  OnLuaInput = function (self)
    local query = TextEditBoxGetText(self.Name..".Tabs.LuaTab.TextInput")
    OpenCore:Chat(query)
  end
}
OpenUI.DebugWindow:AddTab(LuaTab)