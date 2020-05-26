local SkillService = {
  MAX_SKILLS = 57,
  
  STATE_UP = 0,
  STATE_DOWN = 1,
  STATE_LOCK = 2,
  
  SKILL_ALCHEMY = 1,
  
  SkillTitles = {},
  
  tab1 = { 7,  22, 28, 53 },
  tab2 = { 2, 5, 18, 21, 23, 31, 40, 50, 51, 58, 54 },
  tab3 = { 1, 6, 8, 11, 12, 14, 20, 27, 30, 35, 52, 55 },
  tab4 = { 9, 13, 17, 32, 33, 34, 38, 39, 46, 47, 37, 26 },
  tab5 = { 3, 4, 10, 19, 24, 56, 57 },
  tab6 = { 15, 25, 29, 42, 44, 45, 48, 49 },
  tab7 = { 16, 36, 41, 43 },

  Initialize = function (self)
    self.tabs = { 
      self.tab1, 
      self.tab2, 
      self.tab3, 
      self.tab4, 
      self.tab5, 
      self.tab6, 
      self.tab7 
    }
    
    self.SkillTitles = {
      [3] = GetStringFromTid(1077474),
      [4] = GetStringFromTid(1077475),
      [5] = GetStringFromTid(1077476),
      [6] = GetStringFromTid(1077477),
      [7] = GetStringFromTid(1077478),
      [8] = GetStringFromTid(1077479),
      [9] = GetStringFromTid(1077480),
      [10] = GetStringFromTid(1079309),
      [11] = GetStringFromTid(1079272),
      [12] = GetStringFromTid(1079273),
    }
  
    UOBuildTableFromCSV ("data/gamedata/skilldata.csv","SkillsCSV")
    self.OnToggleSkillsTrackerWrap = function ()
      self:OnToggleSkillsTracker()
    end
    WindowRegisterEventHandler("Root", SystemData.Events.TOGGLE_SKILLS_TRACKER_WINDOW, "OpenCore.Skills.OnToggleSkillsTrackerWrap")
    for i=0, self.MAX_SKILLS do  
      RegisterWindowData(WindowData.SkillDynamicData.Type, i)
    end
    RegisterWindowData(WindowData.SkillList.Type,0)
    self.OnSkillEventWrap = function ()
      self:OnSkillEvent()
    end
    WindowRegisterEventHandler("Root", WindowData.SkillDynamicData.Event, "OpenCore.Skills.OnSkillEventWrap")
  end,
  
  Shutdown = function (self)
    for i=0, self.MAX_SKILLS do  
      UnregisterWindowData(WindowData.SkillDynamicData.Type, i)
    end
    UnregisterWindowData(WindowData.SkillList.Type,0)
  end,
  
  OnToggleSkillsTracker = function (self)
    OpenCore:Chat("Toggle skills tracker")
  end,
  
  OnSkillEvent = function (self)
    OpenCore:Chat("skill event")
  end,
  
  GetRealSkill = function (self, skill)
    return WindowData.SkillDynamicData[skill].RealSkillValue
  end,
  
  GetTempSkill = function (self, skill)
    return WindowData.SkillDynamicData[skill].TempSkillValue
  end,
  
  GetCap = function (self, skill)
    return WindowData.SkillDynamicData[skill].SkillCap
  end,
  
  GetState = function (self, skill)
    return WindowData.SkillDynamicData[skill].SkillState
  end,
  
  SetState = function (self, skill, state)
    OpenCore:Chat("skill " .. skill .. " to state " .. state)
    ReturnWindowData.SkillSystem.SkillId = WindowData.SkillsCSV[skill].ServerId
    ReturnWindowData.SkillSystem.SkillButtonState = state
    BroadcastEvent(SystemData.Events.SKILLS_ACTION_SKILL_STATE_CHANGE)
  end,
  
  GetLevelFromValue = function (self, value)
    local level = math.floor(value / 100)
    if level > 12 then
      level = 12
    end
    return level
  end,
  
  GetTitleFromValue = function (self, value)
    local level = self:GetLevelFromValue(value)
    if level < 2 then
      return ""
    end
    return WStringToString(self.SkillTitles[level] or L"")
  end,
  
  GetName = function (self, skill)
    if WindowData.SkillsCSV[skill] then
      return WStringToString(WindowData.SkillsCSV[skill].SkillName or L"")
    else
      OpenCore:Chat("No skill data for skill: " .. skill)
    end
    return ""
  end,
  
  GetIconId = function (self, skill)
    return WindowData.SkillsCSV[skill].IconId
  end,
  
  UseSkill = function (skill)
    UserActionUseSkill(skill)
  end,
  
  Debug = function (self)
    for skill=0, self.MAX_SKILLS do  
      local real = self:GetRealSkill(skill)
      if real > 0 then
        local state = self:GetState(skill)
        local s = "locked"
        if state == self.STATE_UP then
          s = "up"
        elseif state == self.STATE_DOWN then
          s = "down"
        end
        OpenCore:Chat(self:GetName(skill) .. "(" .. skill .. "): ".. self:GetTitleFromValue(real) .. " - " .. real .. "(" .. s .. ")")
      end
    end
  end
}
OpenCore:RegisterServiceClass("Skills.SkillService", "Skills", SkillService)