local MainMenuItem = {
  Create = function (self, alias, label, handler)
    local item = {}
    setmetatable(item, self)
    item.Alias = alias
    item.Label = label
    item.Handler = handler
    return item
  end,

  GetAlias = function (self)
    return self.Alias
  end,
  
  GetHandler = function (self)
    return self.Handler
  end,
  
  GetLabel = function (self)
    return self.Label
  end
}
MainMenuItem.__index = MainMenuItem

OpenCore:RegisterClass("MainMenu.MenuItem", MainMenuItem)