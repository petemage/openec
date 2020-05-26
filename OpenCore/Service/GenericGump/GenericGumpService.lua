local GenericGumpService = {
  WindowNames = {
    [600] = "GUMP_MOONGATE"
  },

  Initialize = function (self)
    LoadResources( 
      OpenCore:GetServiceDir().."/GenericGump", 
      "GenericGump.xml", 
      "GenericGump.xml" 
    )
    WindowRegisterEventHandler("Root", SystemData.Events.GG_ARRIVED, "OpenCore.GenericGump.GGArrived")
    WindowRegisterEventHandler("Root", SystemData.Events.GG_CLOSE, "OpenCore.GenericGump.GGClose")
    WindowRegisterEventHandler("Root", SystemData.Events.GG_DATA_READY, "OpenCore.GenericGump.GGParseData")
  end,
  
  Shutdown = function (self)
  
  end,
  
  OnInitialize = function ()
  
  end,
  
  OnShown = function ()
    
  end,
  
  OnShutdown = function ()
    
  end,
  
  OnLabelInitialize = function ()
    
  end,
  
  OnButtonClicked = function ()
    local windowName = OpenCore:GetActiveWindow()
    local gumpId = WindowGetId(windowName)
    GenericGumpOnClicked(gumpId, windowName)
  end,
  
  GGArrived = function () 
    OpenCore:Chat("New GenericGump arrived: " .. WindowData.GG_Core.GumpId, WindowData.GG_Core)
  end,
  
  GGClose = function () 
    OpenCore:Chat("gg close")
  end,
  
  GGParseData = function () 
    if GumpData == nil then
      return
    end
    for gumpId, data in pairs(GumpData.Gumps) do
    
      local windowName = data.windowName
      OpenCore:Chat("gump: "..gumpId .. " - " .. windowName)
      
      WindowSetShowing(windowName, true)
    end
  end,
}
OpenCore:RegisterServiceClass("GenericGump.GenericGumpService", "GenericGump", GenericGumpService)