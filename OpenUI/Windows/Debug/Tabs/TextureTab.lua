local TextureTab = {
  Name = "TextureTab",
  Title = "Textures",
  
  InitializeTextureTab = function (self, parent)
    local textureTab = parent..".TextureTab"
    OpenCore.Window:CreateFromTemplate(textureTab, "OpenUI.DebugWindow.TextureTab", parent)
    DynamicImageSetTexture(textureTab..".Texture", "UO_Core", 0, 0)
    TextEditBoxSetText(self.Name..".Tabs.TextureTab.TextInput", L"UO_Core")
    DynamicImageSetTextureScale(textureTab..".Texture", 0.7)
  end,
  
  OnTextureInput = function (self)
    local query = TextEditBoxGetText(self.Name..".Tabs.TextureTab.TextInput")
    DynamicImageSetTexture(self.Name..".Tabs.TextureTab.Texture", WStringToString(query), 0, 0)
  end
}
OpenUI.DebugWindow:AddTab(TextureTab)