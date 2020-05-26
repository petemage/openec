local Window = {
  Name = nil,
  
  GetName = function (self)
    return self.Name
  end,
  
  GetId = function (self)
    return WindowGetId(self.Name)
  end,
  
  RegisterEventHandler = function (event, handler)
  
  end,
  
  UnregisterEventHandler = function (event, handler)
  
  end
  
  
}
--OpenCore.Classes.Window.Window = OpenCore:DefineClass(Window)