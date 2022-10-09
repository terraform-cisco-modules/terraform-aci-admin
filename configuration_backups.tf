/*_____________________________________________________________________________________________________________________

Configuration Backups - Admin > Import/Export Policies
_______________________________________________________________________________________________________________________
*/
variable "remote_password_1" {
  default     = ""
  description = "Remote Host Password 1."
  sensitive   = true
  type        = string
}

variable "remote_password_2" {
  default     = ""
  description = "Remote Host Password 2."
  sensitive   = true
  type        = string
}

variable "remote_password_3" {
  default     = ""
  description = "Remote Host Password 3."
  sensitive   = true
  type        = string
}

variable "remote_password_4" {
  default     = ""
  description = "Remote Host Password 4."
  sensitive   = true
  type        = string
}

variable "remote_password_5" {
  default     = ""
  description = "Remote Host Password 5."
  sensitive   = true
  type        = string
}

variable "ssh_key_contents" {
  default     = ""
  description = "SSH Private Key Based Authentication Contents."
  sensitive   = true
  type        = string
}

variable "ssh_key_passphrase" {
  default     = ""
  description = "SSH Private Key Based Authentication Passphrase."
  sensitive   = true
  type        = string
}


#----------------------------------------------
# Create a Triggered Scheduler
#----------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "trigSchedP"
 - Distinguished Name: "uni/fabric/schedp-{scheduler_name}"
GUI Location:
 - Admin > Schedulers > Fabric > {scheduler_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_trigger_scheduler" "trigger_schedulers" {
  for_each    = local.recurring_window
  annotation  = each.value.annotation
  description = each.value.description
  name        = each.key
}

#----------------------------------------------------
# Assign a Recurring Window to the Trigger Scheduler
#----------------------------------------------------
/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "trigRecurrWindowP"
 - Distinguished Name: "uni/fabric/schedp-{scheduler_name}/recurrwinp-{scheduler_name}"
GUI Location:
 - Admin > Schedulers > Fabric > {scheduler_name} > Recurring Window {scheduler_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_recurring_window" "recurring_window" {
  depends_on = [
    aci_trigger_scheduler.trigger_schedulers
  ]
  for_each   = local.recurring_window
  annotation = each.value.annotation
  concur_cap = each.value.maximum_concurrent_nodes == 0 ? "unlimited" : each.value.maximum_concurrent_nodes
  day        = each.value.schedule.days
  hour       = each.value.schedule.hour
  minute     = each.value.schedule.minute
  name       = each.key
  node_upg_interval = length(regexall(
    1, each.value.maximum_concurrent_nodes)
  ) > 0 && each.value.window_type == "one-time" ? each.value.delay_between_node_upgrades : 0
  proc_break   = each.value.processing_break
  proc_cap     = each.value.processing_size_capacity == 0 ? "unlimited" : each.value.processing_size_capacity
  scheduler_dn = aci_trigger_scheduler.trigger_schedulers[each.key].id
  time_cap     = each.value.maximum_running_time == 0 ? "unlimited" : each.value.maximum_running_time
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fileRemotePath"
 - Distinguished Name: "uni/fabric/path-{remote_host}"
GUI Location:
 - Admin > Import/Export > Remote Locations:{remote_host}
_______________________________________________________________________________________________________________________
*/
resource "aci_file_remote_path" "export_remote_hosts" {
  for_each                        = { for k, v in local.configuration_export : k => v if length(local.recurring_window) > 0 }
  annotation                      = each.value.annotation
  auth_type                       = each.value.authentication_type
  description                     = each.value.description
  host                            = each.value.remote_host
  identity_private_key_contents   = each.value.authentication_type == "useSshKeyContents" ? var.ssh_key_contents : ""
  identity_private_key_passphrase = each.value.authentication_type == "useSshKeyContents" ? var.ssh_key_passphrase : ""
  name                            = each.key
  protocol                        = each.value.protocol
  remote_path                     = each.value.remote_path
  remote_port                     = each.value.remote_port
  user_name                       = each.value.authentication_type == "usePassword" ? each.value.username : ""
  user_passwd = length(regexall(
    5, each.value.password)) > 0 && each.value.authentication_type == "usePassword" ? var.remote_password_5 : length(regexall(
    4, each.value.password)) > 0 && each.value.authentication_type == "usePassword" ? var.remote_password_4 : length(regexall(
    3, each.value.password)) > 0 && each.value.authentication_type == "usePassword" ? var.remote_password_3 : length(regexall(
    2, each.value.password)) > 0 && each.value.authentication_type == "usePassword" ? var.remote_password_2 : length(regexall(
  1, each.value.password)) > 0 && each.value.authentication_type == "usePassword" ? var.remote_password_1 : ""
  relation_file_rs_a_remote_host_to_epg = "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
}

#----------------------------------------------------
# Create Configuration Export Policy
#----------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "configExportP"
 - Distinguished Name: "uni/fabric/configexp-{export_name}"
GUI Location:
 - Admin > Import/Export > Export Policies > Configuration > {export_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_configuration_export_policy" "configuration_export" {
  depends_on = [
    aci_file_remote_path.export_remote_hosts,
    aci_trigger_scheduler.trigger_schedulers
  ]
  for_each                              = { for k, v in local.configuration_export : k => v if length(local.recurring_window) > 0 }
  admin_st                              = each.value.start_now == true ? "triggered" : "untriggered"
  annotation                            = each.value.annotation
  description                           = each.value.description
  format                                = each.value.format # "json|xml"
  include_secure_fields                 = each.value.include_secure_fields == true ? "yes" : "no"
  max_snapshot_count                    = each.value.max_snapshot_count == 0 ? "global-limit" : 0 # 0-10
  name                                  = each.key
  snapshot                              = each.value.snapshot == true ? "yes" : "no"
  target_dn                             = aci_file_remote_path.export_remote_hosts[each.key].id
  relation_config_rs_export_destination = aci_file_remote_path.export_remote_hosts[each.key].id
  relation_config_rs_export_scheduler   = aci_trigger_scheduler.trigger_schedulers[each.value.name].id
}
