local ContainerWindow = {
  OnInitialize = function ()
    OpenCore.Window:RestorePosition()
    local self = OpenUI.ContainerWindow
    setmetatable(self, OpenUI.Components.SlottedWindow)
    local container = OpenCore:GetWindowData().Container
    OpenCore.Container:AddUpdateListener(container:GetId(), function (service, container)
      self:UpdateContents(container)
    end)
    container:Open()
    self:CreateSlots(
      OpenCore:GetActiveWindow(), 
      5, 5, container:GetMaxSlots(),
      "OpenUI.Container.Socket"
    ) 
    self:UpdateContents(container)
  end,
  
  UpdateContents = function (self, container)
    local parent = "OpenUI.ContainerWindow." .. container:GetId()
    WindowSetId(parent, container:GetId())
    LabelSetText(parent .. ".Title", container:GetLabel())
  
    OpenCore:Chat("update container: " .. container:GetId() .. " - " .. container:GetItemCount() .. " / " .. container:GetMaxSlots() .. " items")
    self:HideContents(parent, container:GetMaxSlots())
    local items = container:GetItems()
    -- items might be not loaded yet
    if items == nil then
      return
    end
    for i, item in pairs(items) do
      local object = OpenCore.Object:GetObject(item.objectId, true)
      --OpenCore:Chat("" .. item.gridIndex .. ". ".. object:GetShopQuantity() .. "x " .. object:GetName() .. " (" .. object:GetShopValue() .. "gp - " .. object:GetId() .. ")")
      local slotName = parent..".Slots." .. item.gridIndex or i
      item = object:GetData()
      if item == nil then
        OpenCore:Chat(object.LoadCount)
      end
      
      if DoesWindowExist(slotName) then
        local quantity = object:GetQuantity()
        if quantity > 1 then
          LabelSetText(slotName..".Quantity", L""..quantity)
        end
      
        WindowSetId(slotName..".Icon", object:GetId())
        if item ~= nil and item.newWidth ~= nil and item.newHeight ~= nil then
          WindowSetDimensions(slotName..".Icon", item.newWidth, item.newHeight)
          DynamicImageSetTextureDimensions(slotName..".Icon", item.newWidth, item.newHeight)
          DynamicImageSetTexture(slotName..".Icon", item.iconName, 0, 0)
          DynamicImageSetCustomShader(slotName..".Icon", "UOSpriteUIShader", { item.hueId, item.objectType })
          DynamicImageSetTextureScale(slotName..".Icon", item.iconScale)
          WindowSetTintColor(slotName..".Icon", item.hue.r, item.hue.g, item.hue.b)
          WindowSetAlpha(slotName..".Icon", item.hue.a / 255)    
        end
      else
        OpenCore:Chat("slot does not exist?", slotName)
      end
    end
  end,
  
  OnShutdown = function ()
    OpenCore.Window:SavePosition()
  end,
  
  OnClose = function ()
    OpenCore.CloseOnUpdate = OpenCore.Window:GetActiveDialog()
  end,
  
  OnItemMouseOver = function ()
    local self = OpenUI.ContainerWindow
    local id = WindowGetId(OpenCore.Window:GetActiveWindowName()..".Icon")
    if id ~= nil and id > 0 then
      local object = OpenCore.Object:GetObject(id, true)
      --OpenCore:Chat(object:GetName())
      
      RegisterWindowData(WindowData.ItemProperties.Type, object:GetId())
      for i, property in pairs(WindowData.ItemProperties[object:GetId()].PropertiesList) do
        OpenCore:Chat(WStringToString(property))
      end
      
      object:Unload()
    end
  end,
  
  OnItemDoubleClick = function ()
    local self = OpenUI.ContainerWindow
    local id = WindowGetId(OpenCore.Window:GetActiveWindowName()..".Icon")
    if id ~= nil then
      UserActionUseItem(id, false)
    end
  end,
  
  OnItemClick = function ()
    local id = WindowGetId(OpenCore.Window:GetActiveWindowName()..".Icon")
    if id ~= nil then
      if WindowData.Cursor ~= nil and WindowData.Cursor.target == true then
        HandleSingleLeftClkTarget(id)
      elseif SystemData.DragItem.DragType == SystemData.DragItem.TYPE_NONE then
        DragSlotSetObjectMouseClickData(id, SystemData.DragSource.SOURCETYPE_CONTAINER)
      end
    end
  end,
  
  OnItemRelease = function ()
    if SystemData.DragItem.DragType ~= SystemData.DragItem.TYPE_ITEM then
      return
    end
  
    local parent = OpenCore:GetActiveDialog()
    local id = SystemData.DragItem.itemId
    OpenCore:Chat(id, SystemData.DragItem, "drag item ^^^^")
    for i=1, 125 do
      if id ~= nil and WindowGetId(parent..".Slots."..i..".Icon") == id then
        WindowSetId(parent..".Slots."..i..".Icon", 0)
      end
    end
  
    local id = WindowGetId(OpenCore.Window:GetActiveWindowName()..".Icon")
    local slot = WindowGetId(OpenCore.Window:GetActiveWindowName())
    local containerId = WindowGetId(OpenCore:GetActiveDialog())
    if id ~= nil and id > 0 then
    
      SystemData.ActiveContainer.SlotsWide = 5
      SystemData.ActiveContainer.SlotsHigh = 125/5
      OpenCore:Chat("drop to object at " .. slot, OpenCore.Window:GetActiveWindowName())
      DragSlotDropObjectToObjectAtIndex(id, slot)
    else
      OpenCore:Chat("drop to container at", OpenCore:GetActiveDialog(), containerId, slot)
      DragSlotDropObjectToContainer(containerId, slot)
    end
    
    --OpenCore.Object:Debug()
  end,
  
  OnContainerRelease = function (slotNum)
    if SystemData.DragItem.DragType ~= SystemData.DragItem.TYPE_ITEM then
      return
    end
    local containerId = tonumber(string.split(OpenCore.Window:GetActiveWindowName(), ".")[3])
    OpenCore:Chat("container release")
    --DragSlotDropObjectToContainer(containerId, 0)
  end
}

OpenUI.ContainerWindow = ContainerWindow