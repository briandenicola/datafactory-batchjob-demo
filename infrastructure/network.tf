data "azurerm_virtual_network" "vnet" {
  name                = var.k8s_vnet
  resource_group_name = var.k8s_vnet_resource_group_name
}

data "azurerm_subnet" "k8s_subnet" {
  name                 = var.k8s_subnet
  virtual_network_name = var.k8s_vnet
  resource_group_name  = var.k8s_vnet_resource_group_name
}

data "azurerm_subnet" "private_endpoints_subnet" {
  name                 = var.private_endpoints_subnet
  virtual_network_name = var.k8s_vnet
  resource_group_name  = var.k8s_vnet_resource_group_name
}

data "azurerm_private_dns_zone" "privatelink_blob_core_windows_net" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.dns_resource_group
  provider            = azurerm.core
}