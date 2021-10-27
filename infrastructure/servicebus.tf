resource "azurerm_servicebus_namespace" "batchdemo" {
  name                      = "sb${local.app_name}"
  location                  = azurerm_resource_group.batchdemo.location
  resource_group_name       = azurerm_resource_group.batchdemo.name
  sku                       = "Premium"
  capacity                  = 2
}

resource "azurerm_servicebus_queue" "batchdemo" {
  name                = "batchjob"
  resource_group_name = azurerm_resource_group.batchdemo.name
  namespace_name      = azurerm_servicebus_namespace.batchdemo.name

  enable_partitioning = false
}