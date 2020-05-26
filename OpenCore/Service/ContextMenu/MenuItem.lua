local MenuItem = {
  Label = nil,
  Alias = nil,
  Handler = nil,
  Standard = true,
  Code = nil,
  Target = nil,

  Create = function (self, alias, target, tid, code)
    local item = {}
    setmetatable(item, self)
    item.Standard = true
    item.Alias = alias
    item.Label = GetStringFromTid(tid)
    item.Code = code
    item.Target = target
    return item
  end,
  
  Execute = function (self)
    if self:IsStandard() then
      OpenCore.ContextMenu:TriggerStandardItem(self:GetCode())
    end
  end,

  GetAlias = function (self)
    return self.Alias
  end,
  
  GetHandler = function (self)
    return self.Handler
  end,
  
  GetLabel = function (self)
    return self.Label
  end,
  
  IsStandard = function (self)
    return self.Standard == true
  end,
  
  GetCode = function (self)
    return self.Code
  end,
  
  GetTarget = function (self)
    return self.Target
  end
}
MenuItem.__index = MenuItem

OpenCore:RegisterClass("ContextMenu.MenuItem", MenuItem)