local HotbarWindow = {
  MAX_SLOTS = 12,

  OnGetWindowName = function (self, window)
    local id = window.HotbarId
    return "OpenUI.HotbarWindow."..id
  end,
  
  OnGetTemplate = function (self)
    return "OpenUI.HotbarWindow"
  end,

  OnInitialize = function (self)
    OpenCore.Window:RestorePosition()
    
    local id = self.HotbarId
    local hotbar = OpenCore.Hotbar:Get(id)
    self.Hotbar = hotbar
    self:UpdateItems(hotbar)
  end,
  
  UpdateItems = function (self, hotbar)
    for i = 1, self.MAX_SLOTS do
      local button = self.Name..".Button."..i
      if hotbar:HasItem(i) then
        local item = hotbar:GetItem(i)
        local icon = button..".Icon"
        if item.isSpell then
          local texture, x, y = GetIconData(item.iconId)
          DynamicImageSetTexture(icon, texture, x, y)
        elseif item.isUseItem or item.isUseType then
          local object = OpenCore.Object:GetObject(item.id, true)
          local hasItem = DoesPlayerHaveItem(item.id)
          if item.isUseItem then
            LabelSetText(button..".Quantity", L""..object:GetQuantity())
          else
            LabelSetText(button..".Quantity", L""..object:GetTypeQuantity())
          end
          local name, x, y, scale, newWidth, newHeight = RequestTileArt(item.iconId, 50, 50)
          DynamicImageSetTextureDimensions(icon, newWidth, newHeight)
          WindowSetDimensions(icon, newWidth, newHeight)
          DynamicImageSetTexture(icon, name, x, y)
          DynamicImageSetTextureScale(icon, scale)
        else
          OpenCore:Chat(button, item)
        end
        WindowSetShowing(button..".Disabled", item.disabled)
      else
        WindowSetShowing(button..".Disabled", false)
      end
    end
  end,
  
  OnShutdown = function (self)
    OpenCore.Window:SavePosition()
  end,
  
  OnHandleLButtonDown = function (self)
    OpenCore.Window:SetMoving(WindowGetParent(SystemData.ActiveWindow.name), true)
  end,
  
  OnHandleLButtonUp = function (self)
    OpenCore.Window:SetMoving(WindowGetParent(SystemData.ActiveWindow.name), false)
  end,
  
  OnItemLButtonUp = function (self)
    local index = WindowGetId(OpenCore:GetActiveWindow())
    local hotbar = self.Hotbar
    if SystemData.DragItem.DragType ~= SystemData.DragItem.TYPE_NONE then
      local success = DragSlotDropAction(hotbar:GetId(), index, 0)
      if success then
        self:UpdateItems(hotbar)
      end
    else
      hotbar:Execute(index)
    end  
  end,
  
  OnItemRButtonUp = function (self)
    local index = WindowGetId(OpenCore:GetActiveWindow())
    local hotbar = self.Hotbar
    local cm = OpenCore.ContextMenu
    cm:Reset()
    if hotbar:IsLocked() then
      cm:AddItem("unlock", OpenCore.Hotbar.TID.UNLOCK_HOTBAR, function () OpenCore:Chat("custom item")end)
    else
      cm:AddItem("lock", OpenCore.Hotbar.TID.LOCK_HOTBAR, function () OpenCore:Chat("lock")end)
    end
    cm:AddItem("new", OpenCore.Hotbar.TID.NEW_HOTBAR, function () 
      OpenCore.Hotbar:CreateHotbar()
    end)
    if OpenCore.Hotbar:GetCount() > 1 then
      local hotbarWindow = OpenCore:GetActiveDialog()
      cm:AddItem("destroy", OpenCore.Hotbar.TID.DESTROY_HOTBAR, function () 
        hotbar:Destroy()
        OpenCore.CloseOnUpdate = hotbarWindow
      end)  
    end
    cm:AddItem("hotkey", OpenCore.Hotbar.TID.ASSIGN_HOTKEY, function () OpenCore:Chat("lock") end)
    if hotbar:HasItem(index) then
      local item = hotbar:GetItem(index)
      if item.hasTargetType then
        cm:AddItem("target.self", L"Target: Self", function () OpenCore:Chat("lock") end)        
        cm:AddItem("target.cursor", L"Target: Cursor", function () OpenCore:Chat("lock") end)        
        cm:AddItem("target.stored", L"Target: Stored", function () OpenCore:Chat("lock") end)        
        cm:AddItem("target.current", L"Target: Current", function () OpenCore:Chat("lock") end)        
      end
      if item.isMacroReference then
      
      end
    end
    cm:Show()
  end,
  
  OnItemLButtonDown = function (self)
    local index = WindowGetId(OpenCore:GetActiveWindow())
    local hotbar = self.Hotbar
    if hotbar:HasItem(index) and not hotbar:IsLocked() then
      DragSlotSetExistingActionMouseClickData(hotbar:GetId(), index, 0)
    end
  end
}
HotbarWindow.Handler = OpenCore.Window.Handler
HotbarWindow.__index = HotbarWindow
OpenUI.HotbarWindow = HotbarWindow