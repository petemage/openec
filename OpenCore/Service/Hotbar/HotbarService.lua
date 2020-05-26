local HotbarService = {
  Hotbars = {},

  ContextReturnCodes = {
    CLEAR_ITEM = 1,
    ASSIGN_KEY = 2,
    NEW_HOTBAR = 3,
    DESTROY_HOTBAR = 4,
    TARGET_SELF = 5,
    TARGET_CURRENT = 6,
    TARGET_CURSOR = 7,
    TARGET_OBJECT_ID = 8,
    EDIT_ITEM = 9,
    ENABLE_REPEAT = 10,
    DISABLE_REPEAT = 11,
    LOCK_HOTBAR = 12
  },
  
  TID = {
    CLEAR_ITEM = 1077858,
    ASSIGN_HOTKEY = 1078019,
    NEW_HOTBAR = 1078020,
    DESTROY_HOTBAR = 1078026,
    DESTROY_CONFIRM = 1078027,
    CURSOR = 1078071,
    SELF = 1078072,
    CURRENT = 1078073,
    OBJECT_ID = 1094772,
    TARGET = 1078074,
    EDIT_ITEM = 1078196,
    ENABLE_REPEAT = 1079431,
    DISABLE_REPEAT = 1079433,
    LOCK_HOTBAR = 1115431,
    UNLOCK_HOTBAR = 1115432,
  },

  Initialize = function (self)
    --OpenCore:Chat(SystemData.Hotbar)
  end,
  
  Shutdown = function (self)
  
  end,
  
  CreateHotbar = function (self, start)
    start = start or 1
    local id = self:GetNextHotbarIdFrom(start)
    if id ~= nil then
      HotbarRegisterNew(id)
    end
  end,
  
  DestroyHotbar = function (self, id)
    --for i=1,12 do
    --  HotbarSystem.UnbindKey(hotbarId, i, SystemData.BindType.BINDTYPE_HOTBAR)
    --end
    HotbarUnregister(id)
  end,
  
  Get = function (self, id, start)
    start = start or 1
    id = id or self:GetNextHotbarIdFrom(start)
    if self.Hotbars[id] == nil then
      local hotbar = OpenCore.Classes.Hotbar.Hotbar:Create(id)
      self.Hotbars[id] = hotbar
    end
    return self.Hotbars[id]
  end,
  
  GetIds = function (self)
    return SystemData.Hotbar.HotbarIds
  end,
  
  GetCount = function (self)
    return table.getn(self:GetIds())
  end,
  
  Has = function (self, id)
    for index, hotbarId in pairs(self:GetIds()) do
      if hotbarId == id then
        return true
      end
    end
    return false
  end,
  
  GetNextHotbarIdFrom = function (self, start)
    local newHotbarId = start
    while newHotbarId ~= 2000 and self:Has(newHotbarId) do
      newHotbarId = newHotbarId + 1
    end
    return newHotbarId
  end
}

OpenCore:RegisterServiceClass("Hotbar.HotbarService", "Hotbar", HotbarService)