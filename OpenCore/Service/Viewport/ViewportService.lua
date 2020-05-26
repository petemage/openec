OpenCore:RegisterServiceClass("Viewport.ViewportService", "Viewport", {
  Initialize = function (self)
    WindowRegisterEventHandler("Root", SystemData.Events.VIEWPORT_CHANGED, "OpenCore.Viewport.OnViewportChanged" )
  end,
  
  Shutdown = function (self)
    WindowUnregisterEventHandler("Root", SystemData.Events.VIEWPORT_CHANGED, "OpenCore.Viewport.OnViewportChanged" )
  end,
  
  OnViewportChanged = function ()
    self = OpenCore.Viewport
  end,
  
  UpdatePosition = function (self, x, y, width, height)
    UpdateViewport(width, height, x, y)
  end,
  
  SetFullscreen = function (self)
    self:UpdatePosition(0, 0, 1, 1)
  end,
  
  IsEnabled = function (self)
    return SystemData.Settings.Resolution.viewportEnabled == true
  end,
  
  GetPosition = function (self)
    local p = SystemData.Settings.Resolution.viewportPos
    return p.x, p.y
  end,
  
  GetSize = function (self)
    local s = SystemData.Settings.Resolution.viewportSize
    return s.x, s.y
  end
})
