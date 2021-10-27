resource "azurerm_storage_account" "batchdemo" {
  name                      = "sa${local.app_name}"
  resource_group_name       = azurerm_resource_group.batchdemo.name
  location                  = azurerm_resource_group.batchdemo.location
  account_tier              = "Premium"
  account_replication_type  = "LRS"
  account_kind              = "BlockBlobStorage"
  enable_https_traffic_only = true
  allow_blob_public_access  = false
  is_hns_enabled            = true
  nfsv3_enabled             = true
  min_tls_version           = "TLS1_2"
}

resource "azurerm_storage_container" "input" {
  name                  = "input"
  storage_account_name  = azurerm_storage_account.batchdemo.name
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "storage_account" {
  name                      = "sa${local.app_name}-ep"
  resource_group_name       = azurerm_resource_group.batchdemo.name
  location                  = azurerm_resource_group.batchdemo.location
  subnet_id                 = data.azurerm_subnet.private_endpoints_subnet.id

  private_service_connection {
    name                           = "sa${local.app_name}-ep"
    private_connection_resource_id = azurerm_storage_account.batchdemo.id
    subresource_names              = [ "blob" ]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                          = data.azurerm_private_dns_zone.privatelink_blob_core_windows_net.name
    private_dns_zone_ids          = [ data.azurerm_private_dns_zone.privatelink_blob_core_windows_net.id ]
  }
}