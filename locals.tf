locals {
  admin    = lookup(var.model, "admin", {})
  defaults = lookup(var.model, "defaults", {})

  configuration_backups = {
    for v in lookup(local.admin, "configuration_backups", []) : v.name => {
      annotation = lookup(v, "annotation", local.defaults.annotation)
      authentication_type = length(compact([var.ssh_key_contents, var.ssh_key_contents])
      ) > 0 ? "useSshKeyContents" : "usePassword"
      description = lookup(v, "description", local.defaults.admin.configuration_backups.description)
      format      = lookup(v, "format", local.defaults.admin.configuration_backups.format)
      include_secure_fields = lookup(
        v, "include_secure_fields", local.defaults.admin.configuration_backups.include_secure_fields
      )
      management_epg = lookup(v, "management_epg", local.defaults.admin.configuration_backups.management_epg)
      mgmt_epg_type = local.defaults.management_epgs[index(local.defaults.management_epgs.*.name,
        lookup(v, "management_epg", local.defaults.admin.configuration_backups.management_epg))
      ].type
      max_snapshot_count = lookup(v, "max_snapshot_count", local.defaults.admin.configuration_backups.max_snapshot_count)
      protocol           = lookup(v, "protocol", local.defaults.admin.configuration_backups.protocol)
      name               = v.name
      remote_hosts       = lookup(v, "remote_hosts", local.defaults.admin.configuration_backups.remote_hosts)
      remote_path        = lookup(v, "remote_path", local.defaults.admin.configuration_backups.remote_path)
      remote_port        = lookup(v, "remote_port", local.defaults.admin.configuration_backups.remote_port)
      snapshot           = lookup(v, "snapshot", local.defaults.admin.configuration_backups.snapshot)
      start_now          = lookup(v, "start_now", local.defaults.admin.configuration_backups.start_now)
      username           = lookup(v, "username", local.defaults.admin.configuration_backups.username)
      # Trigger Scheduler and Recurring Window
      delay_between_node_upgrades = lookup(
        v, "delay_between_node_upgrades", local.defaults.admin.configuration_backups.delay_between_node_upgrades
      )
      maximum_concurrent_nodes = lookup(
        v, "maximum_concurrent_nodes", local.defaults.admin.configuration_backups.maximum_concurrent_nodes
      )
      maximum_running_time = lookup(
        v, "maximum_running_time", local.defaults.admin.configuration_backups.maximum_running_time
      )
      name = v.name
      processing_break = lookup(
      v, "processing_break", local.defaults.admin.configuration_backups.processing_break)
      processing_size_capacity = lookup(
      v, "processing_size_capacity", local.defaults.admin.configuration_backups.processing_size_capacity)
      schedule = {
        days = lookup(lookup(v, "schedule", local.defaults.admin.configuration_backups.schedule
          ), "days", local.defaults.admin.configuration_backups.schedule.days
        )
        hour = lookup(lookup(v, "schedule", local.defaults.admin.configuration_backups.schedule
          ), "hour", local.defaults.admin.configuration_backups.schedule.hour
        )
        minute = lookup(lookup(v, "schedule", local.defaults.admin.configuration_backups.schedule
          ), "minute", local.defaults.admin.configuration_backups.schedule.minute
        )
      }
      window_type = lookup(v, "window_type", local.defaults.admin.configuration_backups.window_type)
    }
  }
  remote_locations = {
    for i in flatten([
      for v in local.configuration_backups : [
        for s in v.remote_hosts : {
          annotation            = v.annotation
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
    ]) : i.remote_host => i
  }

  radius = {
    for v in lookup(local.admin, "radius", []) : v.login_domain => {
      annotation             = lookup(v, "annotation", local.defaults.annotation)
      authorization_protocol = lookup(v, "authorization_protocol", local.defaults.admin.radius.authorization_protocol)
      hosts                  = lookup(v, "hosts", local.defaults.admin.radius.hosts)
      management_epg         = lookup(v, "management_epg", local.defaults.admin.radius.management_epg)
      mgmt_epg_type = local.defaults.management_epgs[index(local.defaults.management_epgs.*.name,
        lookup(v, "management_epg", local.defaults.admin.radius.management_epg))
      ].type
      login_domain = v.login_domain
      port         = lookup(v, "port", local.defaults.admin.radius.port)
      retries      = lookup(v, "retries", local.defaults.admin.radius.retries)
      server_monitoring = {
        admin_state = lookup(
          lookup(v, "server_monitoring", local.defaults.admin.radius.server_monitoring
          ), "admin_state", local.defaults.admin.radius.server_monitoring.admin_state
        )
        username = lookup(
          lookup(v, "server_monitoring", local.defaults.admin.radius.server_monitoring
          ), "username", local.defaults.admin.radius.server_monitoring.username
        )
      }
      timeout = lookup(v, "timeout", local.defaults.admin.radius.timeout)
      type    = lookup(v, "type", local.defaults.admin.radius.type)
    }
  }
  radius_providers = {
    for i in flatten([
      for v in local.radius : [
        for s in range(length(v.hosts)) : {
          annotation             = v.annotation
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
    ]) : i.host => i
  }

  tacacs = {
    for v in lookup(local.admin, "tacacs", []) : v.login_domain => {
      accounting_include = [
        for i in lookup(v, "accounting_include", local.defaults.admin.tacacs.accounting_include) : {
          audit_logs = lookup(
            lookup(v, "accounting_include", local.defaults.admin.tacacs.accounting_include
            ), "audit_logs", local.defaults.admin.tacacs.accounting_include.audit_logs
          )
          events = lookup(
            lookup(v, "accounting_include", local.defaults.admin.tacacs.accounting_include
            ), "events", local.defaults.admin.tacacs.accounting_include.events
          )
          faults = lookup(
            lookup(v, "accounting_include", local.defaults.admin.tacacs.accounting_include
            ), "faults", local.defaults.admin.tacacs.accounting_include.faults
          )
          session_logs = lookup(
            lookup(v, "accounting_include", local.defaults.admin.tacacs.accounting_include
            ), "session_logs", local.defaults.admin.tacacs.accounting_include.session_logs
          )
        }
      ]
      annotation             = lookup(v, "annotation", local.defaults.annotation)
      authorization_protocol = lookup(v, "authorization_protocol", local.defaults.admin.tacacs.authorization_protocol)
      hosts                  = lookup(v, "hosts", local.defaults.admin.tacacs.hosts)
      management_epg         = lookup(v, "management_epg", local.defaults.admin.tacacs.management_epg)
      mgmt_epg_type = local.defaults.management_epgs[index(local.defaults.management_epgs.*.name,
        lookup(v, "management_epg", local.defaults.admin.tacacs.management_epg))
      ].type
      login_domain = v.login_domain
      port         = lookup(v, "port", local.defaults.admin.tacacs.port)
      retries      = lookup(v, "retries", local.defaults.admin.tacacs.retries)
      server_monitoring = {
        admin_state = lookup(
          lookup(v, "server_monitoring", local.defaults.admin.tacacs.server_monitoring
          ), "admin_state", local.defaults.admin.tacacs.server_monitoring.admin_state
        )
        username = lookup(
          lookup(v, "server_monitoring", local.defaults.admin.tacacs.server_monitoring
          ), "username", local.defaults.admin.tacacs.server_monitoring.username
        )
      }
      timeout = lookup(v, "timeout", local.defaults.admin.tacacs.timeout)
    }
  }
  tacacs_providers = {
    for i in flatten([
      for v in local.tacacs : [
        for s in range(length(v.hosts)) : {
          annotation             = v.annotation
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
        }
      ]
    ]) : i.host => i
  }
}