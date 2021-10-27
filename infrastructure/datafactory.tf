resource "azurerm_data_factory" "batchdemo" {
    name                = "df-${local.app_name}"
    location            = azurerm_resource_group.batchdemo.location
    resource_group_name = azurerm_resource_group.batchdemo.name
    managed_virtual_network_enabled = true

    identity {
        type = "UserAssigned"
        identity_ids = [ azurerm_user_assigned_identity.datafactory_identity.id ]
    }
}