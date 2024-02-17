/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "maintMaintP"
 - Distinguished Name: "uni/fabric/maintpol-{name}"
GUI Location:
 - Admin > Firmware > Nodes > {maintenance_group_name}
_______________________________________________________________________________________________________________________
*/
# The maintenance policy determines the pre-defined action to take when there is a disruptive change made to the service
# profile associated with the node or set of nodes.
resource "aci_rest_managed" "maintenance_policy" {
  for_each   = local.firmware_update_groups
  class_name = "maintMaintP"
  dn         = "uni/fabric/maintpol-${each.key}"
  content = {
    adminSt           = each.value.administrative_state == true ? "triggered" : "untriggered"
    descr             = each.value.description
    downloadSt        = each.value.download_state == true ? "triggered" : "untriggered"
    graceful          = each.value.graceful_maintenance == true ? "yes" : "no"
    ignoreCompat      = each.value.ignore_compatibility == true ? "yes" : "no"
    name              = each.key
    notifCond         = each.value.notification_condition
    runMode           = each.value.scheduler_run_mode
    smuOperation      = each.value.smu_operation_type
    smuOperationFlags = each.value.smu_operation_flags
    srUpgrade         = each.value.silent_role_package_upgrade == true ? "yes" : "no"
    srVersion         = each.value.silent_role_package_version
    version = length(regexall(true, each.value.target_simulator)
    ) > 0 ? "simsw-${each.value.target_version}" : "n9000-1${each.value.target_version}"
    versionCheckOverride = each.value.version_check_override # trigger|triggered|trigger-immediate|untriggered
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "firmwareFwGrp"
 - Distinguished Name: "uni/fabric/fwgrp-{name}"
GUI Location:
 - Admin > Firmware > Switches > {maintenance_group_name}
_______________________________________________________________________________________________________________________
*/
# A firmware group is a set of nodes to which a firmware policy may be applied.
resource "aci_rest_managed" "firmware_group" {
  for_each   = local.firmware_update_groups
  class_name = "firmwareFwGrp"
  dn         = "uni/fabric/fwgrp-${each.key}"
  content = {
    #descr = each.value.description
    name = each.key
    type = "range"
  }
  lifecycle {
    ignore_changes = [content.fwtype]
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "firmwareFwP"
 - Distinguished Name: "uni/fabric/fwpol-{name}"
GUI Location:
 - Admin > Firmware > Switches > {maintenance_group_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "firmware_policy" {
  depends_on = [aci_rest_managed.firmware_group]
  for_each   = local.firmware_update_groups
  class_name = "firmwareFwP"
  dn         = "uni/fabric/fwpol-${each.key}"
  content = {
    descr             = each.value.description
    effectiveOnReboot = each.value.effective_on_reboot == true ? "yes" : "no"  # yes|no
    ignoreCompat      = each.value.ignore_compatibility == true ? "yes" : "no" # yes|no
    name              = each.key
    srUpgrade         = each.value.silent_role_package_upgrade == true ? "yes" : "no" # yes|no
    srVersion         = each.value.silent_role_package_version
    version = length(regexall(true, each.value.target_simulator)
    ) > 0 ? "simsw-${each.value.target_version}" : "n9000-1${each.value.target_version}"
    versionCheckOverride = each.value.version_check_override # trigger|triggered|trigger-immediate|untriggered
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "maintMaintGrp"
 - Distinguished Name: "uni/fabric/maintgrp-{name}"
GUI Location:
 - Admin > Firmware > Switches > {maintenance_group_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_pod_maintenance_group" "map" {
  depends_on = [
    aci_rest_managed.maintenance_policy
  ]
  #fwtype                     = "switch"
  for_each                   = local.firmware_update_groups
  description                = each.value.description
  name                       = each.key
  pod_maintenance_group_type = "range"
  relation_maint_rs_mgrpp    = aci_rest_managed.maintenance_policy[each.key].id
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricNodeBlk"
 - Distinguished Name: "uni/fabric/maintgrp-{name}/nodeblk-blk{node_id}-{node_id}"
GUI Location:
 - Admin > Firmware > Switches > {maintenance_group_name}:Nodes
_______________________________________________________________________________________________________________________
*/
# The node block. This is a range of nodes. Each node block begins with the first port and ends with the last port.
resource "aci_maintenance_group_node" "map" {
  depends_on = [
    aci_pod_maintenance_group.map
  ]
  for_each                 = local.firmware_update_nodes
  from_                    = each.value.node_id
  name                     = "blk${each.value.node_id}-${each.value.node_id}"
  pod_maintenance_group_dn = aci_pod_maintenance_group.map[each.value.firmware_group].id
  to_                      = each.value.node_id
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricNodeBlk"
 - Distinguished Name: "uni/fabric/fwgrp-{name}/nodeblk-blk{node_id}-{node_id}"
GUI Location:
 - Admin > Firmware > Switches > {maintenance_group_name}:Nodes
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "firmware_group_nodes" {
  depends_on = [aci_rest_managed.firmware_policy]
  for_each   = local.firmware_update_nodes
  class_name = "fabricNodeBlk"
  dn         = "uni/fabric/fwgrp-${each.value.firmware_group}/nodeblk-blk${each.value.node_id}-${each.value.node_id}"
  content = {
    from_ = each.value.node_id
    name  = "blk${each.value.node_id}-${each.value.node_id}"
    to_   = each.value.node_id
  }
}