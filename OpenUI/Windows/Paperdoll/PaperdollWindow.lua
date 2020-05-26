local PaperdollWindow = {
  OnInitialize = function ()
    local data = OpenCore:GetWindowData()
    local paperdoll = data.Paperdoll
    OpenCore:Chat("hi from paperdoll " .. paperdoll:GetName())
    
    local texture = paperdoll:GetTextureData()
    local width, height = texture.Width, texture.Height
    local name = paperdoll:GetTextureName()
    local parent = OpenCore:GetActiveDialog()
    local textureName = parent .. ".Texture"
    
    WindowSetId(parent, paperdoll:GetId())
    WindowSetShowing(textureName, true)
    WindowSetHandleInput(textureName, true)
    WindowSetDimensions(parent, width, height)
    WindowSetDimensions(textureName, width, height)
    DynamicImageSetTexture(textureName, name, 0, 0)
    WindowClearAnchors(textureName)
    WindowAddAnchor(
      textureName, 
      "center", parent, 
      "topleft", texture.xOffset, texture.yOffset + 30
    )
  end,
  
  OnShutdown = function ()
  
  end,
  
  OnPaperdollLButtonDown = function ()
    local parent = OpenCore:GetActiveDialog()
    local id = WindowGetId(parent)
    local slot = GetPaperdollObject(id, WindowGetScale(parent))
    
    if WindowData.Cursor ~= nil and WindowData.Cursor.target == true and slot ~= 0 then
      HandleSingleLeftClkTarget(slot)
    else
      DragSlotSetObjectMouseClickData(slot, SystemData.DragSource.SOURCETYPE_PAPERDOLL)
    end
  end,
  
  OnPaperdollLButtonUp = function ()
    local parent = OpenCore:GetActiveDialog()
    local id = WindowGetId(parent)
    local slot = GetPaperdollObject(id, WindowGetScale(parent))
    if SystemData.DragItem.DragType == SystemData.DragItem.TYPE_ITEM then
      if slot ~= 0 then
        DragSlotDropObjectToPaperdollEquipment(slot)
      else
        DragSlotDropObjectToPaperdoll(id)
      end
    end
  end,
  
  OnCloseWindow = function ()
    OpenCore.CloseOnUpdate = OpenCore:GetActiveDialog()
  end
}
OpenUI.PaperdollWindow = PaperdollWindow