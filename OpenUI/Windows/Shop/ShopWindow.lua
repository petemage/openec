local ShopWindow = {
  OnGetWindowName = function (self, window)
    local container = window.Container
    return "OpenUI.ShopWindow." .. container:GetId()
  end,
  
  OnGetTemplate = function (self, window)
    return "OpenUI.ShopWindow"
  end,

  OnInitialize = function (self)
    OpenCore.Window:RestorePosition()
    local container = self.Container
    OpenCore.Container:AddUpdateListener(container:GetId(), function (service, container)
      self:UpdateContents(container)
    end)
    container:Open()
    self:CreateSlots(
      OpenCore:GetActiveWindow(), 
      3, 5, container:GetMaxSlots(),
      "OpenUI.Shop.Socket"
    ) 
    self:UpdateContents(container)
  end,
  
  UpdateContents = function (self, container)
    local parent = self.Name
    WindowSetId(parent, container:GetId())
    LabelSetText(parent .. ".Title", container:GetLabel())
  
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
      end
    end
  end,

  OnShutdown = function (self)
    OpenCore.Window:SavePosition()
  end,
  
  OnClose = function (self)
    OpenCore.CloseOnUpdate = OpenCore.Window:GetActiveDialog()
  end,
  
  OnItemMouseOver = function (self)
    local slot = WindowGetId(OpenCore:GetActiveWindow())
    local id = WindowGetId(OpenCore.Window:GetActiveWindowName()..".Icon")
    if id ~= nil then
      local object = OpenCore.Object:GetObject(id, true)
      --OpenCore:Chat(object:GetName())
      
      RegisterWindowData(WindowData.ItemProperties.Type, object:GetId())
      for i, property in pairs(WindowData.ItemProperties[object:GetId()].PropertiesList) do
        OpenCore:Chat(object:GetName() .. ": " .. WStringToString(property))
      end
      
      object:Unload()
    end
  end,
  
  OnItemClick = function (self)
    local slot = WindowGetId(OpenCore:GetActiveWindow())
    local id = WindowGetId(OpenCore.Window:GetActiveWindowName()..".Icon")
    if id ~= nil then
      OpenCore.Shop:SetBuyAmount(id, 1)
      OpenCore.Shop:AcceptOffer()
    end
  
    
  end
}
ShopWindow.__index = function (t, index) 
  if OpenUI.ShopWindow[index] then
    return OpenUI.ShopWindow[index]
  end
  if OpenUI.Components.SlottedWindow[index] then
    return OpenUI.Components.SlottedWindow[index]
  end
end
ShopWindow.Handler = OpenCore.Window.Handler
OpenUI.ShopWindow = ShopWindow