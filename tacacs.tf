/*_____________________________________________________________________________________________________________________

TACACS+ — Variables
_______________________________________________________________________________________________________________________
*/
variable "tacacs_key_1" {
  default     = ""
  description = "TACACS Key 1."
  sensitive   = true
  type        = string
}

variable "tacacs_key_2" {
  default     = ""
  description = "TACACS Key 2."
  sensitive   = true
  type        = string
}

variable "tacacs_key_3" {
  default     = ""
  description = "TACACS Key 3."
  sensitive   = true
  type        = string
}

variable "tacacs_key_4" {
  default     = ""
  description = "TACACS Key 4."
  sensitive   = true
  type        = string
}

variable "tacacs_key_5" {
  default     = ""
  description = "TACACS Key 5."
  sensitive   = true
  type        = string
}

variable "tacacs_monitoring_password_1" {
  default     = ""
  description = "TACACS Monitoring Password 1."
  sensitive   = true
  type        = string
}

variable "tacacs_monitoring_password_2" {
  default     = ""
  description = "TACACS Monitoring Password 2."
  sensitive   = true
  type        = string
}

variable "tacacs_monitoring_password_3" {
  default     = ""
  description = "TACACS Monitoring Password 3."
  sensitive   = true
  type        = string
}

variable "tacacs_monitoring_password_4" {
  default     = ""
  description = "TACACS Monitoring Password 4."
  sensitive   = true
  type        = string
}

variable "tacacs_monitoring_password_5" {
  default     = ""
  description = "TACACS Monitoring Password 5."
  sensitive   = true
  type        = string
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tacacsGroup"
 - Distinguished Name: "uni/fabric/tacacsgroup-{accounting_destination_group}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > TACACS > {accounting_destination_group}
*/
resource "aci_tacacs_accounting" "tacacs_accounting" {
  for_each    = { for v in lookup(local.admin, "tacacs", []) : v.login_domain => v }
  annotation  = lookup(each.value, "annotation", local.defaults.annotation)
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
  for_each    = local.tacacs_providers
  annotation  = each.value.annotation
  description = "${each.value.host} Accounting Destination."
  host        = each.value.host
  key = length(regexall(
    5, each.value.tacacs_key)) > 0 ? var.tacacs_key_5 : length(regexall(
    4, each.value.tacacs_key)) > 0 ? var.tacacs_key_4 : length(regexall(
    3, each.value.tacacs_key)) > 0 ? var.tacacs_key_3 : length(regexall(
  2, each.value.tacacs_key)) > 0 ? var.tacacs_key_2 : var.tacacs_key_1
  name                 = each.value.host
  port                 = each.value.port
  tacacs_accounting_dn = aci_tacacs_accounting.tacacs_accounting[each.value.login_domain].id
  # relation_aaa_rs_prov_to_epp     = 5
  relation_file_rs_a_remote_host_to_epg = "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
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
  for_each      = local.tacacs_providers
  auth_protocol = each.value.authorization_protocol
  annotation    = each.value.annotation
  description   = "${each.value.host} TACACS+ Provider."
  key = length(regexall(
    5, each.value.tacacs_key)) > 0 ? var.tacacs_key_5 : length(regexall(
    4, each.value.tacacs_key)) > 0 ? var.tacacs_key_4 : length(regexall(
    3, each.value.tacacs_key)) > 0 ? var.tacacs_key_3 : length(regexall(
  2, each.value.tacacs_key)) > 0 ? var.tacacs_key_2 : var.tacacs_key_1
  monitor_server = each.value.server_monitoring
  monitoring_password = length(regexall(
    5, each.value.password)) > 0 ? var.tacacs_monitoring_password_5 : length(regexall(
    4, each.value.password)) > 0 ? var.tacacs_monitoring_password_4 : length(regexall(
    3, each.value.password)) > 0 ? var.tacacs_monitoring_password_3 : length(regexall(
    2, each.value.password)) > 0 ? var.tacacs_monitoring_password_2 : length(regexall(
  1, each.value.password)) > 0 ? var.tacacs_monitoring_password_1 : ""
  monitoring_user = each.value.username
  name            = each.value.host
  port            = each.value.port
  retries         = each.value.retries
  timeout         = each.value.timeout
  # relation_aaa_rs_prov_to_epp     = 5
  relation_aaa_rs_sec_prov_to_epg = "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
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
  for_each   = { for v in lookup(local.admin, "tacacs", []) : v.login_domain => v }
  annotation = lookup(each.value, "annotation", local.defaults.annotation)
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
  for_each   = { for v in lookup(local.admin, "tacacs", []) : v.login_domain => v }
  annotation = lookup(each.value, "annotation", local.defaults.annotation)
  incl = compact(concat([
    length(regexall(
      true, lookup(lookup(each.value, "accounting_include", local.defaults.admin.tacacs.accounting_include
    ), "audit_logs", local.defaults.admin.tacacs.accounting_include.audit_logs))) > 0 ? "audit" : ""], [
    length(regexall(
      true, lookup(lookup(each.value, "accounting_include", local.defaults.admin.tacacs.accounting_include
    ), "events", local.defaults.admin.tacacs.accounting_include.events))) > 0 ? "events" : ""], [
    length(regexall(
      true, lookup(lookup(each.value, "accounting_include", local.defaults.admin.tacacs.accounting_include
    ), "faults", local.defaults.admin.tacacs.accounting_include.faults))) > 0 ? "faults" : ""], [
    length(regexall(
      true, lookup(lookup(each.value, "accounting_include", local.defaults.admin.tacacs.accounting_include
    ), "session_logs", local.defaults.admin.tacacs.accounting_include.session_logs))) > 0 ? "session" : ""]
  ))
  name                          = each.key
  parent_dn                     = "uni/fabric/moncommon"
  relation_tacacs_rs_dest_group = aci_tacacs_accounting.tacacs_accounting[each.key].id
}

resource "aci_login_domain" "login_domain_tacacs" {
  depends_on = [
    aci_tacacs_provider.tacacs_providers
  ]
  for_each       = { for v in lookup(local.admin, "tacacs", []) : v.login_domain => v }
  annotation     = lookup(each.value, "annotation", local.defaults.annotation)
  description    = "${each.key} Login Domain."
  name           = each.key
  provider_group = each.key
  realm          = "tacacs"
  realm_sub_type = "default"
}

resource "aci_login_domain_provider" "aci_login_domain_provider_tacacs" {
  depends_on = [
    aci_login_domain.login_domain_tacacs,
    aci_tacacs_provider.tacacs_providers,
    aci_tacacs_provider_group.tacacs_provider_groups
  ]
  for_each    = local.tacacs_providers
  annotation  = each.value.annotation
  description = "${each.value.host} Login Domain Provider."
  name        = each.value.host
  order       = each.value.order
  parent_dn   = aci_tacacs_provider_group.tacacs_provider_groups[each.value.login_domain].id
}
