output "automation_account_id" {
  value       = azurerm_automation_account.main.id
  description = "The Automation Account ID."
}

output "automation_account_dsc_server_endpoint" {
  value       = azurerm_automation_account.main.dsc_server_endpoint
  description = "The Automation Account DSC Server Endpoint."
}

output "automation_account_dsc_primary_access_key" {
  value       = azurerm_automation_account.main.dsc_primary_access_key
  description = "The Automation Account DSC Primary Access Key."
  sensitive   = true
}

output "automation_account_dsc_secondary_access_key" {
  value       = azurerm_automation_account.main.dsc_secondary_access_key
  description = "The Automation Account DSC Secondary Access Key."
  sensitive   = true
}

output "automation_account_runbooks" {
  value       = [for book in azurerm_automation_runbook.main : book.id]
  description = "A list of IDs for the added Runbooks"
}

output "automation_account_modules" {
  value       = [for module in azurerm_automation_module.main : module.id]
  description = "A list of IDs for the added Modules"
}