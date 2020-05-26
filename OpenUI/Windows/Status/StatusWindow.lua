local StatusWindow = {
  OnGetWindowName = function (self)
    return "OpenUI.StatusWindow."..OpenCore.Player:GetId()
  end,
  
  OnGetTemplate = function (self)
    return "OpenUI.StatusWindow"
  end,
  
  OnInitialize = function (self)
    OpenCore.Window:RestorePosition()
    local player = OpenCore.Player
    local paperdoll = OpenCore.Paperdoll:Get(player:GetId())
    local texture = paperdoll:GetTextureName()
    local textureData = paperdoll:GetTextureData() 
    local x, y, scale
    if textureData.IsLegacy == 1 then
      x, y = -88, 10
      scale = 1.75
    else
      x, y = -11, -191
      scale = 0.75
    end
    WindowSetTintColor(self.Name..".PortraitBackground", 0, 0, 0)
    CircleImageSetTexture(self.Name..".Portrait", texture, x - textureData.xOffset, y - textureData.yOffset)
    --CircleImageSetTextureScale(self.Name..".Portrait", OpenCore:GetScale() * scale)
    
    player:AddStatusListener(self.Name, function ()
      self:UpdateStatus()
    end)
    self:UpdateStatus()
  end,
  
  OnShutdown = function (self)
    OpenCore.Window:SavePosition()
    OpenCore.Player:RemoveStatusListener(self.Name, function ()
      self:UpdateStatus()
    end)
  end,
  
  UpdateStatus = function (self)
    local player = OpenCore.Player
    StatusBarSetMaximumValue(self.Name..".HealthBar", player:GetMaxHealth())
    StatusBarSetCurrentValue(self.Name..".HealthBar", player:GetHealth())
    
    StatusBarSetMaximumValue(self.Name..".ManaBar", player:GetMaxMana())
    StatusBarSetCurrentValue(self.Name..".ManaBar", player:GetMana())
    
    StatusBarSetMaximumValue(self.Name..".StaminaBar", player:GetMaxStamina())
    StatusBarSetCurrentValue(self.Name..".StaminaBar", player:GetStamina())
    
    if player:IsPoisoned() then
      WindowSetTintColor(self.Name..".HealthBar", 0, 255, 0)
    elseif player:IsCursed() then
      WindowSetTintColor(self.Name..".HealthBar", 255, 255, 0)
    else
      WindowSetTintColor(self.Name..".HealthBar", 255, 0, 0)
    end
  end
  
}
StatusWindow.__index = StatusWindow
OpenUI.StatusWindow = StatusWindow