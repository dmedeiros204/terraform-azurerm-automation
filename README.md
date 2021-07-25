## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.60.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2.60.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_automation_account.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account) | resource |
| [azurerm_automation_module.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_module) | resource |
| [azurerm_automation_runbook.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_runbook) | resource |
| [azurerm_automation_schedule.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_schedule) | resource |
| [azurerm_log_analytics_linked_service.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_linked_service) | resource |
| [azurerm_log_analytics_workspace.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_diagnostic_setting.custom](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_resource_group_template_deployment.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) | resource |
| [random_string.identifier](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_monitor_diagnostic_categories.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_automation_account_name"></a> [automation\_account\_name](#input\_automation\_account\_name) | Specifies the name of the automation account name. Prefix aaa- will be applied | `any` | n/a | yes |
| <a name="input_automation_account_sku"></a> [automation\_account\_sku](#input\_automation\_account\_sku) | Automation account Sku | `string` | `"Basic"` | no |
| <a name="input_diagnostics"></a> [diagnostics](#input\_diagnostics) | Diagnostic settings for those resources that support it. | <pre>object({<br>    destination   = string<br>    eventhub_name = string<br>    logs          = list(string)<br>    metrics       = list(string)<br>  })</pre> | `null` | no |
| <a name="input_enable_default_schedules"></a> [enable\_default\_schedules](#input\_enable\_default\_schedules) | Enable the default schedules. Hourly | `bool` | `true` | no |
| <a name="input_enable_managed_identity"></a> [enable\_managed\_identity](#input\_enable\_managed\_identity) | Enable the creation of a System Assigned Managed Identity | `bool` | `true` | no |
| <a name="input_enable_suffix_randomizer"></a> [enable\_suffix\_randomizer](#input\_enable\_suffix\_randomizer) | When enabled this will add a randomly generated 3 character suffix to the automation account name. Eg aaa-myname-dev-abc | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Which enviroment dev, qa, stage, production | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Optional) The location in which the resources will be created. Defaults to Canada Central | `string` | `"Canada Central"` | no |
| <a name="input_log_analytics_workspace"></a> [log\_analytics\_workspace](#input\_log\_analytics\_workspace) | Creates a log analtyics workspace linked to the automation account. Setting this will take precedence over variable log\_analytics\_workspace\_id | `map(string)` | <pre>{<br>  "retention_in_days": 30,<br>  "sku": "PerGB2018"<br>}</pre> | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | (Optional) Pre-existing Log Analytics Workspace ID that will be connected with the automation account. This will be ignored if log\_analytics\_workspace isn't null | `string` | `null` | no |
| <a name="input_modules"></a> [modules](#input\_modules) | A list of maps defining a module configuration | <pre>list(object({<br>    name            = string,<br>    module_link_uri = string<br>  }))</pre> | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the resources will be created. | `string` | n/a | yes |
| <a name="input_runbooks"></a> [runbooks](#input\_runbooks) | A list of maps defining a runbook configuration<pre>name - Specifies the name of the Runbook. Changing this forces a new resource to be created.<br>runbook_type - The type of the runbook - can be either Graph, GraphPowerShell, GraphPowerShellWorkflow, PowerShellWorkflow, PowerShell or Script.<br>log_progress - Progress log option. True\False<br>log_verbose - Verbose log option. True\False<br>publish_content_link - The published runbook content link. If using local content set this to null.<br>description - A description for this credential.<br>content - The desired content of the runbook. If using published content set this to null.</pre> | <pre>list(object({<br>    name                     = string,<br>    log_verbose              = bool,<br>    log_progress             = bool,<br>    description              = string,<br>    runbook_type             = string,<br>    publish_content_link_uri = string,<br>    content                  = string<br>  }))</pre> | `[]` | no |
| <a name="input_schedules"></a> [schedules](#input\_schedules) | A list of maps defining a schedules configuration<pre>name - (Required) Specifies the name of the Schedule. Changing this forces a new resource to be created.<br>frequency - The frequency of the schedule. - can be either OneTime, Day, Hour, Week, or Month.<br>description - A description for this Schedule.<br>interval - The number of frequencys between runs. Only valid when frequency is Day, Hour, Week, or Month and defaults to 1.<br>start_time - Start time of the schedule. Must be at least five minutes in the future. Defaults to seven minutes in the future from the time the resource is created.<br>expiry_time - The end time of the schedule.<br>timezone - The timezone of the start time. Defaults to UTC. For possible values see: https://s2.automation.ext.azure.com/api/Orchestrator/TimeZones?_=1594792230258<br>week_days -  List of days of the week that the job should execute on. Only valid when frequency is Week.<br>month_days -  List of days of the month that the job should execute on. Must be between 1 and 31. -1 for last day of the month. Only valid when frequency is Month.<br>monthly_occurrence -  List of occurrences of days within a month. Only valid when frequency is Month. The monthly_occurrence block supports fields documented below.</pre> | <pre>list(object({<br>    name                           = string,<br>    frequency                      = string,<br>    interval                       = number,<br>    timezone                       = string,<br>    start_time                     = string,<br>    description                    = string,<br>    week_days                      = list(string),<br>    monthly_occurrence_days        = list(string),<br>    monthly_occurrence_occurrences = list(string),<br>  }))</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources created. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_automation_account_dsc_primary_access_key"></a> [automation\_account\_dsc\_primary\_access\_key](#output\_automation\_account\_dsc\_primary\_access\_key) | The Automation Account DSC Primary Access Key. |
| <a name="output_automation_account_dsc_secondary_access_key"></a> [automation\_account\_dsc\_secondary\_access\_key](#output\_automation\_account\_dsc\_secondary\_access\_key) | The Automation Account DSC Secondary Access Key. |
| <a name="output_automation_account_dsc_server_endpoint"></a> [automation\_account\_dsc\_server\_endpoint](#output\_automation\_account\_dsc\_server\_endpoint) | The Automation Account DSC Server Endpoint. |
| <a name="output_automation_account_id"></a> [automation\_account\_id](#output\_automation\_account\_id) | The Automation Account ID. |
| <a name="output_automation_account_modules"></a> [automation\_account\_modules](#output\_automation\_account\_modules) | A list of IDs for the added Modules |
| <a name="output_automation_account_runbooks"></a> [automation\_account\_runbooks](#output\_automation\_account\_runbooks) | A list of IDs for the added Runbooks |
