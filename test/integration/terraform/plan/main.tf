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

  ### Add RunBook
  runbooks = [{
    name                     = "Get-AzureVMTutorial"
    log_verbose              = true
    log_progress             = true
    description              = "This is an example runbook"
    runbook_type             = "PowerShellWorkflow"
    publish_content_link_uri = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/c4935ffb69246a6058eb24f54640f53f69d3ac9f/101-automation-runbook-getvms/Runbooks/Get-AzureVMTutorial.ps1"
    content                  = null
    },
    {
      name                     = "AzureAutomationTutorial"
      log_verbose              = true
      log_progress             = true
      description              = "This is an example of a locally sourced runbook"
      runbook_type             = "PowerShell"
      publish_content_link_uri = null
      content                  = data.local_file.main.content
  }]

  ### Add Module
  modules = [{
    name            = "xActiveDirectory"
    module_link_uri = "https://devopsgallerystorage.blob.core.windows.net/packages/xactivedirectory.2.19.0.nupkg"
  }]

  ### Diagnostics
  diagnostics = {
    destination   = azurerm_log_analytics_workspace.main.id
    eventhub_name = null
    logs          = ["JobLogs"]
    metrics       = ["AllMetrics"]
  }

}

