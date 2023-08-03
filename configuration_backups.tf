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
resource "aci_trigger_scheduler" "map" {
  for_each    = local.schedulers
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
 - Admin > Schedulers > Fabric > {scheduler_name} > Recurring Window:{days}
_______________________________________________________________________________________________________________________
*/
resource "aci_recurring_window" "map" {
  depends_on = [
    aci_trigger_scheduler.map
  ]
  for_each = {
    for v in local.scheduler_windows : "${v.scheduler}:${v.schedule.days}" => v if v.window_type == "recurring"
  }
  concur_cap        = each.value.maximum_concurrent_nodes == 0 ? "unlimited" : each.value.maximum_concurrent_nodes
  day               = each.value.schedule.days
  hour              = each.value.schedule.hour
  minute            = each.value.schedule.minute
  name              = each.value.schedule.days
  node_upg_interval = 0
  proc_break        = each.value.processing_break
  proc_cap          = each.value.processing_size_capacity == 0 ? "unlimited" : each.value.processing_size_capacity
  scheduler_dn      = aci_trigger_scheduler.map[each.value.scheduler].id
  time_cap          = each.value.maximum_running_time == 0 ? "unlimited" : each.value.maximum_running_time
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "trigAbsWindowP"
 - Distinguished Name: "uni/fabric/schedp-{scheduler_name}/abswinp-{date}"
GUI Location:
 - Admin > Schedulers > Fabric > {scheduler_name} > One Time Windows:{date}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "one_time_window" {
  for_each   = { for v in local.scheduler_windows : "${v.scheduler}:${v.schedule.date}" => v if v.window_type == "one-time" }
  class_name = "trigAbsWindowP"
  dn         = "uni/fabric/schedp-${each.value.scheduler}/abswinp-${each.value.date}"
  content = {
    concurCap = each.value.maximum_concurrent_nodes == 0 ? "unlimited" : each.value.maximum_concurrent_nodes
    date      = "${each.value.date}T${each.value.hour}:${each.value.minute}.000${each.value.offset}"
    name      = each.value.date
    nodeUpgInterval = length(regexall(1, each.value.maximum_concurrent_nodes)
    ) > 0 ? each.value.delay_between_node_upgrades : 0
    procBreak = each.value.processing_break
    procCap   = each.value.processing_size_capacity == 0 ? "unlimited" : each.value.processing_size_capacity
    time_cap  = each.value.maximum_running_time == 0 ? "unlimited" : each.value.maximum_running_time
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fileRemotePath"
 - Distinguished Name: "uni/fabric/path-{remote_host}"
GUI Location:
 - Admin > Import/Export > Remote Locations:{remote_host}
_______________________________________________________________________________________________________________________
*/
resource "aci_file_remote_path" "map" {
  for_each    = local.remote_locations
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
  ) > 0 ? each.value.remote_username : ""
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
resource "aci_configuration_export_policy" "map" {
  depends_on = [
    aci_file_remote_path.map,
    aci_trigger_scheduler.map
  ]
  for_each              = local.export_policies
  admin_st              = each.value.start_now == true ? "triggered" : "untriggered"
  description           = each.value.description
  format                = each.value.format # "json|xml"
  include_secure_fields = each.value.include_secure_fields == true ? "yes" : "no"
  max_snapshot_count = length(regexall("^0$", tostring(each.value.max_snapshot_count))
  ) > 0 ? "global-limit" : each.value.max_snapshot_count
  name                                = each.key
  relation_config_rs_remote_path      = aci_file_remote_path.map[each.key].id
  relation_config_rs_export_scheduler = aci_trigger_scheduler.map[each.value.scheduler_name].id
  #
  snapshot  = length(regexall(true, each.value.snapshot)) > 0 ? "yes" : "no"
  target_dn = aci_file_remote_path.map[each.key].id
}
