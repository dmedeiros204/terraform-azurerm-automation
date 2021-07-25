locals {
  automation_account_name = var.enable_suffix_randomizer ? lower(format("aaa-%s-%s-%s", var.automation_account_name, var.environment, random_string.identifier.result)) : lower(format("aaa-%s-%s", var.automation_account_name, var.environment))
  diag_resource_list      = var.diagnostics != null ? split("/", var.diagnostics.destination) : []
  parsed_diag = var.diagnostics != null ? {
    log_analytics_id   = contains(local.diag_resource_list, "Microsoft.OperationalInsights") ? var.diagnostics.destination : null
    storage_account_id = contains(local.diag_resource_list, "Microsoft.Storage") ? var.diagnostics.destination : null
    event_hub_auth_id  = contains(local.diag_resource_list, "Microsoft.EventHub") ? var.diagnostics.destination : null
    metric             = var.diagnostics.metrics
    log                = var.diagnostics.logs
    } : {
    log_analytics_id   = null
    storage_account_id = null
    event_hub_auth_id  = null
    metric             = []
    log                = []
  }

  default_tags = {
    location       = var.location
    resource_group = var.resource_group_name
  }

  schedules = var.schedules != null ? concat(var.schedules, local.default_schedules) : local.default_schedules

  default_schedules = var.enable_default_schedules ? [{
    name                           = "Default-Hourly"
    frequency                      = "Hour"
    interval                       = 1
    timezone                       = "America/Toronto"
    start_time                     = null
    description                    = "Default Hourly Schedule"
    week_days                      = []
    monthly_occurrence_days        = null
    monthly_occurrence_occurrences = null
    },
    {
      name                           = "Default-Daily"
      frequency                      = "Day"
      interval                       = 1
      timezone                       = "America/Toronto"
      start_time                     = null
      description                    = "Default Daily Schedule"
      week_days                      = []
      monthly_occurrence_days        = null
      monthly_occurrence_occurrences = null
  }] : []

}