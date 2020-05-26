local DebugService = {

  Initialize = function (self)
    WindowRegisterEventHandler("Root", SystemData.Events.DEBUGPRINT_TO_CONSOLE, "OpenCore.Debug.OnDebugMessage")
  end,
  
  Shutdown = function (self)
    WindowUnregisterEventHandler("Root", SystemData.Events.DEBUGPRINT_TO_CONSOLE, "OpenCore.Debug.OnDebugMessage")
  end,
  
  OnDebugMessage = function ()
    OpenCore.Debug:Chat(DebugData.DebugString)
  end,

  Chat = function (self, ...)
    local log = "Chat"
    local filter = 0
    
    for i, message in ipairs(arg) do
      local t = type (message);
      if t == "string" then
        self:LogString("Chat", StringToWString (message))
        -- XXX: PrintWStringToChatWindow(message, SystemData.ChatLogFilters.SYSTEM )
      elseif t == "number" then
        self:LogString("Chat", StringToWString(tostring(message)))
      elseif t == "wstring" then
        self:LogString("Chat", message)
      elseif t == "table" then
        self:DumpToChat("table", message)
      elseif t == "boolean" then
        if message then
          self:LogString("Chat", L"true")
        else
          self:LogString("Chat", L"false")      
        end  
      else
        self:LogString("Chat", StringToWString("Unknown type: " .. t))
      end
    end
  end,
  
  UiLog = function (self, ...)
    for i, message in ipairs(arg) do
      local t = type (message);
      if t == "string" then
        self:LogString("UiLog", StringToWString (message))
        -- XXX: PrintWStringToChatWindow(message, SystemData.ChatLogFilters.SYSTEM )
      elseif t == "number" then
        self:LogString("UiLog", StringToWString(tostring(message)))
      elseif t == "wstring" then
        self:LogString("UiLog", message)
      elseif t == "table" then
        self:DumpToChat("table", message)
      else
        self:LogString("UiLog", StringToWString("Unknown type: " .. t))
      end
    end
  end,
  
  LogString = function (self, channel, wstring, filter)
    filter = filter or 1
    local now = StringToWString("[" .. OpenCore.DateTime:GetDateString() .. " " .. OpenCore.DateTime:GetTimeString() .. "] ")
    TextLogAddEntry (channel, filter, now .. wstring)
  end,
  
  PrintToChat = function (self, ...)
    self:Chat(...)
  end,
  
  DumpToChat = function (self, name, value, memo, depth)
    name = name or "table"
    memo = memo or {}
    depth = depth or 4
    if type(name) == "wstring" then
      name = tostring(name)
    end
    local t = type(value)
    local prefix = name.."="
    
    if t == "number" or t == "string" or t == "function" then
      self:Chat(prefix..tostring(value))
    elseif t == "nil" then
      self:Chat(prefix.."(nil)")
    elseif t == "boolean" then
      if value then
        self:Chat(prefix.."true")
      else
        self:Chat(prefix.."false")
      end
    elseif t == "wstring" then
      self:Chat(StringToWString(prefix)..value)
    elseif t == "table" then
      
      if memo[value] then
        self:Chat(prefix..tostring(memo[value]))
      else
        memo[value] = name
        
        for k, v in pairs(value) do
          local fname = name.."["..tostring(k).."]"
          if tostring(k) == "__index" then
            if v == value then
              self:Chat(fname.."=(to self)")
            else
              self:Chat(fname.."=(to other???)")          
            end
          else
            if type(v) == "table" and depth < 1 then
              self:Chat(fname.."={..}")
            else
              self:DumpToChat(fname, v, memo, depth-1)
            end
          end
        end
      end      
    else
      self:Chat("[Debug] could not serialize type: "..t)
    end
  end
}

OpenCore:RegisterServiceClass("Debug.DebugService", "Debug", DebugService)