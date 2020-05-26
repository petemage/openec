local Spellbook = {
  Id = nil,
  
  Types = {
    -- Magery
    [1] = {
      label = GetStringFromTid(1002106),
      texture = { RequestGumpArt(2219) } 
    },
    -- Necromancy
    [101] = {
      label = GetStringFromTid(1061677),
      texture = { RequestGumpArt(11008) }
    },
    -- Chivalry
    [201] = {
      tid = 1061666,
      texture = 11009
    },
    -- Bushido
    [401] = {
      tid = 1070814,
      texture = 11015
    },
    -- TODO
    [501] = {
      tid = 1002106
    },
    [1001] = {
      tid = 1002106
    },
    [678] = {
      tid = 1002106
    },
    [701] = {
      tid = 1002106
    }
  },
  
  Create = function (self, id)
    local sb = {}
    setmetatable(sb, self)
    sb.Id = id
    return sb
  end,
  
  GetId = function(self)
    return self.Id
  end,
  
  Load = function (self)
    OpenCore.Window:RegisterWindowData(WindowData.Spellbook.Type, self.Id)
  end,
  
  Unload = function (self)
    OpenCore.Window:UnregisterWindowData(WindowData.Spellbook.Type, self.Id)
  end,
  
  GetData = function (self)
    return WindowData.Spellbook[self.Id]
  end,
  
  GetSpellCount = function (self)
    return table.getn(WindowData.Spellbook[self.Id].spells)
  end,
  
  GetFirstSpellNum = function (self)
    return WindowData.Spellbook[self.Id].firstSpellNum
  end,
  
  GetObjectType = function (self)
    return WindowData.Spellbook[self.Id].objType
  end,
  
  GetSpell = function (self, position)
    local abilityId = self:GetFirstSpellNum() + position - 1
    local icon, serverId, tid
    local icon, serverId, tid, desctid, reagents, powerword, tithingcost, minskill, manacost = GetAbilityData(abilityId)
    return {
      id = abilityId,
      position = position,
      icon = icon,
      serverId = serverId,
      tid = tid,
      desctid = desctid,
      description = GetStringFromTid(desctid),
      powerword = powerword,
      minskill = minskill,
      manacost = manacost,
      reagents = reagents,
      tithingcost = tithingcost,
      label = GetStringFromTid(tid),
      enabled = WindowData.Spellbook[self.Id].spells[position] == 1
    }
  end,
  
  GetType = function (self)
    return self.Types[self:GetFirstSpellNum()]
  end
}
Spellbook.__index = Spellbook
OpenCore:RegisterClass("Spellbook.Spellbook", Spellbook)