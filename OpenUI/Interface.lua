--
-- OpenEC root UI lifecycle methods
--
-- The functions here are called by UOSA on booting, updating and shutting down the UI.
-- They are the very entry points into the lua UI code and responsible to delegate
-- further into the lua UI layer.
--

-- TODO: remove
ModuleSetEnabled("UO_ChatWindow", true)

function Interface.CreatePlayWindowSet()
  OpenCore:Initialize()
  OpenCore:PrintBanner()
  
  OpenCore.MainMenu:AddMenuItem("DebugWindow", "Debug Window", function () 
    --WindowSetShowing("DebugWindow", true)
    OpenCore.Window:CreateFromClass("Root", OpenUI.DebugWindow, {})
  end)
  
  OpenCore.MainMenu:AddMenuItem("War", "War", function () 
    OpenCore.Player:ToggleWarMode()
  end)
  
  OpenCore.ContextMenu:AddListener("test", function (event, data) 
    if event == OpenCore.ContextMenu.EVENT_MENU_SHOW then
      CreateWindow("OpenUI.ContextMenuWindow", true)
    else
      if DoesWindowExist("OpenUI.ContextMenuWindow") then
        DestroyWindow("OpenUI.ContextMenuWindow")
      end
    end
  end)
  
  
  OpenCore.MainMenu:AddMenuItem("Exit", "Exit Game", function () 
    OpenCore.Client:Quit() 
  end)
  OpenCore.MainMenu:AddMenuItem("Logout", "Logout", function () 
    OpenCore.Client:Logout() 
  end)
  OpenCore.MainMenu:AddListener("test", function (event) 
    if event == OpenCore.MainMenu.EVENT_MENU_SHOW then
      CreateWindow("OpenUI.MainMenuWindow", true)  
    else
      DestroyWindow("OpenUI.MainMenuWindow")
    end
  end)
  
  OpenCore.OverheadText:AddChatListener("test", function (source, text) 
    OpenCore:Chat(text) 
  end)
  OpenCore.OverheadText:AddNameListener("est", function (mobile, name, data) 
    local windowName = "OpenUI.Windows.OverheadText." .. mobile
    LabelSetText(windowName..".Label", name)
    local textColor = OpenUI.OverheadWindow.NameColors[data.Notoriety]
    if textColor then
      LabelSetTextColor(windowName..".Label", textColor.r, textColor.g, textColor.b)
    end
  end)
  OpenCore.OverheadText:AddWindowListener("test", function (service, event, mobile, data)
    local windowName = "OpenUI.Windows.OverheadText." .. mobile
    
    if event == OpenCore.OverheadText.EVENT_WINDOW_INITIALIZE then
      if not DoesWindowExist(windowName) then
        CreateWindowFromTemplate(windowName, "OpenUI.OverheadWindow", "Root")
      end
      AttachWindowToWorldObject(mobile, windowName)
      if data.MobName and data.MobName ~= L"" then
        local name = data.MobName
        LabelSetText(windowName..".Label", name)
        --local x, y = LabelGetTextDimensions(windowName..".Label")
        --WindowSetDimensions(windowName, x, y)
        local textColor = OpenUI.OverheadWindow.NameColors[data.Notoriety]
        if textColor then
          LabelSetTextColor(windowName..".Label", textColor.r, textColor.g, textColor.b)
        end
      end    
    else
      if DoesWindowExist(windowName) then
        DestroyWindow(windowName)
      end
    end
  end)
  
  --OpenCore.Hotbar:DestroyHotbar(1000)
  --OpenCore.Hotbar:DestroyHotbar(1001)
  for i, id in pairs(OpenCore.Hotbar:GetIds()) do
    OpenCore.Window:CreateFromClass("Root", OpenUI.HotbarWindow, {
      HotbarId = id
    })
  end
  
  OpenCore.Container:AddWindowListener("test", function (service, event, container)
    OpenCore:Chat("new container: " .. container:GetId() .. " - " .. container:GetName())
    
    local windowName = "OpenUI.ContainerWindow." .. container:GetId()
    OpenCore.Window:CreateFromTemplate(windowName, "OpenUI.ContainerWindow", "Root", {
      Container = container
    })

  end)
  
  OpenCore.Targeting:AddListener("test", function (target, t)
    if t == OpenCore.Targeting.TYPE_OBJECT then
      OpenCore:Chat("targeting object: " .. target:GetName())
      --OpenCore:Chat(target:GetData())
      --OpenCore.Object:Debug()
    else
      OpenCore:Chat("targeting " .. t .. ": " .. target:GetName())
      --OpenCore:Chat(target:GetData())
    end
    
  end)
  
  OpenCore.Shop:AddListener("test", function(event, shop, merchant, container)
    if event == shop.EVENT_SHOW then
    
      
      OpenCore.Window:CreateFromClass("Root", OpenUI.ShopWindow, {
        Container = container
      })
    
    
      --OpenCore:Chat("shop container: " .. container:GetId() .. " - " .. container:GetName() .. " - " .. container:GetItemCount() .. " items")
      OpenCore:Chat("gold available: " .. OpenCore.Player:GetGold())
      for i, item in pairs(container:GetItems()) do
        local object = OpenCore.Object:GetObject(item.objectId, true)
        --OpenCore:Chat("" .. item.gridIndex .. ". ".. object:GetShopQuantity() .. "x " .. object:GetName() .. " (" .. object:GetShopValue() .. "gp - " .. object:GetId() .. ")")
        
      end
    else
      --OpenCore.Container:RemoveUpdateListener(container:GetId())
      OpenCore:Chat("close shop " .. shop:GetId())
    end
  end)
  
  --OpenCore.Skills:SetState(OpenCore.Skills.SKILL_ALCHEMY, OpenCore.Skills.STATE_LOCK)
  --local serverId = WindowData.SkillsCSV[1].ServerId
  --ReturnWindowData.SkillSystem.SkillId = serverId
  --ReturnWindowData.SkillSystem.SkillButtonState = 2
  --BroadcastEvent(SystemData.Events.SKILLS_ACTION_SKILL_STATE_CHANGE)
  --OpenCore.Skills:Debug()
  
  OpenCore.Paperdoll:AddListener("test", function(paperdoll)
    --OpenCore:Chat("open paperdoll " .. paperdoll:GetId() .. " " .. paperdoll:GetName())
      
    OpenCore.Window:CreateFromTemplate("OpenUI.Windows.Paperdoll." .. paperdoll:GetId(), "OpenUI.PaperdollWindow", "Root", {
      Paperdoll = paperdoll
    })
  end)
  
  OpenCore.Spellbook:AddListener("test", function (event, spellbook)
    if event == OpenCore.Spellbook.EVENT_UPDATE then 
      for i = 1, spellbook:GetSpellCount() do
        local spell = spellbook:GetSpell(i)
        if spell.enabled then
          --OpenCore:Chat(i, spell)
        end
      end
      --OpenCore:Chat("spellbook " .. spellbook:GetId(), spellbook:GetType())
      local name = "OpenUI.SpellbookWindow." .. spellbook:GetId()
      OpenCore.Window:CreateFromTemplate(name, "OpenUI.Spellbook.Window", "Root", {
        Spellbook = spellbook
      })
    end
  end)
  
  OpenCore:Chat("Tip of the day: " .. OpenCore.TipoftheDay:GetRandomTip())
  
  if HTTPGet ~= nil then
    --OpenCore:Chat("http get", HTTPGet("https://haha.com"))
  end
  
  if Win32WindowMaximize ~= nil then
    Win32WindowMaximize()
  end
  
  
  OpenCore.Window:CreateFromClass("Root", OpenUI.StatusWindow)
end

function Interface.Update(timePassed)
  OpenCore:Update(timePassed)
end

function Interface.Shutdown()
  OpenCore:Shutdown()
end