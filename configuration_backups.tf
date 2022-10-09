/*_____________________________________________________________________________________________________________________

Configuration Backups - Admin > Import/Export Policies
_______________________________________________________________________________________________________________________
*/
variable "remote_password" {
  default     = ""
  description = "Remote Host Password."
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
resource "aci_trigger_scheduler" "schedulers" {
  for_each    = local.configuration_backups
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
    aci_trigger_scheduler.schedulers
  ]
  for_each   = local.configuration_backups
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
  scheduler_dn = aci_trigger_scheduler.schedulers[each.key].id
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
resource "aci_file_remote_path" "remote_locations" {
  for_each    = local.remote_locations
  annotation  = each.value.annotation
  auth_type   = each.value.authentication_type
  description = each.value.description
  host        = each.key
  identity_private_key_contents = length(regexall("useSshKeyContents", each.value.authentication_type)
  ) > 0 ? var.ssh_key_contents : ""
  identity_private_key_passphrase = length(regexall("useSshKeyContents", each.value.authentication_type)
  ) > 0 ? var.ssh_key_passphrase : ""
  name        = each.key
  protocol    = each.value.protocol
  remote_path = each.value.remote_path
  remote_port = each.value.remote_port
  user_name = length(regexall("usePassword", each.value.authentication_type)
  ) > 0 ? each.value.username : ""
  user_passwd = length(regexall("usePassword", each.value.authentication_type)
  ) > 0 ? var.remote_password : ""
  relation_file_rs_a_remote_host_to_epg = "uni/tn-mgmt/mgmtp-default/${each.value.mgmt_epg_type}-${each.value.management_epg}"
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
    aci_file_remote_path.remote_locations,
    aci_trigger_scheduler.schedulers
  ]
  for_each              = local.remote_locations
  admin_st              = each.value.start_now == true ? "triggered" : "untriggered"
  annotation            = each.value.annotation
  description           = each.value.description
  format                = each.value.format # "json|xml"
  include_secure_fields = each.value.include_secure_fields == true ? "yes" : "no"
  max_snapshot_count = length(
    regexall("^0$", tostring(each.value.max_snapshot_count))
  ) > 0 ? "global-limit" : each.value.max_snapshot_count
  name                                  = each.key
  relation_config_rs_export_destination = aci_file_remote_path.remote_locations[each.key].id
  relation_config_rs_export_scheduler   = aci_trigger_scheduler.schedulers[each.value.name].id
  snapshot = length(
    regexall(true, each.value.snapshot)
  ) > 0 ? "yes" : "no"
  target_dn = aci_file_remote_path.remote_locations[each.key].id
}
