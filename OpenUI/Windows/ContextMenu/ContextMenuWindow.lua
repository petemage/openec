local ContextMenuWindow = {
  OnInitialize = function ()
    local scale = OpenCore:GetScale() 
    local mouseX, mouseY = OpenCore:GetMousePosition()
    WindowSetOffsetFromParent(OpenCore:GetActiveWindow(), mouseX / scale, mouseY / scale)
    
    y = 5
    for i, item in pairs(OpenCore.ContextMenu:GetMenuItems()) do
      local windowName = "OpenUI.Windows.ContextMenuItem." .. item:GetAlias()
      CreateWindowFromTemplate(windowName, "OpenUI.ContextMenuItem", OpenCore:GetActiveWindow())
      ButtonSetText(windowName, item:GetLabel())
      OpenCore:Chat(item:GetLabel())
      WindowAddAnchor(windowName, "top", OpenCore:GetActiveWindow(), "top", 0, y)
      y = y + 25 + 2
    end
    local w, h = WindowGetDimensions(OpenCore:GetActiveWindow())
    WindowSetDimensions(OpenCore:GetActiveWindow(), w, y + 5)
  end,
  
  OnShutdown = function ()
    
  end,
  
  OnItemClick = function ()
    local alias = OpenCore:GetActiveWindow():split(".")[4]
    local item = OpenCore.ContextMenu:GetMenuItem(alias)  
    if item then
      item:Execute()
    end
  end
}

OpenUI.ContextMenuWindow = ContextMenuWindow