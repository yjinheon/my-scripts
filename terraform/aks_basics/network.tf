variable "region" {
  type    = string
  default = "West Europe"
}

resource "azurerm_resource_group" "aks-net-test" {
  name     = "aks-net-test"
  location = var.region
}


resource "azurerm_virtual_network" "aks-net-test" {
  name                = "aks-net"
  resource_group_name = azurerm_resource_group.aks-net-test.name
  location            = azurerm_resource_group.aks-net-test.location
  address_space       = ["10.0.0.0/16"]
}


resource "azurerm_subnet" "subnet-a1" {
  name                 = "subnet-a1"
  resource_group_name  = azurerm_resource_group.aks-net-test.name
  virtual_network_name = azurerm_virtual_network.aks-net-test.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet-b1" {
  name                 = "subnet-b1"
  resource_group_name  = azurerm_resource_group.aks-net-test.name
  virtual_network_name = azurerm_virtual_network.aks-net-test.name
  address_prefixes     = ["10.0.2.0/24"]
}

