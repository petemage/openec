local StaticTextService = {

  Initialize = function (self)
    WindowRegisterEventHandler("Root", SystemData.Events.STATIC_TEXT_CREATE, "OpenCore.StaticText.OnCreate")
    WindowRegisterEventHandler("Root", SystemData.Events.STATIC_TEXT_DESTROY_ALL, "OpenCore.StaticText.OnDestroyAll")
    
  end,
  
  Shutdown = function (self)
  
  end,
  
  OnCreate = function ()
    local self = OpenCore.StaticText
    OpenCore.Debug:PrintToChat(self:GetText())
  end,
  
  OnDestroyAll = function (self)
  
  end,
  
  GetText = function (self) 
    local offset = 0
    if (WindowData.StaticTextWindow.ObjectType < 16384) then
      offset = 1020000
    elseif (WindowData.StaticTextWindow.ObjectType < 32768) then
      offset = 1095256 - 16384
    elseif (WindowData.StaticTextWindow.ObjectType < 65536) then
      offset = 1116792 - 32768
    end
    local tid = WindowData.StaticTextWindow.ObjectType + offset
    local name = GetStringFromTid(tid)
    
    return name
  end
}

OpenCoreRegisterService("StaticText", StaticTextService)