locals {
  defaults = yamldecode(file("${path.module}/defaults.yaml")).defaults.admin
  config   = local.defaults.import_export.configuration_backups
  export   = lookup(var.admin, "import_export", {})
  ext_data = lookup(var.admin, "external_data_collectors", {})

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
  RADIUS  = local.defaults.aaa.authentication.radius
  radius1 = lookup(local.auth, "radius", {})
  radius = {
    for v in lookup(local.auth, "radius", []) : v.login_domain => {
      authorization_protocol = lookup(v, "authorization_protocol", local.RADIUS.authorization_protocol)
      hosts                  = v.hosts
      management_epg         = lookup(v, "management_epg", local.RADIUS.management_epg)
      mgmt_epg_type = var.management_epgs[index(var.management_epgs.*.name,
        lookup(v, "management_epg", local.RADIUS.management_epg))
      ].type
      login_domain = v.login_domain
      port         = lookup(v, "port", local.RADIUS.port)
      retries      = lookup(v, "retries", local.RADIUS.retries)
      server_monitoring = {
        admin_state = lookup(lookup(v, "server_monitoring", {}
        ), "admin_state", local.RADIUS.server_monitoring.admin_state)
        username = lookup(lookup(v, "server_monitoring", {}
        ), "username", local.RADIUS.server_monitoring.username)
      }
      timeout = lookup(v, "timeout", local.RADIUS.timeout)
      type    = lookup(v, "type", local.RADIUS.type)
    }
  }
  radius_providers = { for i in flatten([
    for v in local.radius : [
      for s in range(length(v.hosts)) : {
        authorization_protocol = v.authorization_protocol
        host                   = element(v.hosts, s)
        management_epg         = v.management_epg
        mgmt_epg_type          = v.mgmt_epg_type
        login_domain           = v.login_domain
        order                  = s
        port                   = v.port
        retries                = v.retries
        server_monitoring      = v.server_monitoring
        timeout                = v.timeout
        type                   = v.type
      }
    ]
  ]) : i.host => i }
  radius_list     = [for k, v in local.radius : v]
  rproviders_list = [for k, v in local.radius_providers : v]


  #__________________________________________________________
  #
  # AAA => Authentication => Providers: TACACS+
  #__________________________________________________________

  TACACS   = local.defaults.aaa.authentication.tacacs
  tac_plus = lookup(local.auth, "tacacs", {})
  tacacs = {
    for v in lookup(local.auth, "tacacs", []) : v.login_domain => {
      accounting_include = {
        audit_logs = lookup(lookup(v, "accounting_include", {}
        ), "audit_logs", local.TACACS.accounting_include.audit_logs)
        events = lookup(lookup(v, "accounting_include", {}
        ), "events", local.TACACS.accounting_include.events)
        faults = lookup(lookup(v, "accounting_include", {}
        ), "faults", local.TACACS.accounting_include.faults)
        session_logs = lookup(lookup(v, "accounting_include", {}
        ), "session_logs", local.TACACS.accounting_include.session_logs)
      }
      authorization_protocol = lookup(v, "authorization_protocol", local.TACACS.authorization_protocol)
      hosts                  = lookup(v, "hosts", local.TACACS.hosts)
      management_epg         = lookup(v, "management_epg", local.TACACS.management_epg)
      mgmt_epg_type = var.management_epgs[index(var.management_epgs.*.name,
        lookup(v, "management_epg", local.TACACS.management_epg))
      ].type
      login_domain = v.login_domain
      port         = lookup(v, "port", local.TACACS.port)
      retries      = lookup(v, "retries", local.TACACS.retries)
      server_monitoring = {
        admin_state = lookup(lookup(v, "server_monitoring", {}
        ), "admin_state", local.TACACS.server_monitoring.admin_state)
        username = lookup(lookup(v, "server_monitoring", {}
        ), "username", local.TACACS.server_monitoring.username)
      }
      timeout = lookup(v, "timeout", local.TACACS.timeout)
      type    = "tacacs"
    }
  }
  tacacs_providers = { for i in flatten([
    for v in local.tacacs : [
      for s in range(length(v.hosts)) : {
        authorization_protocol = v.authorization_protocol
        host                   = element(v.hosts, s)
        management_epg         = v.management_epg
        mgmt_epg_type          = v.mgmt_epg_type
        login_domain           = v.login_domain
        order                  = s
        port                   = v.port
        retries                = v.retries
        server_monitoring      = v.server_monitoring
        timeout                = v.timeout
        type                   = "tacacs"
      }
    ]
  ]) : i.host => i }
  tacacs_list     = [for k, v in local.tacacs : v]
  tproviders_list = [for k, v in local.tacacs_providers : v]

  login_domains   = concat(local.radius_list, local.tacacs_list)
  login_providers = concat(local.rproviders_list, local.tproviders_list)
  #__________________________________________________________
  #
  # AAA => Security
  #__________________________________________________________
  sec = local.defaults.aaa.security
  security = length(lookup(var.admin, "aaa", {})) > 0 ? {
    "default" : merge({ create = true }, local.sec, lookup(lookup(var.admin, "aaa", {}), "security", {})) } : {
    "default" : merge({ create = false }, local.sec)
  }

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
        mgmt_epg_type = var.management_epgs[index(var.management_epgs.*.name,
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
  ]) : "${i.policy}:${i.name}" => i }


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
        mgmt_epg_type = var.management_epgs[index(var.management_epgs.*.name,
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
  ]) : "${i.syslog_policy}:${i.host}" => i }


  #__________________________________________________________
  #
  # Firmware => Switches => Firmware Update Groups
  #__________________________________________________________
  fw_sw = lookup(lookup(var.admin, "firmware", {}), "switches", {})
  fwug  = local.defaults.firmware.switches.firmware_update_groups
  firmware_update_groups = {
    for v in lookup(local.fw_sw, "firmware_update_groups", []) : v.name => {
      administrative_state        = lookup(v, "administrative_state ", local.fwug.administrative_state)
      description                 = lookup(v, "description", local.fwug.description)
      download_state              = lookup(v, "download_state", local.fwug.download_state)
      effective_on_reboot         = lookup(v, "effective_on_reboot ", local.fwug.effective_on_reboot)
      graceful_maintenance        = lookup(v, "graceful_maintenance ", local.fwug.graceful_maintenance)
      ignore_compatibility        = lookup(v, "ignore_compatibility ", local.fwug.ignore_compatibility)
      name                        = v.name
      nodes                       = v.nodes
      notification_condition      = lookup(v, "notification_condition ", local.fwug.notification_condition)
      scheduler_run_mode          = lookup(v, "scheduler_run_mode", local.fwug.scheduler_run_mode)
      silent_role_package_upgrade = lookup(v, "silent_role_package_upgrade", local.fwug.silent_role_package_upgrade)
      silent_role_package_version = lookup(v, "silent_role_package_version", local.fwug.silent_role_package_version)
      smu_operation_flags         = lookup(v, "smu_operation_flags  ", local.fwug.smu_operation_flags)
      smu_operation_type          = lookup(v, "smu_operation_type", local.fwug.smu_operation_type)
      target_simulator            = lookup(v, "target_simulator", local.fwug.target_simulator)
      target_version              = v.target_version
      version_check_override      = lookup(v, "version_check_override", local.fwug.version_check_override)
    }
  }
  firmware_update_nodes = { for i in flatten([
    for k, v in local.firmware_update_groups : [
      for e in v.nodes : {
        firmware_group = k
        node_id        = e
      }
    ]
  ]) : "${i.firmware_group}:${i.node_id}" => i }


  #__________________________________________________________
  #
  # Import/Export => Configuration Backups
  #__________________________________________________________
  configuration_backups = {
    for v in lookup(local.export, "configuration_backups", []) : v.name => {
      authentication_type = length(compact([var.ssh_key_contents, var.ssh_key_contents])
      ) > 0 ? "useSshKeyContents" : "usePassword"
      description = lookup(v, "description", local.config.description)
      format      = lookup(v, "format", local.config.format)
      include_secure_fields = lookup(
        v, "include_secure_fields", local.config.include_secure_fields
      )
      management_epg = lookup(v, "management_epg", local.config.management_epg)
      mgmt_epg_type = var.management_epgs[index(var.management_epgs.*.name,
        lookup(v, "management_epg", local.config.management_epg))
      ].type
      max_snapshot_count = lookup(v, "max_snapshot_count", local.config.max_snapshot_count)
      protocol           = lookup(v, "protocol", local.config.protocol)
      name               = v.name
      remote_hosts       = lookup(v, "remote_hosts", local.config.remote_hosts)
      remote_path        = lookup(v, "remote_path", local.config.remote_path)
      remote_port        = lookup(v, "remote_port", local.config.remote_port)
      snapshot           = lookup(v, "snapshot", local.config.snapshot)
      start_now          = lookup(v, "start_now", local.config.start_now)
      username           = lookup(v, "username", local.config.username)
      # Trigger Scheduler and Recurring Window
      delay_between_node_upgrades = lookup(
        v, "delay_between_node_upgrades", local.config.delay_between_node_upgrades
      )
      maximum_concurrent_nodes = lookup(
        v, "maximum_concurrent_nodes", local.config.maximum_concurrent_nodes
      )
      maximum_running_time = lookup(v, "maximum_running_time", local.config.maximum_running_time)
      name                 = v.name
      processing_break     = lookup(v, "processing_break", local.config.processing_break)
      processing_size_capacity = lookup(
        v, "processing_size_capacity", local.config.processing_size_capacity
      )
      schedule = {
        days   = lookup(lookup(v, "schedule", {}), "days", local.config.schedule.days)
        hour   = lookup(lookup(v, "schedule", {}), "hour", local.config.schedule.hour)
        minute = lookup(lookup(v, "schedule", {}), "minute", local.config.schedule.minute)
      }
      window_type = lookup(v, "window_type", local.config.window_type)
    }
  }
  remote_locations = { for i in flatten([
    for v in local.configuration_backups : [
      for s in v.remote_hosts : {
        authentication_type   = v.authentication_type
        description           = v.description
        format                = v.format
        include_secure_fields = v.include_secure_fields
        management_epg        = v.management_epg
        mgmt_epg_type         = v.mgmt_epg_type
        max_snapshot_count    = v.max_snapshot_count
        protocol              = v.protocol
        name                  = v.name
        remote_host           = s
        remote_path           = v.remote_path
        remote_port           = v.remote_port
        snapshot              = v.snapshot
        start_now             = v.start_now
        username              = v.username
      }
    ]
  ]) : i.remote_host => i }


}
