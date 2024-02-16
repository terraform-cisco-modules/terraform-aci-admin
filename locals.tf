locals {
  aaa       = lookup(var.admin, "aaa", {})
  defaults  = yamldecode(file("${path.module}/defaults.yaml")).defaults.admin
  export    = lookup(var.admin, "import_export", {})
  ext_data  = lookup(var.admin, "external_data_collectors", {})
  mgmt_epgs = var.admin.global_settings.management_epgs
  security  = lookup(local.aaa, "security", {})

  #__________________________________________________________
  #
  # AAA => Authentication => Authentication Default Settings
  #__________________________________________________________
  auth     = lookup(lookup(var.admin, "aaa", {}), "authentication", {})
  AUTH_SET = local.defaults.aaa.authentication.authentication_default_settings
  auth_set = lookup(local.auth, "authentication_default_settings", {})
  console  = local.AUTH_SET.console_authentication
  console_authentication = length(local.auth) > 0 ? {
    "default" : merge({ create = true }, local.console, lookup(local.auth_set, "console_authentication", {})) } : {
    "default" : merge({ create = false }, local.console)
  }
  default = local.AUTH_SET.default_authentication
  default_authentication = length(local.auth) > 0 ? {
    "default" : merge({ create = true }, local.default, lookup(local.auth_set, "default_authentication", {})) } : {
    "default" : merge({ create = false }, local.default)
  }
  remote = local.AUTH_SET.remote_authentication
  remote_authentication = length(local.auth) > 0 ? {
    "default" : merge({ create = true }, local.remote, lookup(local.auth_set, "remote_authentication", {})) } : {
    "default" : merge({ create = false }, local.remote)
  }


  #__________________________________________________________
  #
  # AAA => Authentication => Providers: RADIUS
  #__________________________________________________________
  RADIUS = local.defaults.aaa.authentication.radius
  radius = {
    for v in lookup(local.auth, "radius", []) : v.login_domain => merge(local.RADIUS, v, {
      mgmt_epg_type = local.mgmt_epgs[index(local.mgmt_epgs[*].name,
        lookup(v, "management_epg", local.RADIUS.management_epg))
      ].type
      server_monitoring = merge(local.TACACS.server_monitoring, lookup(v, "server_monitoring", {}))
    })
  }
  radius_providers = { for i in flatten([
    for v in local.radius : [
      for s in range(length(v.hosts)) : merge(v, {
        host  = element(v.hosts, s)
        order = s
      })
    ]
  ]) : i.host => i }
  radius_list     = [for k, v in local.radius : v]
  rproviders_list = [for k, v in local.radius_providers : v]


  #__________________________________________________________
  #
  # AAA => Authentication => Providers: TACACS+
  #__________________________________________________________

  TACACS = local.defaults.aaa.authentication.tacacs
  tacacs = {
    for v in lookup(local.auth, "tacacs", []) : v.login_domain => merge(local.TACACS, v, {
      accounting_include = merge(local.TACACS.accounting_include, lookup(v, "accounting_include", {}))
      mgmt_epg_type = local.mgmt_epgs[index(local.mgmt_epgs[*].name,
        lookup(v, "management_epg", local.TACACS.management_epg))
      ].type
      server_monitoring = merge(local.TACACS.server_monitoring, lookup(v, "server_monitoring", {}))
      type              = "tacacs"
    })
  }
  tacacs_providers = { for i in flatten([
    for v in local.tacacs : [
      for s in range(length(v.hosts)) : merge(v, {
        host  = element(v.hosts, s)
        order = s
      })
    ]
  ]) : i.host => i }
  tacacs_list     = [for k, v in local.tacacs : v]
  tproviders_list = [for k, v in local.tacacs_providers : v]

  login_domains   = concat(local.radius_list, local.tacacs_list)
  login_providers = concat(local.rproviders_list, local.tproviders_list)
  #__________________________________________________________
  #
  # AAA => Security: Security Default Settings
  #__________________________________________________________
  sec_defaults = local.defaults.aaa.security.security_default_settings
  security_default_settings = {
    for v in [lookup(local.security, "security_default_settings", {})] : "default" => merge(
      local.sec_defaults, v,
      { lockout_user = merge(local.sec_defaults.lockout_user, lookup(v, "lockout_user", {})) }
    )
  }

  #__________________________________________________________
  #
  # AAA => Security: Certificate Authorities and Key Rings
  #__________________________________________________________
  certkeyrings = local.defaults.aaa.security.certificate_authorities_and_key_rings
  certificate_authorities_and_key_rings = {
  for v in lookup(local.security, "certificate_authorities_and_key_rings", []) : v.name => merge(local.certkeyrings, v) }

  #__________________________________________________________
  #
  # External Data Collectors => Monitoring Destinations => Smart CallHome
  #__________________________________________________________
  scallhome = local.defaults.external_data_collectors.smart_callhome
  smart_callhome = {
    for v in lookup(local.ext_data, "smart_callhome", []) : v.name => {
      admin_state = lookup(v, "admin_state", local.scallhome.admin_state)
      contact_information = lookup(v, "contact_information", lookup(
        v, "customer_contact_email", local.scallhome.customer_contact_email)
      )
      contract_id = lookup(v, "contract_id", local.scallhome.contract_id)
      customer_contact_email = lookup(
        v, "customer_contact_email", local.scallhome.customer_contact_email
      )
      customer_id = lookup(v, "customer_id", local.scallhome.customer_id)
      description = lookup(v, "description", local.scallhome.description)
      from_email = lookup(v, "from_email", lookup(
        v, "customer_contact_email", local.scallhome.customer_contact_email)
      )
      phone_contact = lookup(v, "phone_contact", local.scallhome.phone_contact)
      reply_to_email = lookup(v, "reply_to_email", lookup(
        v, "customer_contact_email", local.scallhome.customer_contact_email)
      )
      site_id            = lookup(v, "site_id", local.scallhome.site_id)
      smart_destinations = lookup(v, "smart_destinations", [])
      smtp_server = {
        management_epg = lookup(lookup(
        v, "smtp_server", {}), "management_epg", local.scallhome.smtp_server.management_epg)
        mgmt_epg_type = local.mgmt_epgs[index(local.mgmt_epgs[*].name,
          lookup(lookup(v, "smtp_server", {}
        ), "management_epg", local.scallhome.smtp_server.management_epg))].type
        port_number = lookup(lookup(
        v, "smtp_server", {}), "port_number", local.scallhome.smtp_server.port_number)
        secure_smtp = length(compact(
          [lookup(lookup(v, "smtp_server", {}), "username", local.scallhome.smtp_server.username)]
        )) > 0 ? true : false
        smtp_server = lookup(lookup(v, "smtp_server", {}
        ), "host", local.scallhome.smtp_server.username)
        username = lookup(lookup(
        v, "smtp_server", {}), "username", local.scallhome.smtp_server.username)
      }
      street_address = lookup(v, "street_address", local.scallhome.street_address)
    }
  }
  smart_callhome_destinations = { for i in flatten([
    for key, value in local.smart_callhome : [
      for k, v in value.smart_destinations : {
        admin_state   = lookup(v, "admin_state", local.scallhome.smart_destinations.admin_state)
        email         = v.email
        format        = lookup(v, "format", local.scallhome.smart_destinations.format)
        policy        = key
        name          = element(split("@", v.email), 0)
        rfc_compliant = lookup(v, "rfc_compliant", local.scallhome.smart_destinations.rfc_compliant)
      }
    ]
  ]) : "${i.policy}/${i.name}" => i }


  #__________________________________________________________
  #
  # External Data Collectors => Monitoring Destinations => Syslog
  #__________________________________________________________
  SYSLOG = local.defaults.external_data_collectors.syslog
  syslog = {
    for v in lookup(local.ext_data, "syslog", []) : v.name => {
      admin_state = lookup(v, "admin_state", local.SYSLOG.admin_state)
      description = lookup(v, "description", local.SYSLOG.description)
      console_destination = {
        admin_state = lookup(lookup(v, "console_destination", {}
        ), "admin_state", local.SYSLOG.console_destination.admin_state)
        severity = lookup(lookup(v, "console_destination", {}
        ), "severity", local.SYSLOG.console_destination.severity)
      }
      format = lookup(v, "format", local.SYSLOG.format)
      include_types = {
        audit_logs = lookup(lookup(v, "include_types", {}
        ), "audit_logs", local.SYSLOG.include_types.audit_logs)
        events = lookup(lookup(v, "include_types", {}
        ), "events", local.SYSLOG.include_types.events)
        faults = lookup(lookup(v, "include_types", {}
        ), "faults", local.SYSLOG.include_types.faults)
        session_logs = lookup(lookup(v, "include_types", {}
        ), "session_logs", local.SYSLOG.include_types.session_logs)
      }
      local_file_destination = {
        admin_state = lookup(lookup(v, "local_file_destination", {}
        ), "admin_state", local.SYSLOG.local_file_destination.admin_state)
        severity = lookup(lookup(v, "local_file_destination", {}
        ), "severity", local.SYSLOG.local_file_destination.severity)
      }
      min_severity        = lookup(v, "min_severity", local.SYSLOG.min_severity)
      remote_destinations = lookup(v, "remote_destinations", local.SYSLOG.remote_destinations)
      show_milliseconds_in_timestamp = lookup(
        v, "show_milliseconds_in_timestamp", local.SYSLOG.show_milliseconds_in_timestamp
      )
      show_time_zone_in_timestamp = lookup(
        v, "show_time_zone_in_timestamp", local.SYSLOG.show_time_zone_in_timestamp
      )
    }
  }
  syslog_destinations = flatten([
    for key, value in local.syslog : [
      for v in value.remote_destinations : {
        admin_state         = lookup(v, "admin_state", local.SYSLOG.remote_destinations.admin_state)
        forwarding_facility = lookup(v, "forwarding_facility", local.SYSLOG.remote_destinations.forwarding_facility)
        hosts               = v.hosts
        management_epg      = lookup(v, "management_epg", local.SYSLOG.remote_destinations.management_epg)
        mgmt_epg_type = local.mgmt_epgs[index(local.mgmt_epgs[*].name,
          lookup(v, "management_epg", local.SYSLOG.remote_destinations.management_epg))
        ].type
        port          = lookup(v, "port", local.SYSLOG.remote_destinations.port)
        severity      = lookup(v, "severity", local.SYSLOG.remote_destinations.severity)
        transport     = lookup(v, "transport", local.SYSLOG.remote_destinations.transport)
        syslog_policy = key
      }
    ]
  ])
  syslog_remote_destinations = { for i in flatten([
    for v in local.syslog_destinations : [
      for s in v.hosts : {
        admin_state         = v.admin_state
        forwarding_facility = v.forwarding_facility
        host                = s
        management_epg      = v.management_epg
        mgmt_epg_type       = v.mgmt_epg_type
        port                = v.port
        severity            = v.severity
        transport           = v.transport
        syslog_policy       = v.syslog_policy
      }
    ]
  ]) : "${i.syslog_policy}/${i.host}" => i }


  #__________________________________________________________
  #
  # Firmware => Switches => Firmware Update Groups
  #__________________________________________________________
  fw_sw                  = lookup(lookup(var.admin, "firmware", {}), "switches", {})
  fwug                   = local.defaults.firmware.switches.firmware_update_groups
  firmware_update_groups = { for v in lookup(local.fw_sw, "firmware_update_groups", []) : v.name => merge(local.fwug, v) }
  firmware_update_nodes = { for i in flatten([
    for k, v in local.firmware_update_groups : [
      for e in v.nodes : {
        firmware_group = k
        node_id        = e
      }
    ]
  ]) : "${i.firmware_group}/${i.node_id}" => i }


  #__________________________________________________________
  #
  # Import/Export => Configuration Backups
  #__________________________________________________________
  config    = local.defaults.import_export.configuration_backups
  scheduler = local.defaults.import_export.schedulers
  remote_locations = { for i in flatten([
    for v in lookup(local.export, "configuration_backups", []) : [
      for e in lookup(v, "remote_locations") : merge(local.config, v, {
        export_policy = merge(local.config.export_policy, lookup(v, "export_policy", {}))
        description   = lookup(e, "description", "")
        host          = e.host
        mgmt_epg_type = local.mgmt_epgs[index(local.mgmt_epgs[*].name,
          lookup(v, "management_epg", local.config.management_epg))
        ].type
      })
    ]
  ]) : i.host => i }

  export_policies = { for i in flatten([
    for k, v in local.remote_locations : [
      for e in [v.export_policy] : merge(e, {
        description    = v.description
        host           = v.host
        scheduler_name = v.scheduler_name
      })
    ]
  ]) : i.host => i }

  schedulers = {
    for v in lookup(local.export, "schedulers", []) : v.name => {
      description = lookup(v, "description", "")
      name        = v.name
      windows     = lookup(v, "windows", [])
    }
  }

  scheduler_windows = flatten([
    for k, v in local.schedulers : [
      for e in v.windows : merge(local.scheduler.windows, e, {
        scheduler = k
        schedule  = merge(local.scheduler.windows.schedule, lookup(e, "schedule", {}))
      })
    ]
  ])

}
