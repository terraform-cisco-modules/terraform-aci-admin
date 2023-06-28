output "aaa-authentication-aaa-console" {
  value = { for v in sort(
    keys(aci_console_authentication.console)
  ) : v => aci_console_authentication.console[v].id }
}

output "aaa-authentication-aaa-default" {
  value = { for v in sort(
    keys(aci_default_authentication.default)
  ) : v => aci_default_authentication.default[v].id }
}

output "aaa-authentication-aaa-icmp_reachability" {
  value = { for v in sort(
    keys(aci_authentication_properties.icmp_reachability)
  ) : v => aci_authentication_properties.icmp_reachability[v].id }
}

output "aaa-authentication-login_domains" {
  value = {
    login_domains = { for v in sort(
      keys(aci_login_domain.login_domains)
    ) : v => aci_login_domain.login_domains[v].id }
    login_domain_providers = { for v in sort(
      keys(aci_login_domain_provider.login_domain_providers)
    ) : v => aci_login_domain_provider.login_domain_providers[v].id }
  }
}

output "aaa-authentication-radius" {
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

output "aaa-authentication-tacacs" {
  value = {
    tacacs_accounting = { for v in sort(
      keys(aci_tacacs_accounting.tacacs_accounting)
    ) : v => aci_tacacs_accounting.tacacs_accounting[v].id }
    tacacs_accounting_destinations = { for v in sort(
      keys(aci_tacacs_accounting_destination.tacacs_accounting_destinations)
    ) : v => aci_tacacs_accounting_destination.tacacs_accounting_destinations[v].id }
    tacacs_providers = { for v in sort(
      keys(aci_tacacs_provider.tacacs_providers)
    ) : v => aci_tacacs_provider.tacacs_providers[v].id }
    tacacs_provider_groups = { for v in sort(
      keys(aci_tacacs_provider_group.tacacs_provider_groups)
    ) : v => aci_tacacs_provider_group.tacacs_provider_groups[v].id }
    tacacs_sources = { for v in sort(
      keys(aci_tacacs_source.tacacs_sources)
    ) : v => aci_tacacs_source.tacacs_sources[v].id }
  }
}

output "aaa-security" {
  value = { for v in sort(
    keys(aci_global_security.security)
  ) : v => aci_global_security.security[v].id }
}


output "external_data_collectors-smart_callhome" {
  value = {
    smart_callhome_destination_groups = { for v in sort(
      keys(aci_rest_managed.smart_callhome_destination_groups)
    ) : v => aci_rest_managed.smart_callhome_destination_groups[v].id }
    smart_callhome_destination_groups_callhome_profile = { for v in sort(
      keys(aci_rest_managed.smart_callhome_destination_groups_callhome_profile)
    ) : v => aci_rest_managed.smart_callhome_destination_groups_callhome_profile[v].id }
    smart_callhome_smtp_servers = { for v in sort(
      keys(aci_rest_managed.smart_callhome_smtp_servers)
    ) : v => aci_rest_managed.smart_callhome_smtp_servers[v].id }
    smart_callhome_destinations = { for v in sort(
      keys(aci_rest_managed.smart_callhome_destinations)
    ) : v => aci_rest_managed.smart_callhome_destinations[v].id }
    smart_callhome_source = { for v in sort(
      keys(aci_rest_managed.smart_callhome_source)
    ) : v => aci_rest_managed.smart_callhome_source[v].id }
  }
}


output "external_data_collectors-syslog" {
  value = {
    syslog_destination_groups = { for v in sort(
      keys(aci_rest_managed.syslog_destination_groups)
    ) : v => aci_rest_managed.syslog_destination_groups[v].id }
    syslog_remote_destinations = { for v in sort(
      keys(aci_rest_managed.syslog_remote_destinations)
    ) : v => aci_rest_managed.syslog_remote_destinations[v].id }
    syslog_sources = { for v in sort(
      keys(aci_rest_managed.syslog_sources)
    ) : v => aci_rest_managed.syslog_sources[v].id }
  }
}


output "import_export-configuration_backups" {
  value = {
    configuration_export = { for v in sort(
      keys(aci_configuration_export_policy.configuration_export)
    ) : v => aci_configuration_export_policy.configuration_export[v].id }
    recurring_window = { for v in sort(
      keys(aci_recurring_window.recurring_window)
    ) : v => aci_recurring_window.recurring_window[v].id }
    remote_locations = { for v in sort(
      keys(aci_file_remote_path.remote_locations)
    ) : v => aci_file_remote_path.remote_locations[v].id }
    schedulers = { for v in sort(
      keys(aci_trigger_scheduler.schedulers)
    ) : v => aci_trigger_scheduler.schedulers[v].id }
  }
}
