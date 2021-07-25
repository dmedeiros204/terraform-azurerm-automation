resource "random_string" "identifier" {
  length  = 3
  special = false
  keepers = {
    automation_account_name = var.automation_account_name
  }
}

resource "azurerm_log_analytics_workspace" "main" {
  for_each            = var.log_analytics_workspace != null || var.log_analytics_workspace != {} ? toset(["0"]) : []
  name                = replace(local.automation_account_name, "aaa-", "la-")
  location            = try(var.log_analytics_workspace.location, var.location)
  resource_group_name = try(var.log_analytics_workspace.resource_group_name, var.resource_group_name)
  sku                 = try(var.log_analytics_workspace.sku, "PerGB2018")
  retention_in_days   = try(var.log_analytics_workspace.retention_in_days, null)
  tags                = merge(local.default_tags, var.tags)
}


resource "azurerm_automation_account" "main" {
  name                = local.automation_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.automation_account_sku
  tags                = merge(local.default_tags, var.tags)
}

resource "azurerm_log_analytics_linked_service" "main" {
  for_each            = var.log_analytics_workspace_id != null || var.log_analytics_workspace != null || var.log_analytics_workspace != {} ? toset(["0"]) : []
  resource_group_name = try(azurerm_log_analytics_workspace.main["0"].resource_group_name, split("/", var.log_analytics_workspace_id)[4])
  workspace_id        = try(azurerm_log_analytics_workspace.main["0"].id, var.log_analytics_workspace_id)
  read_access_id      = azurerm_automation_account.main.id
}

resource "azurerm_automation_runbook" "main" {
  for_each                = { for book in var.runbooks : book.name => book }
  name                    = each.value.name
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.main.name
  log_verbose             = each.value.log_verbose
  log_progress            = each.value.log_progress
  description             = each.value.description
  runbook_type            = each.value.runbook_type
  content                 = each.value.content
  tags                    = merge(local.default_tags, var.tags)

  publish_content_link {
    uri = each.value.publish_content_link_uri == null || each.value.publish_content_link_uri == "" ? "https://portal.azure.com" : each.value.publish_content_link_uri
  }
}

resource "azurerm_automation_module" "main" {
  for_each                = { for module in var.modules : module.name => module }
  name                    = each.value.name
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.main.name

  module_link {
    uri = each.value.module_link_uri
  }
}

resource "azurerm_automation_schedule" "main" {
  for_each                = { for schedule in local.schedules : schedule.name => schedule }
  name                    = each.value.name
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.main.name
  frequency               = each.value.frequency
  interval                = each.value.interval
  timezone                = each.value.timezone
  start_time              = each.value.start_time
  description             = each.value.description
  week_days               = each.value.week_days

  dynamic "monthly_occurrence" {
    for_each = each.value.frequency == "Month" ? [0] : []

    content {
      day        = each.value.monthly_occurrence_days
      occurrence = each.value.monthly_occurrence_occurrences
    }
  }

}

resource "azurerm_resource_group_template_deployment" "main" {
  count               = var.enable_managed_identity ? 1 : 0
  name                = "deploy-system-assigned-identity"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  parameters_content = jsonencode({
    "name" = {
      value = azurerm_automation_account.main.name
    },
    "sku" = {
      value = azurerm_automation_account.main.sku_name
    }
  })
  template_content = file(format("%s/templates/managed_identity.json", path.module))
}