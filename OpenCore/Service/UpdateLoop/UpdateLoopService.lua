local UpdateLoopService = {
  LOOP_ALWAYS = 1,
  LOOP_250MS = 2,
  LOOP_1000MS = 3,
  LOOP_3000MS = 4,
  
  loops = {},

  CreateLoop = function (self, ...)
    return self.UpdateLoop.Create(...)
  end,

  AddLoop = function (self, id, loop)
    self.loops[id] = loop
  end,
  
  RemoveLoop = function (self, id)
    self.loops[id] = nil
  end,
  
  GetLoop = function (self, id)
    return self.loops[id]
  end,
  
  OnUpdate = function (self, timePassed)
    for id, loop in pairs(self.loops) do
      loop:Execute (timePassed)
    end
  end
}
OpenCore:RegisterServiceClass("UpdateLoop.UpdateLoopService", "UpdateLoop", UpdateLoopService)