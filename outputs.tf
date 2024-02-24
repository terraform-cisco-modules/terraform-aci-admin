/*_____________________________________________________________________________________________________________________

AAA — Outputs
_______________________________________________________________________________________________________________________
*/
output "aaa" {
  description = <<-EOT
    Identifiers for:
      authentication:
        authentication_default_settings:
          * console_authentication: Admin => AAA => Authentication: Authentication Default Settings: Console Authentication.
          * default_authentication: Admin => AAA => Authentication: Authentication Default Settings: Default Authentication.
          * remote_authentication:  Admin => AAA => Authentication: Authentication Default Settings: Remote Authentication.
        login_domains:  Admin => AAA => Authentication: Authentication Default Settings: Login Domains
        login_domain_providers: Admin => AAA => Authentication: Authentication Default Settings: Providers
        providers:
          radius:
            * duo_provider_groups:  Admin => AAA => Authentication: Providers.
            * radius_providers:  Admin => AAA => Authentication: Providers.
            * radius_provider_groups:  Admin => AAA => Authentication: Providers.
            * rsa_providers:  Admin => AAA => Authentication: Providers.
          tacacs:
            * tacacs_accounting: Admin => External Data Collectors => Monitoring Destinations => TACACS: {Name}.
            * tacacs_accounting_destinations: Admin => External Data Collectors => Monitoring Destinations => TACACS: {Name} => TACACS Destinations.
            * tacacs_providers: Admin => AAA => Authentication: Providers.
            * tacacs_provider_groups: Admin => AAA => Authentication: Providers.
            * tacacs_sources: Fabric => Fabric Policies => Policies => Monitoring => Common Policies => Callhome/Smart Callhome/SNMP/Syslog/TACACS: TACACS.
        security: Admin => AAA => Security.
  EOT
  value = {
    authentication = {
      authentication_default_settings = {
        console_authentication = {
          for v in sort(keys(aci_console_authentication.map)) : v => aci_console_authentication.map[v].id
        }
        default_authentication = {
          for v in sort(keys(aci_default_authentication.map)) : v => aci_default_authentication.map[v].id
        }
        remote_authentication = {
          for v in sort(keys(aci_authentication_properties.remote_authentication)
          ) : v => aci_authentication_properties.remote_authentication[v].id
        }
      }
      login_domains = { for v in sort(keys(aci_login_domain.login_domains)) : v => aci_login_domain.login_domains[v].id }
      login_domain_providers = {
        for v in sort(keys(aci_login_domain_provider.login_domain_providers)
        ) : v => aci_login_domain_provider.login_domain_providers[v].id
      }
      providers = {
        radius = {
          duo_provider_groups = { for v in sort(keys(aci_duo_provider_group.duo_provider_groups)
          ) : v => aci_duo_provider_group.duo_provider_groups[v].id }
          radius_providers = { for v in sort(keys(aci_radius_provider.radius_providers)
          ) : v => aci_radius_provider.radius_providers[v].id }
          radius_provider_groups = { for v in sort(keys(aci_radius_provider_group.radius_provider_groups)
          ) : v => aci_radius_provider_group.radius_provider_groups[v].id }
          rsa_providers = { for v in sort(keys(aci_rsa_provider.rsa_providers)
          ) : v => aci_rsa_provider.rsa_providers[v].id }
        }
        tacacs = {
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
    }
    security = {
      for v in sort(keys(aci_global_security.security)) : v => aci_global_security.security[v].id
    }
  }
}

/*_____________________________________________________________________________________________________________________

External Data Collectors — Outputs
_______________________________________________________________________________________________________________________
*/
output "external_data_collectors" {
  description = <<-EOT
    Identifiers for:
      smart_callhome:
        * destination_groups: Admin => External Data Collectors => Monitoring Destinations => Smart Callhome: {Name}.
        * destination_group_properties: Admin => External Data Collectors => Monitoring Destinations => Smart Callhome: {Name} => Properties.
        * destinations: Admin => External Data Collectors => Monitoring Destinations => Smart Callhome: {Name} => Smart Destination.
        * smtp_server: Admin => External Data Collectors => Monitoring Destinations => Smart Callhome: {Name} => Properties.
        * source: Fabric => Fabric Policies => Policies => Monitoring => Common Policies => Callhome/Smart Callhome/SNMP/Syslog/TACACS: Smart Callhome.
      syslog:
        * destination_groups: Admin => External Data Collectors => Monitoring Destinations => Syslog: {Name}.
        * remote_destinations: Admin => External Data Collectors => Monitoring Destinations => Syslog: {Name} => Syslog Remote Destination.
        * sources: Fabric => Fabric Policies => Policies => Monitoring => Common Policies => Callhome/Smart Callhome/SNMP/Syslog/TACACS: Syslog.
  EOT
  value = {
    smart_callhome = {
      destination_groups = { for v in sort(keys(aci_rest_managed.smart_callhome_destination_groups)
      ) : v => aci_rest_managed.smart_callhome_destination_groups[v].id }
      destination_group_properties = { for v in sort(
        keys(aci_rest_managed.smart_callhome_destination_group_properties)
      ) : v => aci_rest_managed.smart_callhome_destination_group_properties[v].id }
      smtp_server = { for v in sort(keys(aci_rest_managed.smart_callhome_smtp_server)
      ) : v => aci_rest_managed.smart_callhome_smtp_server[v].id }
      destinations = { for v in sort(keys(aci_rest_managed.smart_callhome_destinations)
      ) : v => aci_rest_managed.smart_callhome_destinations[v].id }
      source = { for v in sort(keys(aci_rest_managed.smart_callhome_source)
      ) : v => aci_rest_managed.smart_callhome_source[v].id }
    }
    syslog = {
      destination_groups = { for v in sort(keys(aci_rest_managed.syslog_destination_groups)
      ) : v => aci_rest_managed.syslog_destination_groups[v].id }
      remote_destinations = { for v in sort(keys(aci_rest_managed.syslog_remote_destinations)
      ) : v => aci_rest_managed.syslog_remote_destinations[v].id }
      sources = { for v in sort(keys(aci_rest_managed.syslog_sources)
      ) : v => aci_rest_managed.syslog_sources[v].id }

    }
  }
}

/*_____________________________________________________________________________________________________________________

Firmware Management — Outputs
_______________________________________________________________________________________________________________________
*/
output "firmware" {
  description = <<-EOT
    Identifiers for:
      firmware:
        switches:
          firmware_group: Admin => Firmware => Switches: Firmware Updates {Update Group Name}
          firmware_group_nodes:  Admin => Firmware => Switches: Firmware Updates {Update Group Name}
          firmware_policy:  Admin => Firmware => Switches: Firmware Updates {Update Group Name}
          maintenance_group:  Admin => Firmware => Switches: Firmware Updates {Update Group Name}
          maintenance_group_nodes:  Admin => Firmware => Switches: Firmware Updates {Update Group Name}
          maintenance_policy: Admin => Firmware => Switches: Firmware Updates {Update Group Name}
  EOT
  value = {
    switches = {
      firmware_group = { for v in sort(keys(aci_rest_managed.firmware_group)) : v => aci_rest_managed.firmware_group[v].id }
      firmware_group_nodes = { for v in sort(keys(aci_rest_managed.firmware_group_nodes)
      ) : v => aci_rest_managed.firmware_group_nodes[v].id }
      maintenance_group = { for v in sort(keys(aci_pod_maintenance_group.map)) : v => aci_pod_maintenance_group.map[v].id }
      maintenance_group_nodes = { for v in sort(keys(aci_maintenance_group_node.map)
      ) : v => aci_maintenance_group_node.map[v].id }
      maintenance_policy = { for v in sort(keys(aci_rest_managed.maintenance_policy)
      ) : v => aci_rest_managed.maintenance_policy[v].id }
    }
  }

}

/*_____________________________________________________________________________________________________________________

Import/Export — Outputs
_______________________________________________________________________________________________________________________
*/
output "import_export" {
  description = <<-EOT
    Identifiers for:
      * configuration_export: Admin => Import/Export => Export Policies => Configuration.
      * recurring_window: Admin => Schedulers => Fabric => {schedule_name} => Recurring Windows.
      * remote_locations: Admin => Import/Export => Remote Locations.
      * schedulers: Admin => Schedulers => Fabric.
  EOT
  value = {
    configuration_export = { for v in sort(keys(aci_configuration_export_policy.map)
    ) : v => aci_configuration_export_policy.map[v].id }
    recurring_window = { for v in sort(keys(aci_recurring_window.map)
    ) : v => aci_recurring_window.map[v].id }
    remote_locations = { for v in sort(keys(aci_file_remote_path.map)
    ) : v => aci_file_remote_path.map[v].id }
    schedulers = { for v in sort(keys(aci_trigger_scheduler.map)
    ) : v => aci_trigger_scheduler.map[v].id }
  }
}
