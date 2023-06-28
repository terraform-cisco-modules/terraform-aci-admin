# output "admin" {
#   value = local.admin
# }
# 
# output "defaults" {
#   value = local.defaults
# }
output "authentication-aaa-console" {
  value = { for v in sort(
    keys(aci_console_authentication.console)
  ) : v => aci_console_authentication.console[v].id }
}

output "authentication-aaa-default" {
  value = { for v in sort(
    keys(aci_default_authentication.default)
  ) : v => aci_default_authentication.default[v].id }
}

output "authentication-aaa-icmp_reachability" {
  value = { for v in sort(
    keys(aci_authentication_properties.icmp_reachability)
  ) : v => aci_authentication_properties.icmp_reachability[v].id }
}

output "authentication-radius" {
  value = {
    duo_provider_groups = { for v in sort(
      keys(aci_duo_provider_group.duo_provider_groups)
    ) : v => aci_duo_provider_group.duo_provider_groups[v].id }
    radius_providers = { for v in sort(
      keys(aci_radius_provider.radius_providers)
    ) : v => aci_radius_provider.radius_providers[v].id }
    radius_provider_groups = { for v in sort(
      keys(aci_radius_provider_group.radius_provider_groups)
    ) : v => aci_radius_provider_group.radius_provider_groups[v].id }
    rsa_providers = { for v in sort(
      keys(aci_rsa_provider.rsa_providers)
    ) : v => aci_rsa_provider.rsa_providers[v].id }
  }
}

output "authentication-tacacs" {
  value = { for v in sort(
    keys(aci_authentication_properties.icmp_reachability)
  ) : v => aci_authentication_properties.icmp_reachability[v].id }
}

