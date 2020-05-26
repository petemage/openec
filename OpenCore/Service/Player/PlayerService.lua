local PlayerService = {

  RESIST_PHYSICAL = 0,
  RESIST_FIRE = 1,
  RESIST_COLD = 2,
  RESIST_POISION = 3,
  RESIST_ENERGY = 4,
  
  EQUIPMENT_DRAG = 0,
  EQUIPMENT_RIGHTHAND = 1, -- wielding
  EQUIPMENT_LEFTHAND = 2,  -- off hand
  EQUIPMENT_FEET = 3,      -- wearing
  EQUIPMENT_LEGS = 4,
  EQUIPMENT_TORSO = 5,     -- shirt
  EQUIPMENT_HEAD = 6,
  EQUIPMENT_HANDS = 7,
  EQUIPMENT_FINGER1 = 8,
  EQUIPMENT_TALISMAN = 9,
  EQUIPMENT_NECK = 10,
  EQUIPMENT_HAIR = 11,
  EQUIPMENT_WAIST = 12,
  EQUIPMENT_CHEST = 13,     -- breastplate
  EQUIPMENT_LWRIST = 14,
  EQUIPMENT_RWRIST = 15,
  EQUIPMENT_FACIALHAIR = 16,
  EQUIPMENT_ABOVECHEST = 17,
  EQUIPMENT_EARS = 18,
  EQUIPMENT_ARMS = 19,
  EQUIPMENT_CAPE = 20,
  EQUIPMENT_BACKPACK = 21,
  EQUIPMENT_DRESS = 22,
  EQUIPMENT_SKIRT = 23,
  EQUIPMENT_FEETLEGS = 24,
  EQUIPMENT_RIDING = 25,
  EQUIPMENT_MAX = 26,
  EQUIPMENT_SELLS = 26,
  EQUIPMENT_INVENT = 27,
  EQUIPMENT_BUYS = 28,
  EQUIPMENT_BANK = 29,
  EQUIPMENT_SHOP_MAX = 30,
  
  ABILITY_PRIMARY = 1,
  ABILITY_SECONDARY = 2,
  
  FACET_FELUCCA = 0,
  FACET_TRAMMEL = 1,
  FACET_ILSHENAR = 2,
  FACET_MALAS = 3,
  FACET_TOKUNO = 4,
  FACET_TERMUR = 5,
  
  StatusListeners = {},
  EquipmentListeners = {},
  EquipmentRegistered = {},
  
  BackpackId = 0,
  BankId = 0,

  Initialize = function (self)
    RegisterWindowData(WindowData.PlayerStatus.Type, 0)
    RegisterWindowData(WindowData.PlayerLocation.Type, 0)
    WindowRegisterEventHandler(
      "Root", 
      WindowData.PlayerStatus.Event, 
      "OpenCore.Player.OnUpdateStatus"
    )
    WindowRegisterEventHandler(
      "Root", 
      WindowData.PlayerEquipmentSlot.Event, 
      "OpenCore.Player.OnUpdateEquipment"
    )
    self:RegisterEquipmentData(self.EQUIPMENT_BACKPACK)
    self:RegisterEquipmentData(self.EQUIPMENT_BANK)
    local equipment = self:GetEquipmentData(self.EQUIPMENT_BACKPACK)
    if equipment ~= nil then
      self.BackpackId = equipment.objectId
    end
  end,
  
  Shutdown = function (self)
    UnregisterWindowData(WindowData.PlayerStatus.Type, 0)
    UnregisterWindowData(WindowData.PlayerLocation.Type, 0)
  end,
  
  RegisterEquipmentData = function (self, position)
    self.EquipmentRegistered[position] = self.EquipmentRegistered[position] or 0
    if self.EquipmentRegistered[position] == 0 then
      RegisterWindowData(WindowData.PlayerEquipmentSlot.Type, position)
      --OpenCore:Chat("-- equipment data: --", WindowData.PlayerEquipmentSlot, "---")
    end
    self.EquipmentRegistered[position] = self.EquipmentRegistered[position] + 1
    return WindowData.PlayerEquipmentSlot[position]
  end,
  
  GetEquipmentData = function (self, position)
    if self.EquipmentRegistered[position] <= 0 then
      self:RegisterEquipmentData(position)
      local data = WindowData.PlayerEquipmentSlot[position]
      self:UnregisterEquipmentData(position)
      return data
    end
    return WindowData.PlayerEquipmentSlot[position]
  end,
  
  UnregisterEquipmentData = function (self, position)
    self.EquipmentRegistered[position] = self.EquipmentRegistered[position] or 0
    if self.EquipmentRegistered[position] == 1 then
      UnregisterWindowData(WindowData.PlayerEquipmentSlot.Type, position)
      WindowData.PlayerEquipmentSlot[position] = nil
    end
    if self.EquipmentRegistered[position] > 0 then
      self.EquipmentRegistered[position] = self.EquipmentRegistered[position] - 1
    end
  end,
  
  AddEquipmentListener = function (self, alias, position, listener) 
    -- TODO self.EquipmentListeners[alias] = listener
    
    -- reigster eq data if needed
    -- register listener
  end,
  
  RemoveEquipmentListener = function (self, alias)
    --self.EquipmentListeners[alias] = nil
  end,
  
  OnUpdateEquipment = function ()
    local self = OpenCore.Player
    self.BackpackId = self:GetEquipmentData(self.EQUIPMENT_BACKPACK).objectId
    local bank = self:GetEquipmentData(self.EQUIPMENT_BANK)
    if bank then
      self.BankId = bank.objectId
    end
    
    OpenCore:Chat("equipment update: " .. self.BackpackId .. ", " .. self.BankId)
  end,
  
  AddStatusListener = function (self, alias, listener) 
    self.StatusListeners[alias] = listener
  end,
  
  RemoveStatusListener = function (self, alias)
    self.StatusListeners[alias] = nil
  end,
  
  OnUpdateStatus = function ()
    local self = OpenCore.Player
    for alias, listener in pairs(self.StatusListeners) do
      pcall(listener, self)
    end
  end,
  
  Debug = function (self)
    --OpenCore:Chat(WindowData.PlayerStatus)
    OpenCore:Chat(WindowData.PlayerLocation)
  end,
  
  -- id, position, backpack id
  GetPlayerId = function (self)
    return self:GetId()
  end,
  GetId = function (self)
    return WindowData.PlayerStatus.PlayerId
  end,
  GetPosition = function (self)
    return WindowData.PlayerLocation.x, WindowData.PlayerLocation.y, WindowData.PlayerLocation.z
  end,
  GetFacet = function (self)
    return WindowData.PlayerLocation.facet
  end,
  GetBackpackId = function (self)
    return self.BackpackId
  end,
  
  -- stats
  GetStrength = function (self)
    return WindowData.PlayerStatus.Strength
  end,
  GetDexterity = function (self)
    return WindowData.PlayerStatus.Dexterity
  end,
  GetIntelligence = function (self)
    return WindowData.PlayerStatus.Intelligence
  end,
  GetStatCap = function (self)
    return WindowData.PlayerStatus.StatCap
  end,
  
  -- gold, weight, luck, followers, dead, poisoned, cursed
  GetGold = function (self)
    return WindowData.PlayerStatus.Gold
  end,
  GetWeight = function (self)
    return WindowData.PlayerStatus.Weight
  end,
  GetMaxWeight = function (self)
    return WindowData.PlayerStatus.MaxWeight
  end,
  GetLuck = function (self)
    return WindowData.PlayerStatus.Luck
  end,
  GetFollowers = function (self)
    return WindowData.PlayerStatus.Followers
  end,
  GetMaxFollowers = function (self)
    return WindowData.PlayerStatus.MaxFollowers
  end,
  IsDead = function (self)
    return WindowData.PlayerStatus.Dead ~= 0
  end,
  IsPoisoned = function (self)
    return WindowData.PlayerStatus.VisualStateId == 1
  end,
  IsCursed = function (self)
    return WindowData.PlayerStatus.VisualStateId == 2
  end,
  
  -- race, war mode
  GetRace = function (self)
    return WindowData.PlayerStatus.Race
  end,
  IsInWarMode = function (self)
    return WindowData.PlayerStatus.InWarMode == true
  end,
  
  -- health, stamina, mana
  GetHealth = function (self)
    return WindowData.PlayerStatus.CurrentHealth
  end,
  GetMaxHealth = function (self)
    return WindowData.PlayerStatus.MaxHealth
  end,
  GetStamina = function (self)
    return WindowData.PlayerStatus.CurrentStamina
  end,
  GetMaxStamina = function (self)
    return WindowData.PlayerStatus.MaxStamina
  end,
  GetMana = function (self)
    return WindowData.PlayerStatus.CurrentMana
  end,
  GetMaxMana = function (self)
    return WindowData.PlayerStatus.MaxMana
  end,
  
  -- resists
  GetResists = function (self)
    return {
      [self.RESIST_PHYSICAL] = WindowData.PlayerStatus.PhysicalResist,
      [self.RESIST_FIRE] = WindowData.PlayerStatus.FireResist,
      [self.RESIST_COLD] = WindowData.PlayerStatus.ColdResist,
      [self.RESIST_POISION] = WindowData.PlayerStatus.PoisonResist,
      [self.RESIST_ENERGY] = WindowData.PlayerStatus.EnergyResist
    }
  end,
  GetMaxResists = function (self)
    return {
      [self.RESIST_PHYSICAL] = WindowData.PlayerStatus.MaxPhysicalResist,
      [self.RESIST_FIRE] = WindowData.PlayerStatus.MaxFireResist,
      [self.RESIST_COLD] = WindowData.PlayerStatus.MaxColdResist,
      [self.RESIST_POISION] = WindowData.PlayerStatus.MaxPoisonResist,
      [self.RESIST_ENERGY] = WindowData.PlayerStatus.MaxEnergyResist
    }
  end,
  
  ToggleWarMode = function (self)
    UserActionToggleWarMode()
  end
}

OpenCore:RegisterServiceClass("Player.PlayerService", "Player", PlayerService)