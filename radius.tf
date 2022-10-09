/*_____________________________________________________________________________________________________________________

RADIUS — Variables
_______________________________________________________________________________________________________________________
*/
variable "radius_key_1" {
  default     = ""
  description = "RADIUS Key 1."
  sensitive   = true
  type        = string
}

variable "radius_key_2" {
  default     = ""
  description = "RADIUS Key 2."
  sensitive   = true
  type        = string
}

variable "radius_key_3" {
  default     = ""
  description = "RADIUS Key 3."
  sensitive   = true
  type        = string
}

variable "radius_key_4" {
  default     = ""
  description = "RADIUS Key 4."
  sensitive   = true
  type        = string
}

variable "radius_key_5" {
  default     = ""
  description = "RADIUS Key 5."
  sensitive   = true
  type        = string
}

variable "radius_monitoring_password_1" {
  default     = ""
  description = "RADIUS Monitoring Password 1."
  sensitive   = true
  type        = string
}

variable "radius_monitoring_password_2" {
  default     = ""
  description = "RADIUS Monitoring Password 2."
  sensitive   = true
  type        = string
}

variable "radius_monitoring_password_3" {
  default     = ""
  description = "RADIUS Monitoring Password 3."
  sensitive   = true
  type        = string
}

variable "radius_monitoring_password_4" {
  default     = ""
  description = "RADIUS Monitoring Password 4."
  sensitive   = true
  type        = string
}

variable "radius_monitoring_password_5" {
  default     = ""
  description = "RADIUS Monitoring Password 5."
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
  for_each      = { for k, v in local.radius_providers : k => v if length(regexall("duo|radius", v.type)) > 0 }
  auth_port     = each.value.port
  auth_protocol = each.value.authorization_protocol
  annotation    = each.value.annotation
  description   = "${each.value.host} Provider."
  key = length(regexall(
    5, each.value.radius_key)) > 0 ? var.radius_key_5 : length(regexall(
    4, each.value.radius_key)) > 0 ? var.radius_key_4 : length(regexall(
    3, each.value.radius_key)) > 0 ? var.radius_key_3 : length(regexall(
  2, each.value.radius_key)) > 0 ? var.radius_key_2 : var.radius_key_1
  monitor_server = each.value.server_monitoring
  monitoring_password = length(regexall(
    5, each.value.password)) > 0 ? var.radius_monitoring_password_5 : length(regexall(
    4, each.value.password)) > 0 ? var.radius_monitoring_password_4 : length(regexall(
    3, each.value.password)) > 0 ? var.radius_monitoring_password_3 : length(regexall(
    2, each.value.password)) > 0 ? var.radius_monitoring_password_2 : length(regexall(
  1, each.value.password)) > 0 ? var.radius_monitoring_password_1 : ""
  monitoring_user = each.value.username
  name            = each.value.host
  retries         = each.value.retries
  timeout         = each.value.timeout
  type            = each.value.type
  # relation_aaa_rs_prov_to_epp     = 5
  relation_aaa_rs_sec_prov_to_epg = "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
}

resource "aci_rsa_provider" "rsa_providers" {
  for_each      = { for k, v in local.radius_providers : k => v if length(regexall("rsa", v.type)) > 0 }
  auth_port     = each.value.port
  auth_protocol = each.value.authorization_protocol
  annotation    = each.value.annotation
  description   = "${each.value.host} Provider."
  key = length(regexall(
    5, each.value.radius_key)) > 0 ? var.radius_key_5 : length(regexall(
    4, each.value.radius_key)) > 0 ? var.radius_key_4 : length(regexall(
    3, each.value.radius_key)) > 0 ? var.radius_key_3 : length(regexall(
  2, each.value.radius_key)) > 0 ? var.radius_key_2 : var.radius_key_1
  monitor_server = each.value.server_monitoring
  monitoring_password = length(regexall(
    5, each.value.password)) > 0 ? var.radius_monitoring_password_5 : length(regexall(
    4, each.value.password)) > 0 ? var.radius_monitoring_password_4 : length(regexall(
    3, each.value.password)) > 0 ? var.radius_monitoring_password_3 : length(regexall(
    2, each.value.password)) > 0 ? var.radius_monitoring_password_2 : length(regexall(
  1, each.value.password)) > 0 ? var.radius_monitoring_password_1 : ""
  monitoring_user = each.value.username
  name            = each.value.host
  retries         = each.value.retries
  timeout         = each.value.timeout
  # relation_aaa_rs_prov_to_epp     = 5
  relation_aaa_rs_sec_prov_to_epg = "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
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
    for v in lookup(local.admin, "radius", []) : v.login_domain => v if length(regexall(
      "(radius|rsa)", lookup(v, "type", local.defaults.admin.radius.type))
    ) > 0
  }
  annotation = lookup(each.value, "annotation", local.defaults.annotation)
  name       = each.key
}

resource "aci_duo_provider_group" "duo_provider_groups" {
  for_each = {
    for v in lookup(local.admin, "radius", []) : v.login_domain => v if lookup(
    v, "type", local.defaults.admin.radius.type) == "duo"
  }
  annotation           = lookup(each.value, "annotation", local.defaults.annotation)
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
  for_each       = { for v in lookup(local.admin, "radius", []) : v.login_domain => v }
  annotation     = lookup(each.value, "annotation", local.defaults.annotation)
  description    = "${each.key} Login Domain."
  name           = each.key
  provider_group = each.key
  realm          = lookup(each.value, "type", local.defaults.admin.radius.type) == "rsa" ? "rsa" : "radius"
  realm_sub_type = lookup(each.value, "type", local.defaults.admin.radius.type) == "duo" ? "duo" : "default"
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
