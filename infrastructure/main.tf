terraform {
  backend "azurerm" {
    storage_account_name = "bjdterraform001"
    container_name       = "plans"
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "k8s" {
  name                  = var.k8s_resource_group_name
  location              = var.location
}

resource "azurerm_resource_group" "batchdemo" {
  name                  = var.resource_group_name
  location              = var.location
}

resource "random_id" "batchdemo" {
    prefix = "bjdbatch"
    byte_length = "5"
}

locals {
  app_name = lower(random_id.batchdemo.b64_url)
}