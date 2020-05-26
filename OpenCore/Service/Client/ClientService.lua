local ClientService = {
  
  Quit = function (self)
    BroadcastEvent (SystemData.Events.EXIT_GAME)
  end,
  
  Logout = function (self)
    BroadcastEvent (SystemData.Events.LOG_OUT)
  end,
  
  GetScreenResolution = function (self)
    local r = SystemData.screenResolution
    return r.x, r.y
  end,
  
  GetScale = function (self)
    return InterfaceCore.scale
  end,
  
  GetMousePosition = function (self)
    local p = SystemData.MousePosition
    return p.x, p.y
  end
}

OpenCore:RegisterServiceClass("Client.ClientService", "Client", ClientService)
