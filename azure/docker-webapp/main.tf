provider "azurerm" {
  features {}
  subscription_id = "XXXXXXXXXXXXXXXXXXXXXxx" 
}
resource "azurerm_resource_group" "rgfortune" {
  name     = "rgfortune"
  location = "East US"
}


resource "azurerm_service_plan" "plnfortune" {
  name                = "plnfortune"
  resource_group_name = azurerm_resource_group.rgfortune.name
  location            = azurerm_resource_group.rgfortune.location
  sku_name = "B1"
  os_type = "Linux"
  worker_count = 1
}

locals {
 env_variables = {
   DOCKER_REGISTRY_SERVER_URL            = "https://index.docker.io/v1/"
 }
}

resource "azurerm_linux_web_app" "appname" {
  name                = "fortuneapp"
  location            = azurerm_resource_group.rgfortune.location
  resource_group_name = azurerm_resource_group.rgfortune.name
  service_plan_id     = azurerm_service_plan.plnfortune.id

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }

  site_config {
    always_on     = false
    application_stack {
      docker_image     = "amitprem/fortune"
      docker_image_tag = "latest"
    }
  }
}

output "id" {
  value = azurerm_service_plan.plnfortune.id
}