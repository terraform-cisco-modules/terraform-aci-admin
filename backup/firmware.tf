/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "firmwareRsFwgrpp"
 - Distinguished Name: "uni/fabric/fwgrp-{name}/rsfwgrpp"
GUI Location:
 - Admin > Firmware > Nodes > {maintenance_group_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_maintenance_policy" "maintenance_group_policy" {
  for_each               = local.maintenance_groups
  admin_st               = each.value.start_now == true ? "triggered" : "untriggered" # triggered|untriggered
  annotation             = each.value.annotation != "" ? each.value.annotation : var.annotation
  description            = each.value.description
  graceful               = each.value.graceful_upgrade == true ? "yes" : "no"    # yes|no
  ignore_compat          = each.value.compatibility_check == true ? "yes" : "no" # yes|no
  name                   = each.key
  notif_cond             = each.value.notify_conditions # notifyOnlyOnFailures|notifyAlwaysBetweenSets|notifyNever
  run_mode               = each.value.run_mode          # pauseOnlyOnFailures|pauseAlwaysBetweenSets|pauseNever
  version                = each.value.simulator == true ? "simsw-${each.value.version}" : "n9000-1${each.value.version}"
  version_check_override = each.value.version_check_override
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "firmwareFwGrp"
 - Distinguished Name: "uni/fabric/maintgrp-{name}"
GUI Location:
 - Admin > Firmware > Nodes > {maintenance_group_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_pod_maintenance_group" "maintenance_groups" {
  depends_on = [
    aci_maintenance_policy.maintenance_group_policy
  ]
  for_each                   = local.maintenance_groups
  annotation                 = each.value.annotation != "" ? each.value.annotation : var.annotation
  description                = each.value.description
  fwtype                     = each.value.policy_type # controller|switch
  name                       = each.value.name
  pod_maintenance_group_type = "range"
  relation_maint_rs_mgrpp    = aci_maintenance_policy.maintenance_group_policy[each.value.maintenance_policy].id
}

#------------------------------------------
# Add Node Block(s) to a Maintenance Group
#------------------------------------------
/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricNodeBlk"
 - Distinguished Name: "uni/fabric/maintgrp-{name}/nodeblk-blk{node_id}-{node_id}"
GUI Location:
 - Admin > Firmware > Nodes > {maintenance_group_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_maintenance_group_node" "maintenance_group_nodes" {
  depends_on = [
    aci_pod_maintenance_group.maintenance_groups
  ]
  for_each                 = local.maintenance_group_nodes
  from_                    = each.value.node_id
  name                     = "blk${each.value.node_id}-${each.value.node_id}"
  pod_maintenance_group_dn = aci_pod_maintenance_group.maintenance_groups[each.value.name].id
  to_                      = each.value.node_id
}
