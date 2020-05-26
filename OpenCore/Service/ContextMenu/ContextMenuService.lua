local ContextMenuService = {

  --
  -- Public
  --
  
  EVENT_MENU_SHOW = 1,
  EVENT_MENU_HIDE = 2,
  
  Quiet = false,
  
  Show = function (self, id)
    if id then
      RequestContextMenu(id)
    else
      self.SkipResetAndStandardItemsOnce = true
      WindowSetShowing("ContextMenu", true)
    end
  end,
  
  RequestQuiet = function (self, id)
    self.Quiet = true
    RequestContextMenu(id)
  end,
  
  TriggerStandardItem = function (self, code)
    WindowData.ContextMenu.returnCode = code
    BroadcastEvent(SystemData.Events.CONTEXT_MENU_SELECTED) 
  end,
  
  AddListener = function (self, alias, listener) 
    self.Listeners[alias] = listener
  end,
  
  RemoveListener = function (self, alias)
    self.Listeners[alias] = nil
  end,
  
  -- 
  -- Private
  --
  
  MenuItems = {},
  Listeners = {},
  
  Initialize = function (self)
    LoadResources( 
      OpenCore:GetServiceDir().."/ContextMenu", 
      "ContextMenuWindow.xml", 
      "ContextMenuWindow.xml" 
    )
    -- We need to create the global name "MainMenuWindow" as this is the hardcoded callback into the UI code
    ContextMenuWindow = {}
    ContextMenuWindow.OnShow = function ()
      if self.Quiet then
        self.Quiet = false
        return
      end
      if not self.SkipResetAndStandardItemsOnce then
        self:Reset()
        self:BuildStandardItems()
      else
        self.SkipResetAndStandardItemsOnce = false
      end
      self:NotifyShown()
    end
    ContextMenuWindow.OnHide = function ()
      self:NotifyHidden()
    end
    CreateWindow("ContextMenu", false)
  end,
  
  Reset = function (self)
    self.MenuItems = {}
  end,
  
  AddItem = function (self, alias, tid, callback)
    local new = OpenCore.Classes.ContextMenu.LuaMenuItem:Create(
      alias, tid, callback
    )
    table.insert(self.MenuItems, new)
  end,
  
  BuildStandardItems = function (self)
    local menu = WindowData.ContextMenu
    for i, item in pairs(menu.menuItems) do
      local new = OpenCore.Classes.ContextMenu.MenuItem:Create(
        "Standard" .. item.returnCode,
        menu.objectId,
        item.tid,
        item.returnCode
      )
      table.insert(self.MenuItems, new)
    end
  end,
  
  GetMenuItems  = function (self)
    return self.MenuItems
  end,
  
  GetMenuItem = function (self, alias)
    for i, item in pairs(self:GetMenuItems()) do
      if item:GetAlias() == alias then
        return item
      end
    end
    return nil
  end,
  
  NotifyShown = function (self)
    for alias, listener in pairs(self.Listeners) do
      pcall(listener, self.EVENT_MENU_SHOW, self:GetMenuItems())
    end
  end,
  
  NotifyHidden = function (self)
    for alias, listener in pairs(self.Listeners) do
      pcall(listener, self.EVENT_MENU_HIDE, nil)
    end
  end
}

OpenCore:RegisterServiceClass("ContextMenu.ContextMenuService", "ContextMenu", ContextMenuService)