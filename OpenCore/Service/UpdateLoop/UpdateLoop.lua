local UpdateLoop = {
  interval = 10000,
  deltaTime = 0,
  callbacks = {},
  
  Create = function (interval)
    local loop = {}
    setmetatable(loop, UpdateLoop)
    loop.interval = interval
    loop.callbacks = {}
    loop.deltaTime = 0
    return loop
  end,
  
  AddCallback = function (self, alias, cb) 
    self.callbacks[alias] = cb
  end,
  
  RemoveCallback = function (self, alias)
    self.callbacks[alias] = nil
  end,
  
  Execute = function (self, timePassed) 
    if (self.deltaTime + timePassed * 1000 > self.interval) then 
      for alias, callback in pairs (self.callbacks) do
        callback (self)
      end
      self.deltaTime = 0
    else
      self.deltaTime = self.deltaTime + timePassed * 1000
    end
  end
}
UpdateLoop.__index = UpdateLoop
OpenCore:RegisterClass("UpdateLoop.UpdateLoop", UpdateLoop)