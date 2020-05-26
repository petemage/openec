local WindowService = {
  Handler = {},
  Windows = {},
  
  Initialize = function (self)
    setmetatable(self.Handler, {
      __index = function (table, index)
        --OpenCore:Chat("Accessing: "..index)
        if rawget(table, index) == nil then
          local handler = function (...)
            local name = self:GetActiveWindowName()
            local dialog = self:GetActiveDialog()
            --OpenCore:Chat("Trying to "..index.." window "..name.." - "..dialog)          
            local hook = "On"..index
            if self.Windows[dialog] ~= nil then
              local window = self.Windows[dialog]
              if window[hook] ~= nil then
                window[hook](window, name, ...)
              else
                OpenCore:Chat("Trying to call "..hook.." on window "..name.." but hook does not exist.")
              end
            else
              OpenCore:Chat("Trying to call "..hook.." on window "..name.." but the window was not registered.")
            end
          end
          --OpenCore:Chat("Setting: "..index)
          rawset(table, index, handler)
        end
        return rawget(table, index)
      end
    })
    
    UO_StandardDialog = {
      CreateDialog = function (data)
        OpenCore:Chat(data)
      end
    }
  end,
  
  Shutdown = function (self)
  
  end,
  
  WindowData = {},
  
  CreateFromTemplate = function (self, name, template, parent, data)
    if not DoesWindowExist(name) then
      self.WindowData[name] = data      
      CreateWindowFromTemplate(name, template, parent)
      --OpenCore:Chat("Creating: " .. name)
    else
      OpenCore:Chat("Window already exists: " .. name)
    end
  end,
  
  CreateFromClass = function (self, parent, class, data)
    local window = data or {}
    setmetatable(window, class)
    local name = class:OnGetWindowName(window)
    local template = class:OnGetTemplate(window)
    if not DoesWindowExist(name) then
      window.Name = name
      self.Windows[name] = window
      --OpenCore:Chat("Creating window: "..name)
      CreateWindowFromTemplate(name, template, parent)
    else
      OpenCore:Chat("Window already exists: " .. name)
    end
    return self.Windows[name]
  end,
  
  RegisterWindowData = function (self, type, id)
    RegisterWindowData(type, id)
  end,
  
  UnregisterWindowData = function (self, type, id)
    UnregisterWindowData(type, id)
  end,
  
  GetWindowData = function (self, window)
    window = window or self:GetActiveDialog()
    return self.WindowData[window]
  end,
  
  GetActiveWindowName = function (self)
    return SystemData.ActiveWindow.name
  end,
  
  GetActiveDialog = function (self)
    return self:GetTopmostDialog(SystemData.ActiveWindow.name)
  end,
  
  GetTopmostDialog = function (self, window)
    local current = window
    local dialog = current
    if current == "Root" then
      return dialog
    end
    repeat
      dialog = current
      current = WindowGetParent(current)
    until (current == nil or current == "Root") 
    return dialog
  end,
  
  Close = function (self, window)
    DestroyWindow(window)
  end,
  
  SavePosition = function (self, window)
    window = window or self:GetActiveDialog()
    local x, y = WindowGetScreenPosition(window)
    local scale = OpenCore.Client:GetScale()
    x = x / scale
    y = y / scale
    local width, height = WindowGetDimensions(window)
    local windowPositions = SystemData.Settings.Interface.WindowPositions
    local position = nil
    for i, name in pairs(windowPositions.Names) do
      if window == name then
        position = i
        break
      end
    end
    if position == nil then
      position = table.getn(windowPositions.Names) + 1
      windowPositions.Names[position] = window
    end
    windowPositions.WindowPosX[position] = x
    windowPositions.WindowPosY[position] = y
    windowPositions.WindowWidth[position] = width
    windowPositions.WindowHeight[position] = height
  end,
  
  RestorePosition = function (self, window)
    window = window or self:GetActiveDialog()
    local windowPositions = SystemData.Settings.Interface.WindowPositions
    local position = nil
    for i, name in pairs(windowPositions.Names) do
      if window == name then
        position = i
        break
      end
    end
    if position ~= nil then
      local x = windowPositions.WindowPosX[position]
      local y = windowPositions.WindowPosY[position]
      local width = windowPositions.WindowWidth[position]
      local height = windowPositions.WindowHeight[position]
      if x ~= nil and y ~= nil then      
        WindowClearAnchors(window)
        WindowAddAnchor(window, "topleft", "Root", "topleft", x, y) 
      end
      if width ~= nil and height ~= nil then
        WindowSetDimensions(window, width, height)
      end      
    end
  end,
  
  SetMoving = function (self, window, moving)
    WindowSetMoving(window, moving)
  end
}

OpenCore:RegisterServiceClass("Window.WindowService", "Window", WindowService)