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
  for_each   = { for v in lookup(local.admin, "authentication", []) : "default" => v }
  annotation = lookup(each.value, "annotation", local.defaults.annotation)
  def_role_policy = lookup(
    each.value, "remote_user_login_policy", local.defaults.admin.authentication.remote_user_login_policy
  )
  ping_check = lookup(lookup(
    each.value, "icmp_reachability", local.defaults.admin.authentication.icmp_reachability
  ), "use_icmp_reachable_providers_only", local.defaults.admin.authentication.icmp_reachability.use_icmp_reachable_providers_only)
  retries = lookup(lookup(
    each.value, "icmp_reachability", local.defaults.admin.authentication.icmp_reachability
  ), "retries", local.defaults.admin.authentication.icmp_reachability.retries)
  timeout = lookup(lookup(
    each.value, "icmp_reachability", local.defaults.admin.authentication.icmp_reachability
  ), "timeout", local.defaults.admin.authentication.icmp_reachability.timeout)
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
  for_each   = { for v in lookup(local.admin, "authentication", []) : "default" => v }
  annotation = lookup(each.value, "annotation", local.defaults.annotation)
  provider_group = lookup(lookup(
    each.value, "console", local.defaults.admin.authentication.console
  ), "login_domain", local.defaults.admin.authentication.console.login_domain)
  realm = length(regexall(
    "duo_proxy_ldap", lookup(lookup(each.value, "console", local.defaults.admin.authentication.console), "realm", local.defaults.admin.authentication.console.realm))
    ) > 0 ? "ldap" : length(regexall(
    "duo_proxy_radius", lookup(lookup(each.value, "console", local.defaults.admin.authentication.console), "realm", local.defaults.admin.authentication.console.realm))
  ) > 0 ? "radius" : lookup(lookup(each.value, "console", local.defaults.admin.authentication.console), "realm", local.defaults.admin.authentication.console.realm)
  realm_sub_type = length(regexall(
    "duo", lookup(lookup(each.value, "console", local.defaults.admin.authentication.console), "realm", local.defaults.admin.authentication.console.realm))
  ) > 0 ? "duo" : "default"
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
  for_each   = { for v in lookup(local.admin, "authentication", []) : "default" => v }
  annotation = lookup(each.value, "annotation", local.defaults.annotation)
  fallback_check = lookup(lookup(
    each.value, "default", local.defaults.admin.authentication.default
  ), "fallback_domain_avialability", local.defaults.admin.authentication.default.fallback_domain_avialability)
  provider_group = lookup(lookup(
    each.value, "default", local.defaults.admin.authentication.default
  ), "login_domain", local.defaults.admin.authentication.default.login_domain)
  realm = length(regexall(
    "duo_proxy_ldap", lookup(lookup(
      each.value, "default", local.defaults.admin.authentication.default
    ), "realm", local.defaults.admin.authentication.default.realm))
    ) > 0 ? "ldap" : length(regexall(
      "duo_proxy_radius", lookup(lookup(
        each.value, "default", local.defaults.admin.authentication.default
    ), "realm", local.defaults.admin.authentication.default.realm))
  ) > 0 ? "radius" : lookup(each.value, "default", local.defaults.admin.authentication.default).realm
  realm_sub_type = length(regexall(
    "duo", lookup(lookup(each.value, "default", local.defaults.admin.authentication.default
    ), "realm", local.defaults.admin.authentication.default.realm))
  ) > 0 ? "duo" : "default"
}
