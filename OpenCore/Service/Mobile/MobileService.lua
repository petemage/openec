local MobileService = {

  EVENT_BEGIN_HEALTHBAR = 0,
  EVENT_END_HEALTHBAR = 1,

  NOTORIETY_NONE = 1, 
  NOTORIETY_INNOCENT = 2,
  NOTORIETY_FRIEND = 3,
  NOTORIETY_CANATTACK = 4,
  NOTORIETY_CRIMINAL = 5, 
  NOTORIETY_ENEMY = 6, 
  NOTORIETY_MURDERER = 7, 
  NOTORIETY_INVULNERABLE = 8,

  DamageListener = {},
  HealthBarListener = {},
  Mobiles = {},

  Initialize = function (self)
    self.OnDamageWrap = function ()
      self:OnDamage()
    end
    WindowRegisterEventHandler("Root", SystemData.Events.DAMAGE_NUMBER_INIT, "OpenCore.Mobile.OnDamageWrap")
    
    self.OnBeginHealthBarWrap = function ()
      self:OnBeginHealthBar()
    end
    self.OnEndHealthBarWrap = function ()
      self:OnEndHealthBar()
    end
    WindowRegisterEventHandler( "Root", SystemData.Events.BEGIN_DRAG_HEALTHBAR_WINDOW, "OpenCore.Mobile.OnBeginHealthBarWrap")
    WindowRegisterEventHandler( "Root", SystemData.Events.END_DRAG_HEALTHBAR_WINDOW, "OpenCore.Mobile.OnEndHealthBarWrap")
  end,
  
  Shutdown = function (self)
    WindowUnregisterEventHandler("Root", SystemData.Events.DAMAGE_NUMBER_INIT, "OpenCore.Mobile.OnDamageWrap")
  end,
  
  OnBeginHealthBar = function (self)
    local mobileId = SystemData.ActiveMobile.Id
    for alias, listener in pairs(self.DamageListener) do
      pcall(listener, self.EVENT_BEGIN_HEALTHBAR, mobileId)
    end
  end,
  
  OnEndHealthBar = function(self)
    for alias, listener in pairs(self.DamageListener) do
      pcall(listener, self.EVENT_END_HEALTHBAR)
    end
  end,
  
  AddHealthBarListener = function (self, alias, listener) 
    self.HealthBarListener[alias] = listener
  end,
  
  RemoveHealthBarListener = function (self, alias)
    self.HealthBarListener[alias] = nil
  end, 
  
  OnDamage = function (self)
    for alias, listener in pairs(self.DamageListener) do
      pcall(listener, Damage.mobileId, Damage.damageNumber)
    end
  end,

  AddDamageListener = function (self, alias, listener) 
    self.DamageListener[alias] = listener
  end,
  
  RemoveDamageListener = function (self, alias)
    self.DamageListener[alias] = nil
  end, 
  
  GetMobile = function (self, id)
    if self.Mobiles[id] == nil then
      local m = OpenCore.Classes.Mobile.Mobile:Create(id)
      self.Mobiles[id] = m
    end
    return self.Mobiles[id]
  end
}
OpenCore:RegisterServiceClass("Mobile.MobileService", "Mobile", MobileService)