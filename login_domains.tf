resource "aci_login_domain" "login_domains" {
  depends_on = [
    aci_radius_provider.radius_providers,
    aci_rsa_provider.rsa_providers,
    aci_tacacs_provider.tacacs_providers
  ]
  for_each       = { for v in local.login_domains : v.login_domain => v }
  annotation     = each.value.annotation
  description    = "${each.key} Login Domain."
  name           = each.key
  provider_group = each.key
  realm          = each.value.type
  realm_sub_type = each.value.type == "duo" ? "duo" : "default"
}

resource "aci_login_domain_provider" "login_domain_providers" {
  depends_on = [
    aci_duo_provider_group.duo_provider_groups,
    aci_login_domain.login_domains,
    aci_radius_provider_group.radius_provider_groups,
    aci_tacacs_provider.tacacs_providers,
    aci_tacacs_provider_group.tacacs_provider_groups
  ]
  for_each    = { for v in local.login_providers : "${v.host}:${v.type}" => v }
  annotation  = each.value.annotation
  description = "${each.value.host} ${upper(each.value.type)} Login Domain Provider."
  name        = each.value.host
  order       = each.value.order
  parent_dn = length(regexall(
    "duo", each.value.type)
    ) > 0 ? aci_duo_provider_group.duo_provider_groups[each.value.login_domain].id : length(regexall(
    "(radius|rsa)", each.value.type)
    ) > 0 ? aci_radius_provider_group.radius_provider_groups[each.value.login_domain
  ].id : aci_tacacs_provider_group.tacacs_provider_groups[each.value.login_domain].id
}
