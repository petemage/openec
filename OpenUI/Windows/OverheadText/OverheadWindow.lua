local OverheadWindow = {

  NameColors = {
    [0] = { r=225, g=225, b=225 }, --- GREY/SYS
    [1] = { r=140, g=198, b=242 }, --- BLUE
    [2] = { r=0 ,  g=180, b=0 },   --- GREEN 
    [3] = { r=225, g=225, b=225 }, --- GREY/SYS
    [4] = { r=225, g=225, b=225 }, --- GREY/SYS
    [5] = { r=242, g=159, b=77 },  --- ORANGE
    [6] = { r=255, g=64,  b=64 },  --- RED  
    [7] = { r=223, g=223, b=32 }   --- YELLOW
  },

  OnInitialize = function ()
    
  end,
  
  OnShutdown = function ()
    
  end,
  
  OnShown = function ()
  
  end
}

OpenUI.OverheadWindow = OverheadWindow