resource "azurerm_resource_group" "aks-test" {
  name     = "aks-test"
  location = var.region
}

resource "azurerm_kubernetes_cluster" "aks-test" {
  name                = "aks-test"
  location            = azurerm_resource_group.aks-test.location
  resource_group_name = azurerm_resource_group.aks-test.name
  dns_prefix          = "aks"


  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_B2s"
    vnet_subnet_id = azurerm_subnet.subnet-a1.id
  }


  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.0.3.0/24"
    dns_service_ip = "10.0.3.10"

  }

}

