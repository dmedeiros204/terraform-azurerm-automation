output "automation_account_id" {
  value       = module.automation_account.automation_account_id
  description = "The Automation Account ID."
}

output "automation_account_dsc_server_endpoint" {
  value       = module.automation_account.automation_account_dsc_server_endpoint
  description = "The Automation Account DSC Server Endpoint."
}

output "automation_account_dsc_primary_access_key" {
  value       = module.automation_account.automation_account_dsc_primary_access_key
  description = "The Automation Account DSC Primary Access Key."
  sensitive   = true
}

output "automation_account_dsc_secondary_access_key" {
  value       = module.automation_account.automation_account_dsc_secondary_access_key
  description = "The Automation Account DSC Secondary Access Key."
  sensitive   = true
}

output "automation_account_runbooks" {
  value       = module.automation_account.automation_account_runbooks
  description = "A list of IDs for the added Runbooks"
}

output "automation_account_modules" {
  value       = module.automation_account.automation_account_modules
  description = "A list of IDs for the added Modules"
}
