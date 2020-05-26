local ModsTab = {
  Name = "ModsTab",
  Title = "Mods",
  
  InitializeModsTab = function (self, parent)
    local tabName = parent..".ModsTab"
    OpenCore.Window:CreateFromTemplate(tabName, "OpenUI.DebugWindow.ModsTab", parent)
    
    local mods = ModulesGetData()
    for i, mod in pairs(mods) do
      OpenCore:Chat(mod.name .." version "..mod.version)
    end
  end
}
OpenUI.DebugWindow:AddTab(ModsTab)