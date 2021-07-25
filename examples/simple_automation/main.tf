provider "azurerm" {
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
  features {}
}

resource "random_string" "name" {
  length  = 4
  special = false
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "la-${random_string.name.result}"
  location            = "Canada Central"
  resource_group_name = "rg-sandbox-cc-${random_string.name.result}"
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

data "local_file" "main" {
  filename = "AzureAutomationTutorial.ps1"
}

module "automation_account" {
  source = "../../../../"

  ### General configuration
  environment             = "dev"
  automation_account_name = "myproject"
  resource_group_name     = azurerm_log_analytics_workspace.main.resource_group_name
  location                = azurerm_log_analytics_workspace.main.location

  ### Diagnostics
  diagnostics = {
    destination   = azurerm_log_analytics_workspace.main.id
    eventhub_name = null
    logs          = ["JobLogs"]
    metrics       = ["AllMetrics"]
  }

}
