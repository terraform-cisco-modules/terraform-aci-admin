output "aaa-authentication-default_settings-console_authentication" {
  description = "Identifiers for Console Authentication.  Admin => AAA => Authentication: Authentication Default Settings: => Console Authentication."
  value = { for v in sort(keys(aci_console_authentication.console_authentication)
  ) : v => aci_console_authentication.console_authentication[v].id }
}

output "aaa-authentication-default_settings-default_authentication" {
  description = "Identifiers for Default Authentication.  Admin => AAA => Authentication: Authentication Default Settings: Console Authentication."
  value = { for v in sort(keys(aci_default_authentication.default_authentication)
  ) : v => aci_default_authentication.default_authentication[v].id }
}

output "aaa-authentication-default_settings-remote_authentication" {
  description = "Identifiers for Remote Authentication.  Admin => AAA => Authentication: Authentication Default Settings: Remote Authentication."
  value = { for v in sort(keys(aci_authentication_properties.remote_authentication)
  ) : v => aci_authentication_properties.remote_authentication[v].id }
}

output "aaa-authentication-login_domains" {
  description = <<-EOT
    * login_domains - Identifiers for Login Domains.  Admin => AAA => Authentication: Login Domains.
    * login_domain_providers - Identifiers for VMM Controllers.  Admin => AAA => Authentication: Providers.
  EOT
  value = {
    login_domains = { for v in sort(keys(aci_login_domain.login_domains)
    ) : v => aci_login_domain.login_domains[v].id }
    login_domain_providers = { for v in sort(keys(aci_login_domain_provider.login_domain_providers)
    ) : v => aci_login_domain_provider.login_domain_providers[v].id }
  }
}

output "aaa-authentication-radius" {
  description = <<-EOT
    * duo_provider_groups - Identifiers for Duo Radius Provider Groups.  Admin => AAA => Authentication: Providers.
    * radius_providers - Identifiers for Radius Providers.  Admin => AAA => Authentication: Providers.
    * radius_provider_groups - Identifiers for Radius Provider Groups.  Admin => AAA => Authentication: Providers.
    * rsa_providers - Identifiers for Radius RSA Providers.  Admin => AAA => Authentication: Providers.
  EOT
  value = {
    duo_provider_groups = { for v in sort(keys(aci_duo_provider_group.duo_provider_groups)
    ) : v => aci_duo_provider_group.duo_provider_groups[v].id }
    radius_providers = { for v in sort(keys(aci_radius_provider.radius_providers)
    ) : v => aci_radius_provider.radius_providers[v].id }
    radius_provider_groups = { for v in sort(keys(aci_radius_provider_group.radius_provider_groups)
    ) : v => aci_radius_provider_group.radius_provider_groups[v].id }
    rsa_providers = { for v in sort(keys(aci_rsa_provider.rsa_providers)
    ) : v => aci_rsa_provider.rsa_providers[v].id }
  }
}

output "aaa-authentication-tacacs" {
  description = <<-EOT
    * tacacs_accounting - Identifiers for TACACS Accounting.  Admin => External Data Collectors => Monitoring Destinations => TACACS: {Name}.
    * tacacs_accounting_destinations - Identifiers for TACACS Accounting Destinations.    Admin => External Data Collectors => Monitoring Destinations => TACACS: {Name} => TACACS Destinations.
    * tacacs_providers - Identifiers for TACACS Providers.  Admin => AAA => Authentication: Providers.
    * tacacs_provider_groups - Identifiers for TACACS Provider Groups.  Admin => AAA => Authentication: Providers.
    * tacacs_sources - Identifiers for TACACS Sources.  Fabric => Fabric Policies => Policies => Monitoring => Common Policies => Callhome/Smart Callhome/SNMP/Syslog/TACACS: TACACS.
  EOT
  value = {
    tacacs_accounting = { for v in sort(keys(aci_tacacs_accounting.tacacs_accounting)
    ) : v => aci_tacacs_accounting.tacacs_accounting[v].id }
    tacacs_accounting_destinations = { for v in sort(
      keys(aci_tacacs_accounting_destination.tacacs_accounting_destinations)
    ) : v => aci_tacacs_accounting_destination.tacacs_accounting_destinations[v].id }
    tacacs_providers = { for v in sort(keys(aci_tacacs_provider.tacacs_providers)
    ) : v => aci_tacacs_provider.tacacs_providers[v].id }
    tacacs_provider_groups = { for v in sort(keys(aci_tacacs_provider_group.tacacs_provider_groups)
    ) : v => aci_tacacs_provider_group.tacacs_provider_groups[v].id }
    tacacs_sources = { for v in sort(keys(aci_tacacs_source.tacacs_sources)
    ) : v => aci_tacacs_source.tacacs_sources[v].id }
  }
}

output "aaa-security" {
  description = "Identifiers for Global Security Policy.  Admin => AAA => Security."
  value = { for v in sort(keys(aci_global_security.security)
  ) : v => aci_global_security.security[v].id }
}


output "external_data_collectors-smart_callhome" {
  description = <<-EOT
    * smart_callhome_destination_groups - Identifiers for Smart Callhome Destination Groups.  Admin => External Data Collectors => Monitoring Destinations => Smart Callhome: {Name}.
    * smart_callhome_destination_group_properties - Identifiers for Smart Callhome Destination Groups Properties.  Admin => External Data Collectors => Monitoring Destinations => Smart Callhome: {Name} => Properties.
    * smart_callhome_destinations - Identifiers for Smart Callhome Destinations.  Admin => External Data Collectors => Monitoring Destinations => Smart Callhome: {Name} => Smart Destination.
    * smart_callhome_smtp_server - Identifiers for Smart Callhome SMTP Server.  Admin => External Data Collectors => Monitoring Destinations => Smart Callhome: {Name} => Properties.
    * smart_callhome_source - Identifiers for Smart Callhome Sources.  Fabric => Fabric Policies => Policies => Monitoring => Common Policies => Callhome/Smart Callhome/SNMP/Syslog/TACACS: Smart Callhome.
  EOT
  value = {
    smart_callhome_destination_groups = { for v in sort(keys(aci_rest_managed.smart_callhome_destination_groups)
    ) : v => aci_rest_managed.smart_callhome_destination_groups[v].id }
    smart_callhome_destination_group_properties = { for v in sort(
      keys(aci_rest_managed.smart_callhome_destination_group_properties)
    ) : v => aci_rest_managed.smart_callhome_destination_group_properties[v].id }
    smart_callhome_smtp_server = { for v in sort(keys(aci_rest_managed.smart_callhome_smtp_server)
    ) : v => aci_rest_managed.smart_callhome_smtp_server[v].id }
    smart_callhome_destinations = { for v in sort(keys(aci_rest_managed.smart_callhome_destinations)
    ) : v => aci_rest_managed.smart_callhome_destinations[v].id }
    smart_callhome_source = { for v in sort(keys(aci_rest_managed.smart_callhome_source)
    ) : v => aci_rest_managed.smart_callhome_source[v].id }
  }
}


output "external_data_collectors-syslog" {
  description = <<-EOT
    * syslog_destination_groups - Identifiers for Syslog Destination Groups.  Admin => External Data Collectors => Monitoring Destinations => Syslog: {Name}.
    * syslog_remote_destinations - Identifiers for Syslog Destinations.  Admin => External Data Collectors => Monitoring Destinations => Syslog: {Name} => Syslog Remote Destination.
    * syslog_sources - Identifiers for Syslog Sources.  Fabric => Fabric Policies => Policies => Monitoring => Common Policies => Callhome/Smart Callhome/SNMP/Syslog/TACACS: Syslog.
  EOT
  value = {
    syslog_destination_groups = { for v in sort(keys(aci_rest_managed.syslog_destination_groups)
    ) : v => aci_rest_managed.syslog_destination_groups[v].id }
    syslog_remote_destinations = { for v in sort(keys(aci_rest_managed.syslog_remote_destinations)
    ) : v => aci_rest_managed.syslog_remote_destinations[v].id }
    syslog_sources = { for v in sort(keys(aci_rest_managed.syslog_sources)
    ) : v => aci_rest_managed.syslog_sources[v].id }
  }
}


output "import_export-configuration_backups" {
  description = <<-EOT
    * configuration_export - Identifiers for Configuration Export.  Admin => Import/Export => Export Policies => Configuration.
    * recurring_window - Identifiers for Recurring Windows.  Admin => Schedulers => Fabric => {schedule_name} => Recurring Windows.
    * remote_locations - Identifiers for Remote Locations.  Admin => Import/Export => Remote Locations.
    * schedulers - Identifiers for Schedulers.  Admin => Schedulers => Fabric.
  EOT
  value = {
    configuration_export = { for v in sort(keys(aci_configuration_export_policy.configuration_export)
    ) : v => aci_configuration_export_policy.configuration_export[v].id }
    recurring_window = { for v in sort(keys(aci_recurring_window.recurring_window)
    ) : v => aci_recurring_window.recurring_window[v].id }
    remote_locations = { for v in sort(keys(aci_file_remote_path.remote_locations)
    ) : v => aci_file_remote_path.remote_locations[v].id }
    schedulers = { for v in sort(keys(aci_trigger_scheduler.schedulers)
    ) : v => aci_trigger_scheduler.schedulers[v].id }
  }
}
