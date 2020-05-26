local Hotbar = {
  Create = function (self, id)
    local hotbar = {}
    setmetatable(hotbar, self)
    hotbar.Id = id
    return hotbar
  end,
  
  GetId = function (self)
    return self.Id
  end,
  
  IsCreated = function (self)
    return SystemData.Hotbar[self.Id] ~= nil
  end,
  
  GetData = function (self)
    return SystemData.Hotbar[self.Id]
  end,
  
  HasItem = function (self, index)
    return HotbarHasItem(self.Id, index)
  end,
  
  IsLocked = function (self)
    return SystemData.Hotbar[self.Id].Locked
  end,
  
  GetItem = function (self, index, subIndex)
    subIndex = subIndex or 0
    local type = UserActionGetType(self.Id, index, subIndex)
    return {
      type = type,
      id = UserActionGetId(self.Id, index, subIndex),
      iconId = UserActionGetIconId(self.Id, index, subIndex),
      disabled = not UserActionIsTargetModeCompat(self.Id, index, subIndex),
      isSpell = type == SystemData.UserAction.TYPE_SPELL,
      isUseItem = type == SystemData.UserAction.TYPE_USE_ITEM,
      isUseType = type == SystemData.UserAction.TYPE_USE_OBJECTTYPE,
      isWeaponAbility = type == SystemData.UserAction.TYPE_WEAPON_ABILITY,
      isMacroReference = type == SystemData.UserAction.TYPE_MACRO_REFERENCE,
      hasTargetType = UserActionHasTargetType(self.Id ,index, subIndex),
      targetType = UserActionGetTargetType(self.Id ,index, subIndex)
    }
  end,
  
  Execute = function (self, index)
    if self:HasItem(index) then
      HotbarExecuteItem(self.Id, index)
    end
  end,
  
  Destroy = function (self)
    --for i=1,12 do
    --  HotbarSystem.UnbindKey(hotbarId, i, SystemData.BindType.BINDTYPE_HOTBAR)
    --end
    HotbarUnregister(self.Id)
  end
}
Hotbar.__index = Hotbar
OpenCore:RegisterClass("Hotbar.Hotbar", Hotbar)