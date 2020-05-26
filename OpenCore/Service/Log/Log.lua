local Log = {
  Created = false,
  
  Create = function (self, name, filename)
    local log = {}
    setmetatable(log, self)
    log.Name = name
    log.Filename = filename
    log.Created = false
    return log
  end,
  
  CreateLog = function (self, clear)
    if self.Created then
      return
    end
    clear = clear or 0
    TextLogCreate(self.Name, 1)
    self:SetEnabled(true)
    if clear then
      self:Clear()  
    end
    TextLogSetIncrementalSaving(self.Name, true, self.Filename)
    self.Created = true
  end,
  
  SetEnabled = function (self, enabled)
    TextLogSetEnabled(self.Name, enabled)
  end,
  
  Clear = function (self)
    TextLogClear(self.Name)
  end
}
Log.__index = Log
OpenCore:RegisterClass("Log.Log", Log)