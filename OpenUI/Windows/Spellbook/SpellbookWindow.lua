local SpellbookWindow = {
  OnInitialize = function ()
    local self = OpenUI.SpellbookWindow
    setmetatable(self, OpenUI.Components.SlottedWindow)
    OpenCore.Window:RestorePosition()
    local data = OpenCore:GetWindowData()
    local spellbook = data.Spellbook
    self:CreateSlots(
      OpenCore:GetActiveWindow(), 
      8, 0, spellbook:GetSpellCount(), 
      "OpenUI.Spellbook.Socket"
    )
    self:UpdateContents(OpenCore:GetActiveWindow(), spellbook)
  end,
  
  OnShutdown = function ()
    OpenCore.Window:SavePosition()
  end,
  
  OnClose = function ()
    OpenCore.CloseOnUpdate = OpenCore:GetActiveDialog()
  end,
  
  UpdateContents = function (self, parent, spellbook)
    local number = spellbook:GetSpellCount()
    local type = spellbook:GetType()
    LabelSetText(parent .. ".Title", type.label)
    for i = 1, number do
      local slotName = parent .. ".Slots." .. i
      local spell = spellbook:GetSpell(i)
      local texture, x, y = GetIconData(spell.icon)
      --local texture, x, y, scale, newWidth, newHeight = RequestTileArt(spell.icon, 50, 50)
      DynamicImageSetTexture(slotName..".Icon", texture, x, y)
      DynamicImageSetTextureScale(slotName..".Icon", 0.78)
      if spell.enabled then
        WindowSetTintColor(slotName..".Icon", 255, 255, 255)
      else 
        WindowSetTintColor(slotName..".Icon", 100, 100, 100)
      end
      WindowSetAlpha(slotName, 0.7)
    end
  end,
  
  OnItemClick = function ()
    local id = WindowGetId(OpenCore:GetActiveWindow())
    local parent = OpenCore:GetActiveDialog()
    local data = OpenCore:GetWindowData(parent)
    local spellbook = data.Spellbook
    local spell = spellbook:GetSpell(id)
    UserActionCastSpell(spell.serverId)
  end,
  
  OnLButtonDown = function ()
    local id = WindowGetId(OpenCore:GetActiveWindow())
    local parent = OpenCore:GetActiveDialog()
    local data = OpenCore:GetWindowData(parent)
    local spellbook = data.Spellbook
    local spell = spellbook:GetSpell(id)
    DragSlotSetActionMouseClickData(
      SystemData.UserAction.TYPE_SPELL, 
      spell.serverId, 
      spell.icon
    )
  end
}
OpenUI.SpellbookWindow = SpellbookWindow