provider "azurerm" {
  features {}
  subscription_id = "subscription_id"  
}
resource "azurerm_resource_group" "rggitrun" {
  name     = "rggitrun"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "aksgitrun" {
  name                = "gitrun"
  location            = azurerm_resource_group.rggitrun.location
  resource_group_name = azurerm_resource_group.rggitrun.name
  dns_prefix          = "amitgitrun"
  automatic_channel_upgrade = "node-image"

  default_node_pool {
    name       = "runpool"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "gitrunner"
	createdby = "amitabh"
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aksgitrun.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aksgitrun.kube_config_raw
  sensitive = true
}
