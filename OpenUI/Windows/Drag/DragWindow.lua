local DragWindow = {
  OnInitialize = function ()
    local self = OpenUI.DragWindow
    
    local item = {
      itemId = SystemData.DragItem.itemId,
      iconName = SystemData.DragItem.itemName,
      newWidth = SystemData.DragItem.itemWidth,
      newHeight = SystemData.DragItem.itemHeight,
      iconScale = SystemData.DragItem.itemScale,
      hueId = SystemData.DragItem.itemHueId,
      hue = SystemData.DragItem.itemHue,
      objectType = SystemData.DragItem.itemType,
      amount = SystemData.DragItem.DragAmount
    }
    
    OpenCore:Chat("init drag", item)
    
    
    if SystemData.DragItem.DragType == SystemData.DragItem.TYPE_ITEM then
      WindowSetDimensions("DragWindow", SystemData.DragItem.itemWidth, SystemData.DragItem.itemHeight)
      WindowSetShowing("DragWindow.Action", false)
      
      self.CurrentItem = item
      if item.newWidth ~= nil and item.newHeight ~= nil then
        WindowSetDimensions("DragWindow.Item", item.newWidth, item.newHeight)
        DynamicImageSetTextureDimensions("DragWindow.Item", item.newWidth, item.newHeight)
        DynamicImageSetTexture("DragWindow.Item", item.iconName, 0, 0)
        DynamicImageSetCustomShader("DragWindow.Item", "UOSpriteUIShader", { item.hueId, item.objectType })
        DynamicImageSetTextureScale("DragWindow.Item", item.iconScale)
        WindowSetTintColor("DragWindow.Item", item.hue.r, item.hue.g, item.hue.b)
        WindowSetAlpha("DragWindow.Item", item.hue.a / 255)    
      end     
      DynamicImageSetTexture( "DragWindow.IconMulti", "", 0, 0 ) 
      RegisterWindowData(WindowData.ObjectInfo.Type, item.itemId)
      local itemdata = WindowData.ObjectInfo[item.itemId]
      if not itemdata then
        local object = OpenCore.Object:GetObject(item.itemId, true)  
        --RegisterWindowData(WindowData.ObjectInfo.Type, item.itemId)
        itemdata = WindowData.ObjectInfo[item.itemId]
      end
      if itemdata and itemdata.quantity then
        item.amount = itemdata.quantity
      end
      if not item.amount or not itemdata then
        item.amount = 1
      end
      if itemdata and item.amount > 1 and item.objectType ~= 3821 and item.objectType ~= 3824 then
        --EquipmentData.UpdateItemIcon("DragWindow.IconMulti", item)  
      end
      if item.amount > 1 then
        LabelSetText("DragWindow.Quantity", L"x" .. Knumber(item.amount))
      end
    elseif SystemData.DragItem.DragType == SystemData.DragItem.TYPE_ACTION then
      WindowSetDimensions("DragWindow", SystemData.DragItem.itemWidth, SystemData.DragItem.itemHeight)
      self.CurrentItem = item
      
      local x, y = WindowGetDimensions("DragWindow.Action")
      local disabled = false
      if SystemData.DragItem.actionType == SystemData.UserAction.TYPE_MACRO_REFERENCE then
        disabled = not UserActionIsTargetModeCompat(SystemData.MacroSystem.STATIC_MACRO_ID, SystemData.DragItem.actionId, 0)
      else
        disabled = not UserActionIsActionTypeTargetModeCompat(SystemData.DragItem.actionType)
      end
    
      local texture, x, y = GetIconData(SystemData.DragItem.actionIconId)
      WindowSetDimensions("DragWindow", 50, 50)
      WindowSetDimensions("DragWindow.Item", 50, 50)
      DynamicImageSetTextureDimensions("DragWindow.Item", 50, 50)
      DynamicImageSetTexture("DragWindow.Item", texture, 0, 0)
      --WindowSetDimensions("DragWindow.Item", x, y)
      --DynamicImageSetTextureDimensions("DragWindow.Item", x, y)
      --DynamicImageSetTexture("DragWindow.Item", texture, 0, 0)
      DynamicImageSetTextureScale("DragWindow.Item", 0.78)
      
      --HotbarSystem.UpdateActionButton("DragWindowAction", SystemData.DragItem.actionType, SystemData.DragItem.actionId, SystemData.DragItem.actionIconId, disabled )
      
      --local tintColor = HotbarSystem.TargetTypeTintColors[SystemData.Hotbar.TargetType.TARGETTYPE_NONE]
      --WindowSetTintColor("DragWindowActionOverlay",tintColor[1],tintColor[2],tintColor[3])
      --WindowSetShowing("DragWindowActionHotkeyBackground",false)   
    else
      OpenCore:Chat("unkwon drag type")
    end
    
    self.OnUpdate()
  end,
  
  OnShutdown = function ()
    OpenCore:Chat("shut drag")
  end,
  
  OnUpdate = function ()
    local self = OpenUI.DragWindow
    local posX = SystemData.MousePosition.x/InterfaceCore.scale
    local posY = SystemData.MousePosition.y/InterfaceCore.scale
    
    --OpenCore:Chat("update drag " .. posX .. ":" ..posY)

    WindowClearAnchors("DragWindow")
    if( SystemData.DragItem.DragType == SystemData.DragItem.TYPE_ITEM ) then
      WindowAddAnchor("DragWindow", "topleft", "Root", "center", posX, posY)
    elseif( SystemData.DragItem.DragType == SystemData.DragItem.TYPE_ACTION ) then
      WindowAddAnchor("DragWindow", "topleft", "Root", "topleft", posX, posY)
    end
    
    local item = self.CurrentItem
    if SystemData.DragItem.DragType == SystemData.DragItem.TYPE_ITEM then
        WindowSetDimensions("DragWindow", SystemData.DragItem.itemWidth, SystemData.DragItem.itemHeight)
        WindowSetShowing("DragWindow.Action",false)
        
        

        if item.newWidth ~= nil and item.newHeight ~= nil then
          WindowSetDimensions("DragWindow.Item", item.newWidth, item.newHeight)
          DynamicImageSetTextureDimensions("DragWindow.Item", item.newWidth, item.newHeight)
          DynamicImageSetTexture("DragWindow.Item", item.iconName, 0, 0)
          DynamicImageSetCustomShader("DragWindow.Item", "UOSpriteUIShader", { item.hueId, item.objectType })
          DynamicImageSetTextureScale("DragWindow.Item", item.iconScale)
          WindowSetTintColor("DragWindow.Item", item.hue.r, item.hue.g, item.hue.b)
          WindowSetAlpha("DragWindow.Item", item.hue.a / 255)    
        end        

        --DynamicImageSetTexture( "DragWindowIconMulti", "", 0, 0 ) 
        local object = OpenCore.Object:GetObject(item.itemId, true)
        --RegisterWindowData(WindowData.ObjectInfo.Type, item.itemId)
        local itemdata = WindowData.ObjectInfo[item.itemId]
        if not itemdata then
          local object = OpenCore.Object:GetObject(item.itemId, true)
          --RegisterWindowData(WindowData.ObjectInfo.Type, item.itemId)
          itemdata = WindowData.ObjectInfo[item.itemId]
        end
    
        if not item.amount and itemdata then
          item.amount = itemdata.quantity
        end

        if not item.amount or not itemdata then
          item.amount = 1
        end
        if itemdata and item.amount > 1 and item.objectType ~= 3821 and item.objectType ~= 3824 then
          --EquipmentData.UpdateItemIcon("DragWindowIconMulti", item)  
        end
        if item.amount > 1 then
          LabelSetText("DragWindow.Quantity", L"x" .. Knumber(item.amount))
        end
    elseif SystemData.DragItem.DragType == SystemData.DragItem.TYPE_ACTION then
      
    end
  end
}

OpenUI.DragWindow = DragWindow