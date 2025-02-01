variable "region" {
  type    = string
  default = "West Europe"
}

resource "azurerm_resource_group" "aks-net" {
  name     = "aks-net"
  location = var.region
}


resource "azurerm_virtual_network" "aks-net" {
  name                = "aks-net"
  resource_group_name = azurerm_resource_group.aks-net.name
  location            = azurerm_resource_group.aks-net.location
  address_space       = ["10.0.0.0/16"]
}


resource "azurerm_subnet" "subnet-a1" {
  name                 = "subnet-a1"
  resource_group_name  = azurerm_resource_group.aks-net.name
  virtual_network_name = azurerm_virtual_network.aks-net.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet-b1" {
  name                 = "subnet-b1"
  resource_group_name  = azurerm_resource_group.aks-net.name
  virtual_network_name = azurerm_virtual_network.aks-net.name
  address_prefixes     = ["10.0.2.0/24"]
}

