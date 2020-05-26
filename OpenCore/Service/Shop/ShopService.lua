local ShopService = {
  EVENT_SHOW = 0,
  EVENT_HIDE = 1,

  Listeners = {},
  ShopId = nil,
  Container = nil,
  BuyAmounts  = {},

  Initialize = function (self)
    LoadResources( 
      OpenCore:GetServiceDir().."/Shop",
      "Shopkeeper.xml", 
      "Shopkeeper.xml" 
    )
    self.OnInitializeWrap = function ()
      self:OnInitialize()
    end
    self.OnShutdownWrap = function ()
      self:OnShutdown()
    end
    self.OnShownWrap = function ()
      self:OnShown()
    end
  end,
  
  Shutdown = function (self)
    
  end,
  
  OnInitialize = function (self)
    self.ShopId = SystemData.DynamicWindowId
    local merchant = self:GetMerchant()
    merchant:Load()
    local containerId = merchant:GetSellContainerId()
    local container = OpenCore.Container:GetContainer(containerId)
    self.Container = container
    for alias, listener in pairs(self.Listeners) do
      pcall(listener, self.EVENT_SHOW, self, merchant, container)
    end
  end,
  
  OnShutdown = function (self)
    local merchant = self:GetMerchant()
    local containerId = merchant:GetSellContainerId()
    local container = OpenCore.Container:GetContainer(containerId)
    for alias, listener in pairs(self.Listeners) do
      pcall(listener, self.EVENT_HIDE, self, merchant, container)
    end
    self.Container = nil
    merchant:Unload()
  end,
  
  OnShown = function (self)
    OpenCore:Chat("shown shop")
  end,
  
  AddListener = function (self, alias, listener) 
    self.Listeners[alias] = listener
  end,
  
  RemoveListener = function (self, alias)
    self.Listeners[alias] = nil
  end,
  
  IsSelling = function (self)
    return WindowData.ShopData.IsSelling
  end,
  
  GetId = function (self)
    return self.ShopId
  end,
  
  GetMerchant = function (self)
    local id = self:GetId()
    if id == nil then
      return nil
    end
    return OpenCore.Object:GetObject(id)
  end,
  
  GetData = function (self)
    return WindowData.ShopData
  end,
  
  SetBuyAmount = function (self, id, amount)
    OpenCore:Chat("adding: "..amount.."x "..id)
    self.BuyAmounts[id] = amount
  end,
  
  GetBuyAmount = function (self, id)
    return self.BuyAmounts[id] or 0
  end,
  
  AcceptOffer = function (self)
    local index = 1
    for id, amount in pairs(self.BuyAmounts) do
      WindowData.ShopData.OfferIds[index] = id
      WindowData.ShopData.OfferQuantities[index] = amount
      index = index + 1
    end
    BroadcastEvent(SystemData.Events.SHOP_OFFER_ACCEPT)
  end
}

OpenCore:RegisterServiceClass("Shop.ShopService", "Shop", ShopService)