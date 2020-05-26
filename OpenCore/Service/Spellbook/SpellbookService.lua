local SpellbookService = {
  EVENT_CREATE_WINDOW = 0,
  EVENT_UPDATE = 1,

  Listeners = {},
  Books = {},
  
  Initialize = function (self)
    LoadResources( 
      OpenCore:GetServiceDir().."/Spellbook", 
      "SpellbookWindow.xml", 
      "SpellbookWindow.xml" 
    )
    self.OnUpdateSpellsWrap = function ()
      self:OnUpdateSpells()
    end
    WindowRegisterEventHandler("Root", WindowData.Spellbook.Event, "OpenCore.Spellbook.OnUpdateSpellsWrap")
  end,
  
  Shutdown = function (self)
  
  end,
  
  OnUpdateSpells = function (self)
    local id = WindowData.UpdateInstanceId
    local book = self:GetSpellbook(id)
    for alias, listener in pairs(self.Listeners) do
      pcall(listener, self.EVENT_UPDATE, book)
    end
  end,
  
  GetSpellbook = function (self, id)
    if self.Books[id] == nil then
      local book = OpenCore.Classes.Spellbook.Spellbook:Create(id)
      book:Load()
      self.Books[id] = book
    end
    return self.Books[id]
  end,
  
  AddListener = function (self, alias, listener) 
    self.Listeners[alias] = listener
  end,
  
  RemoveListener = function (self, alias)
    self.Listeners[alias] = nil
  end,
  
  OnWindowInitialize = function ()
    local self = OpenCore.Spellbook
    local id = SystemData.DynamicWindowId
    local book = self:GetSpellbook(id)
    for alias, listener in pairs(self.Listeners) do
      pcall(listener, self.EVENT_CREATE_WINDOW, book)
    end
    OpenCore.CloseOnUpdate = OpenCore:GetActiveDialog()
  end,
  
  OnWindowShutdown = function ()
    
  end
}
OpenCore:RegisterServiceClass("Spellbook.SpellbookService", "Spellbook", SpellbookService)
