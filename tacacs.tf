/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tacacsGroup"
 - Distinguished Name: "uni/fabric/tacacsgroup-{accounting_destination_group}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > TACACS > {accounting_destination_group}
*/
resource "aci_tacacs_accounting" "tacacs_accounting" {
  for_each    = { for k, v in local.tacacs : k => v }
  annotation  = each.value.annotation
  description = "${each.key} Accounting"
  name        = each.key
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tacacsTacacsDest"
 - Distinguished Name: "uni/fabric/tacacsgroup-{accounting_destination_group}/tacacsdest-{host}-port-{port}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > TACACS > {accounting_destination_group} > [TACACS Destinations]
*/
resource "aci_tacacs_accounting_destination" "tacacs_accounting_destinations" {
  depends_on = [
    aci_tacacs_accounting.tacacs_accounting
  ]
  for_each             = local.tacacs_providers
  annotation           = each.value.annotation
  description          = "${each.key} Accounting Destination."
  host                 = each.key
  key                  = var.tacacs_key
  name                 = each.key
  port                 = each.value.port
  tacacs_accounting_dn = aci_tacacs_accounting.tacacs_accounting[each.value.login_domain].id
  # relation_aaa_rs_prov_to_epp     = 5
  relation_file_rs_a_remote_host_to_epg = "uni/tn-mgmt/mgmtp-default/${each.value.mgmt_epg_type}-${each.value.management_epg}"
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "aaaTacacsPlusProvider"
 - Distinguished Name: "userext/tacacsext/tacacsplusprovider-{host}"
GUI Location:
 - Admin > AAA > Authentication:TACACS > Create TACACS Provider
_______________________________________________________________________________________________________________________
*/
resource "aci_tacacs_provider" "tacacs_providers" {
  for_each       = local.tacacs_providers
  auth_protocol  = each.value.authorization_protocol
  annotation     = each.value.annotation
  description    = "${each.key} TACACS+ Provider."
  key            = var.tacacs_key
  monitor_server = each.value.server_monitoring.admin_state == true ? "enabled" : "disabled"
  monitoring_password = length(regexall(true, each.value.server_monitoring.admin_state)
  ) > 0 ? var.tacacs_monitoring_password : ""
  monitoring_user = each.value.server_monitoring.username
  name            = each.value.host
  port            = each.value.port
  retries         = each.value.retries
  timeout         = each.value.timeout
  # relation_aaa_rs_prov_to_epp     = 5
  relation_aaa_rs_sec_prov_to_epg = "uni/tn-mgmt/mgmtp-default/${each.value.mgmt_epg_type}-${each.value.management_epg}"
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "aaaProviderRef"
 - Distinguished Name: "uni/userext/tacacsext/tacacsplusprovidergroup-{login_domain}/providerref-{host}"
GUI Location:
 - Admin > AAA > Authentication:AAA > Login Domain
_______________________________________________________________________________________________________________________
*/
resource "aci_tacacs_provider_group" "tacacs_provider_groups" {
  for_each   = { for k, v in local.tacacs : k => v }
  annotation = each.value.annotation
  name       = each.key
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tacacsSrc"
 - Distinguished Name: "uni/fabric/moncommon/tacacssrc-{accounting_source_group}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Monitoring > Common Policies > Callhome/Smart Callhome/SNMP/Syslog/TACACS:TACACS > Create TACACS Source
_______________________________________________________________________________________________________________________
*/
resource "aci_tacacs_source" "tacacs_sources" {
  depends_on = [
    aci_tacacs_accounting.tacacs_accounting
  ]
  for_each   = { for k, v in local.tacacs : k => v }
  annotation = each.value.annotation
  incl = compact(concat([
    length(regexall(
    true, each.value.accounting_include.audit_logs)) > 0 ? "audit" : ""], [
    length(regexall(
    true, each.value.accounting_include.events)) > 0 ? "events" : ""], [
    length(regexall(
    true, each.value.accounting_include.faults)) > 0 ? "faults" : ""], [
    length(regexall(
    true, each.value.accounting_include.session_logs)) > 0 ? "session" : ""]
  ))
  name                          = each.key
  parent_dn                     = "uni/fabric/moncommon"
  relation_tacacs_rs_dest_group = aci_tacacs_accounting.tacacs_accounting[each.key].id
}
