/*_____________________________________________________________________________________________________________________

API Information:
 - Classes: "aaaAuthRealm" & "aaaPingEp"
 - Distinguished Named: "uni/userext/authrealm"
 - Distinguished Named: "uni/userext/pingext"
GUI Location:
 - Admin > AAA > Authentication: Authentication Default Settings: Remote Authentication
_______________________________________________________________________________________________________________________
*/
resource "aci_authentication_properties" "remote_authentication" {
  for_each        = { for k, v in local.remote_authentication : k => v if tostring(v.create) == "true" }
  annotation      = each.value.annotation != "" ? each.value.annotation : var.annotation
  def_role_policy = each.value.remote_user_login_policy
  ping_check      = each.value.ping_check
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
resource "aci_console_authentication" "console_authentication" {
  for_each       = { for k, v in local.console_authentication : k => v if tostring(v.create) == "true" }
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
resource "aci_default_authentication" "default_authentication" {
  for_each       = { for k, v in local.default_authentication : k => v if tostring(v.create) == "true" }
  annotation     = each.value.annotation != "" ? each.value.annotation : var.annotation
  fallback_check = each.value.fallback_check
  provider_group = each.value.login_domain
  realm          = length(regexall("duo", each.value.realm)) > 0 ? split("_", each.value.realm, )[2] : each.value.realm
  realm_sub_type = length(regexall("duo", each.value.realm)) > 0 ? "duo" : "default"
}
