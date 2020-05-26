local DateTimeService = {
  GetDateString = function (self) 
    local timestamp, YYYY, MM, DD, h, m, s = GetCurrentDateTime()
    MM = MM + 1
    YYYY = 1900 + YYYY
    if MM < 10 then
      MM = "0"..MM
    end
    if DD < 10 then
      DD = "0"..DD
    end
    return MM.."-"..DD.."-"..YYYY
  end,
    
  GetTimeString = function (self)
    local timestamp, YYYY, MM, DD, h, m, s = GetCurrentDateTime()
    if h < 10 then
      h = "0"..h
    end
    if m < 10 then
      m = "0"..m
    end
    if s < 10 then
      s = "0"..s
    end
    return h..":"..m..":"..s
  end
}

OpenCore:RegisterServiceClass("DateTime.DateTimeService", "DateTime", DateTimeService)