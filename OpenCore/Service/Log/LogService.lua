local LogService = {
  FILTER_SYSTEM = 1,
  FILTER_ERROR = 3,
  FILTER_DEBUG = 4,
  FILTER_FUNCTION = 5,
  FILTER_WARNING = 2,

  Logs = {},

  Initialize = function (self)
    
    self.OnTextArrivedWrap = function ()
      self:OnTextArrived()
    end
    WindowRegisterEventHandler("Root", SystemData.Events.TEXT_ARRIVED, "OpenCore.Logging.OnTextArrivedWrap")
  end,
  
  Shutdown = function (self)
  
  end,
  
  OnTextArrived = function (self)
    OpenCore:Chat("text arrived")
  end,
  
  GetLog = function (self, name)
    if self.Logs[name] == nil then
      local log = OpenCore.Classes.Log.Log:Create(name)
      self.Logs[name] = log
    end
    return self.Logs[name]
  end
}
OpenCore:RegisterServiceClass("Log.LogService", "Logging", LogService)