local SlottedWindow = {
  CreateSlots = function (self, parent, gridWidth, maxHeight, slotCount, slotTemplate)  
    OpenCore.Window:CreateFromTemplate(parent..".Grid", "OpenUI.Components.SlottedWindow", parent)  
    
    for i = 1, slotCount do
      local slotName = parent .. ".Slots." .. i
      if not DoesWindowExist(slotName) then
        OpenCore.Window:CreateFromTemplate(slotName, slotTemplate, parent..".Grid.ScrollChild")
      end
      
      WindowSetId(slotName, i)
      WindowClearAnchors(slotName)
      if i == 1 then
        WindowAddAnchor(slotName, "topleft", parent..".Grid.ScrollChild", "topleft", 0, 0)
      elseif (i % gridWidth) == 1 then
        WindowAddAnchor(slotName, "bottomleft", parent .. ".Slots."..i-gridWidth, "topleft", 0, 1)
      else
        WindowAddAnchor(slotName, "topright", parent .. ".Slots."..i-1, "topleft", 1, 0)
      end
      WindowSetShowing(slotName, true)
    end
    
    self:SetDimensions(parent, slotCount, gridWidth, maxHeight, slotTemplate)
    ScrollWindowUpdateScrollRect(parent..".Grid")
  end,
  
  HideContents = function (self, parent, slotCount)
    for i = 1, slotCount do
      local slotName = parent .. ".Slots." .. i
      DynamicImageSetTexture(slotName..".Icon", "", 0, 0);
      LabelSetText(slotName..".Quantity", L"")
      WindowSetTintColor(slotName, 255, 255, 255)
    end
  end,
  
  SetDimensions = function (self, parent, slotCount, gridWidth, maxHeight, slotTemplate)
    maxHeight = maxHeight or 0
    local gridHeight = math.ceil(slotCount / gridWidth)
    if maxHeight > 0 and gridHeight > maxHeight then
      gridHeight = maxHeight
    end
    
    local dummy = parent..".Dummy"
    CreateWindowFromTemplate(dummy, slotTemplate, parent)
    local slotWidth, slotHeight = WindowGetDimensions(dummy)
    DestroyWindow(dummy)
    
    local w = gridWidth * (slotWidth + 1)
    local h = gridHeight * (slotHeight + 1)
    WindowSetDimensions(parent, w, h + 30)
    WindowSetDimensions(parent..".Grid", w, h)
    WindowSetDimensions(parent..".Grid.ScrollChild", w, (slotCount / gridWidth + 1) * (slotHeight + 1))
  end,
}
SlottedWindow.__index = SlottedWindow
OpenUI.Components.SlottedWindow = SlottedWindow
