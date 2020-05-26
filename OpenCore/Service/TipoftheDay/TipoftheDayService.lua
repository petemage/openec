local TipoftheDayService = {
  Initialize = function (self)
    UOBuildTableFromCSV("Data/GameData/tipoftheday.csv", "TipoftheDayCSV")
  end,
  
  Shutdown = function (self)
  
  end,
  
  GetTotalTips = function (self)
    return table.getn(WindowData.TipoftheDayCSV)
  end,
  
  GetTip = function (self, index)
    return WStringToString(GetStringFromTid(WindowData.TipoftheDayCSV[index].TipTID))
  end,
  
  GetRandomTip = function (self)
    local index = GetRandomNumber(self:GetTotalTips()) + 1
    return self:GetTip(index), index
  end
}
OpenCore:RegisterServiceClass("TipoftheDay.TipoftheDayService", "TipoftheDay", TipoftheDayService)