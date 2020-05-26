local LuaMenuItem = {
  Label = nil,
  Handler = nil,

  Create = function (self, alias, tid, callback)
    local item = {}
    setmetatable(item, self)
    if type(tid) == "wstring" then
      item.Label = tid  
    else 
      item.Label = GetStringFromTid(tid)
    end
    item.Alias = alias
    item.Handler = callback
    return item
  end,
  
  Execute = function (self)
    self.Handler()
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
LuaMenuItem.__index = LuaMenuItem

OpenCore:RegisterClass("ContextMenu.LuaMenuItem", LuaMenuItem)