resource "azurerm_role_assignment" "aks_role_assignemnt_msi" {
    principal_id              = azurerm_user_assigned_identity.aks_identity.principal_id
    scope                     = azurerm_user_assigned_identity.aks_kubelet_identity.id
    role_definition_name      = "Managed Identity Operator"
    skip_service_principal_aad_check = true 
}

resource "azurerm_role_assignment" "aks_role_assignemnt_keda" {
    principal_id              = azurerm_user_assigned_identity.aks_identity.principal_id
    scope                     = azurerm_user_assigned_identity.aks_keda_identity.id
    role_definition_name      = "Managed Identity Operator"
    skip_service_principal_aad_check = true 
}

resource "azurerm_role_assignment" "aks_role_assignemnt_pod_identity" {
    principal_id              = azurerm_user_assigned_identity.aks_identity.principal_id
    scope                     = azurerm_user_assigned_identity.aks_pod_identity.id
    role_definition_name      = "Managed Identity Operator"
    skip_service_principal_aad_check = true 
}

resource "azurerm_role_assignment" "aks_role_assignemnt_nework" {
    principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
    scope                = data.azurerm_virtual_network.vnet.id
    role_definition_name = "Network Contributor"
    skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "acr_pullrole_cluster" {
    principal_id          = azurerm_user_assigned_identity.aks_identity.principal_id
    scope                 = data.azurerm_container_registry.acr_repo.id
    role_definition_name  = "AcrPull"
    provider              = azurerm.core
    skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "acr_pullrole_nodepool" {
    principal_id         = azurerm_user_assigned_identity.aks_kubelet_identity.principal_id
    scope                = data.azurerm_container_registry.acr_repo.id
    role_definition_name = "AcrPull"
    provider             = azurerm.core
    skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "keda_sb_data_owner" {
    principal_id              = azurerm_user_assigned_identity.aks_keda_identity.principal_id
    scope                     = azurerm_servicebus_namespace.batchdemo.id
    role_definition_name      = "Azure Service Bus Data Owner" 
    skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "df_storage_data_contributor" {
    principal_id              = azurerm_user_assigned_identity.datafactory_identity.id
    scope                     = azurerm_storage_account.batchdemo.id
    role_definition_name      = "Storage Blob Data Contributor" 
    skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "df_sb_data_sender" {
    principal_id              = azurerm_user_assigned_identity.datafactory_identity.principal_id
    scope                     = azurerm_servicebus_namespace.batchdemo.id
    role_definition_name      = "Azure Service Bus Data Sender" 
    skip_service_principal_aad_check = true
}