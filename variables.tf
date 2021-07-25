variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created."
  type        = string
}

variable "location" {
  description = "(Optional) The location in which the resources will be created. Defaults to Canada Central"
  type        = string
  default     = "Canada Central"
}

variable "environment" {
  type        = string
  description = "Which enviroment dev, qa, stage, production"
}

variable "automation_account_name" {
  description = "Specifies the name of the automation account name. Prefix aaa- will be applied"
}

variable "enable_suffix_randomizer" {
  description = "When enabled this will add a randomly generated 3 character suffix to the automation account name. Eg aaa-myname-dev-abc"
  type        = bool
  default     = true
}

variable "automation_account_sku" {
  description = "Automation account Sku"
  type        = string
  default     = "Basic"
}

variable "runbooks" {
  description = <<EOVS
A list of maps defining a runbook configuration
```
name - Specifies the name of the Runbook. Changing this forces a new resource to be created.
runbook_type - The type of the runbook - can be either Graph, GraphPowerShell, GraphPowerShellWorkflow, PowerShellWorkflow, PowerShell or Script.
log_progress - Progress log option. True\False
log_verbose - Verbose log option. True\False
publish_content_link - The published runbook content link. If using local content set this to null.
description - A description for this credential.
content - The desired content of the runbook. If using published content set this to null.
```
EOVS
  type = list(object({
    name                     = string,
    log_verbose              = bool,
    log_progress             = bool,
    description              = string,
    runbook_type             = string,
    publish_content_link_uri = string,
    content                  = string
  }))
  default = []
}

variable "modules" {
  description = "A list of maps defining a module configuration"
  type = list(object({
    name            = string,
    module_link_uri = string
  }))
  default = []
}

variable "schedules" {
  description = <<EOVS
A list of maps defining a schedules configuration
```
name - (Required) Specifies the name of the Schedule. Changing this forces a new resource to be created.
frequency - The frequency of the schedule. - can be either OneTime, Day, Hour, Week, or Month.
description - A description for this Schedule.
interval - The number of frequencys between runs. Only valid when frequency is Day, Hour, Week, or Month and defaults to 1.
start_time - Start time of the schedule. Must be at least five minutes in the future. Defaults to seven minutes in the future from the time the resource is created.
expiry_time - The end time of the schedule.
timezone - The timezone of the start time. Defaults to UTC. For possible values see: https://s2.automation.ext.azure.com/api/Orchestrator/TimeZones?_=1594792230258
week_days -  List of days of the week that the job should execute on. Only valid when frequency is Week.
month_days -  List of days of the month that the job should execute on. Must be between 1 and 31. -1 for last day of the month. Only valid when frequency is Month.
monthly_occurrence -  List of occurrences of days within a month. Only valid when frequency is Month. The monthly_occurrence block supports fields documented below.
```
EOVS
  type = list(object({
    name                           = string,
    frequency                      = string,
    interval                       = number,
    timezone                       = string,
    start_time                     = string,
    description                    = string,
    week_days                      = list(string),
    monthly_occurrence_days        = list(string),
    monthly_occurrence_occurrences = list(string),
  }))
  default = null
}

variable "diagnostics" {
  description = "Diagnostic settings for those resources that support it."
  type = object({
    destination   = string
    eventhub_name = string
    logs          = list(string)
    metrics       = list(string)
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}

variable "enable_default_schedules" {
  description = "Enable the default schedules. Hourly"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  description = "(Optional) Pre-existing Log Analytics Workspace ID that will be connected with the automation account. This will be ignored if log_analytics_workspace isn't null"
  type        = string
  default     = null
}

variable "log_analytics_workspace" {
  description = "Creates a log analtyics workspace linked to the automation account. Setting this will take precedence over variable log_analytics_workspace_id"
  type        = map(string)
  default = {
    sku               = "PerGB2018"
    retention_in_days = 30
  }
}

variable "enable_managed_identity" {
  description = "Enable the creation of a System Assigned Managed Identity"
  type        = bool
  default     = true
}