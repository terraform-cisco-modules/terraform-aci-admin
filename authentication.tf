/*_____________________________________________________________________________________________________________________

API Information:
 - Classes: "aaaAuthRealm" & "aaaPingEp"
 - Distinguished Named: "uni/userext/authrealm"
 - Distinguished Named: "uni/userext/pingext"
GUI Location:
 - Admin > AAA > Authentication
_______________________________________________________________________________________________________________________
*/
resource "aci_authentication_properties" "authentication_properties" {
  for_each        = { for k, v in local.authentication : k => v }
  annotation      = each.value.annotation
  def_role_policy = each.value.remote_user_login_policy
  ping_check      = each.value.icmp_reachability.use_icmp_reachable_providers_only
  retries         = each.value.icmp_reachability.retries
  timeout         = each.value.icmp_reachability.timeout
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
  for_each       = { for k, v in local.console : k => v }
  annotation     = each.value.annotation
  provider_group = each.value.login_domain
  realm          = each.value.realm
  realm_sub_type = each.value.realm_sub_type
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
  for_each       = { for k, v in local.default : k => v }
  annotation     = lookup(each.value, "annotation", var.annotation)
  fallback_check = each.value.fallback_domain_avialability
  provider_group = each.value.login_domain
  realm          = each.value.realm
  realm_sub_type = each.value.realm_sub_type
}
