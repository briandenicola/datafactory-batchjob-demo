resource "azurerm_log_analytics_workspace" "k8s" {
  name                = "${var.cluster_name}-logs"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  sku                 = "pergb2018"
}

resource "azurerm_log_analytics_solution" "k8s" {
  solution_name         = "ContainerInsights"
  location              = azurerm_resource_group.k8s.location
  resource_group_name   = azurerm_resource_group.k8s.name
  workspace_resource_id = azurerm_log_analytics_workspace.k8s.id
  workspace_name        = azurerm_log_analytics_workspace.k8s.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_monitor_diagnostic_setting" "aks" {
  name                        = "diag"
  target_resource_id          = azurerm_kubernetes_cluster.k8s.id
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.k8s.id

  log {
    category = "kube-apiserver"
    enabled  = true
  }

  log {
    category = "kube-audit"
    enabled  = true
  }

  log {
    category = "kube-audit-admin"
    enabled  = true
  }

  log {
    category = "kube-controller-manager"
    enabled  = true
  }
  
  log {
    category = "kube-scheduler"
    enabled  = true
  }
  
  log {
    category = "cluster-autoscaler"
    enabled  = true
  }

  log {
    category = "guard"
    enabled  = true
  }

  metric {
    category = "AllMetrics"
  }
}