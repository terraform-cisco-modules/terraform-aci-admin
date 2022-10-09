/*_____________________________________________________________________________________________________________________

RADIUS — Variables
_______________________________________________________________________________________________________________________
*/
variable "radius_key" {
  default     = ""
  description = "RADIUS Key."
  sensitive   = true
  type        = string
}

variable "radius_monitoring_password" {
  default     = ""
  description = "RADIUS Monitoring Password."
  sensitive   = true
  type        = string
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "aaaRadiusProvider"
 - Distinguished Name: "uni/userext/radiusext/radiusprovider-{{host}}"
GUI Location:
 - Admin > AAA > Authentication:RADIUS > Create RADIUS Provider
_______________________________________________________________________________________________________________________
*/
resource "aci_radius_provider" "radius_providers" {
  for_each       = { for k, v in local.radius_providers : k => v if length(regexall("duo|radius", v.type)) > 0 }
  auth_port      = each.value.port
  auth_protocol  = each.value.authorization_protocol
  annotation     = each.value.annotation
  description    = "${each.value.host} Provider."
  key            = var.radius_key
  monitor_server = each.value.server_monitoring.admin_state == true ? "enabled" : "disabled"
  monitoring_password = length(regexall(true, each.value.server_monitoring.admin_state)
  ) > 0 ? var.radius_monitoring_password : ""
  monitoring_user = each.value.server_monitoring.username
  name            = each.value.host
  retries         = each.value.retries
  timeout         = each.value.timeout
  type            = each.value.type
  # relation_aaa_rs_prov_to_epp     = 5
  relation_aaa_rs_sec_prov_to_epg = "uni/tn-mgmt/mgmtp-default/${each.value.mgmt_epg_type}-${each.value.management_epg}"
}

resource "aci_rsa_provider" "rsa_providers" {
  for_each       = { for k, v in local.radius_providers : k => v if length(regexall("rsa", v.type)) > 0 }
  auth_port      = each.value.port
  auth_protocol  = each.value.authorization_protocol
  annotation     = each.value.annotation
  description    = "${each.value.host} Provider."
  key            = var.radius_key
  monitor_server = each.value.server_monitoring.admin_state == true ? "enabled" : "disabled"
  monitoring_password = length(regexall(true, each.value.server_monitoring.admin_state)
  ) > 0 ? var.radius_monitoring_password : ""
  monitoring_user = each.value.server_monitoring.username
  name            = each.value.host
  retries         = each.value.retries
  timeout         = each.value.timeout
  # relation_aaa_rs_prov_to_epp     = 5
  relation_aaa_rs_sec_prov_to_epg = "uni/tn-mgmt/mgmtp-default/${each.value.mgmt_epg_type}-${each.value.management_epg}"
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "aaaProviderRef"
 - Distinguished Name: "uni/userext/radiusext/radiusprovidergroup-{{login_domain}}/providerref-{{host}}"
GUI Location:
 - Admin > AAA > Authentication:AAA > Login Domain
_______________________________________________________________________________________________________________________
*/
resource "aci_radius_provider_group" "radius_provider_groups" {
  for_each = {
    for v in local.radius : v.login_domain => v if length(regexall("(radius|rsa)", v.type)) > 0
  }
  annotation = each.value.annotation
  name       = each.key
}

resource "aci_duo_provider_group" "duo_provider_groups" {
  for_each             = { for k, v in local.radius : k => v if v.type == "duo" }
  annotation           = each.value.annotation
  name                 = each.key
  auth_choice          = "CiscoAVPair"
  provider_type        = "radius"
  sec_fac_auth_methods = ["auto"]
}

resource "aci_login_domain" "login_domain" {
  depends_on = [
    aci_radius_provider.radius_providers,
    aci_rsa_provider.rsa_providers
  ]
  for_each       = { for v in local.radius : v.login_domain => v }
  annotation     = each.value.annotation
  description    = "${each.key} Login Domain."
  name           = each.key
  provider_group = each.key
  realm          = each.value.type == "rsa" ? "rsa" : "radius"
  realm_sub_type = each.value.type == "duo" ? "duo" : "default"
}

resource "aci_login_domain_provider" "aci_login_domain_provider_radius" {
  depends_on = [
    aci_login_domain.login_domain,
    aci_radius_provider_group.radius_provider_groups,
    aci_duo_provider_group.duo_provider_groups
  ]
  for_each    = local.radius_providers
  annotation  = each.value.annotation
  description = "${each.value.host} Login Domain Provider."
  name        = each.value.host
  order       = each.value.order
  parent_dn = length(regexall(
    "duo", each.value.type)
    ) > 0 ? aci_duo_provider_group.duo_provider_groups[each.value.login_domain].id : length(regexall(
    "(radius|rsa)", each.value.type)
  ) > 0 ? aci_radius_provider_group.radius_provider_groups[each.value.login_domain].id : ""
}
