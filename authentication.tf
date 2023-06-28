/*_____________________________________________________________________________________________________________________

API Information:
 - Classes: "aaaAuthRealm" & "aaaPingEp"
 - Distinguished Named: "uni/userext/authrealm"
 - Distinguished Named: "uni/userext/pingext"
GUI Location:
 - Admin > AAA > Authentication
_______________________________________________________________________________________________________________________
*/
resource "aci_authentication_properties" "icmp_reachability" {
  for_each        = { for k, v in local.icmp_reachability : k => v if tostring(v.create) == "true" }
  annotation      = each.value.annotation != "" ? each.value.annotation : var.annotation
  def_role_policy = each.value.remote_user_login_policy
  ping_check      = each.value.use_icmp_reachable_providers_only
  retries         = each.value.retries
  timeout         = each.value.timeout
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "aaaConsoleAuth"
 - Distinguished Named: "uni/userext/authrealm/consoleauth"
GUI Location:
 - Admin > AAA > Authentication
_______________________________________________________________________________________________________________________
*/
resource "aci_console_authentication" "console" {
  for_each       = { for k, v in local.console : k => v if tostring(v.create) == "true" }
  annotation     = each.value.annotation != "" ? each.value.annotation : var.annotation
  provider_group = each.value.login_domain
  realm          = length(regexall("duo", each.value.realm)) > 0 ? split("_", each.value.realm, )[2] : each.value.realm
  realm_sub_type = length(regexall("duo", each.value.realm)) > 0 ? "duo" : "default"
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "aaaDefaultAuth"
 - Distinguished Named: "uni/userext/authrealm/defaultauth"
GUI Location:
 - Admin > AAA > Authentication
_______________________________________________________________________________________________________________________
*/
resource "aci_default_authentication" "default" {
  for_each       = { for k, v in local.default : k => v if tostring(v.create) == "true" }
  annotation     = each.value.annotation != "" ? each.value.annotation : var.annotation
  fallback_check = each.value.fallback_domain_avialability
  provider_group = each.value.login_domain
  realm          = length(regexall("duo", each.value.realm)) > 0 ? split("_", each.value.realm, )[2] : each.value.realm
  realm_sub_type = length(regexall("duo", each.value.realm)) > 0 ? "duo" : "default"
}
