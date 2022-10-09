locals {
  admin    = lookup(var.model, "admin", {})
  defaults = lookup(var.model, "defaults", {})

  configuration_export = {
    for i in flatten([
      for value in lookup(local.admin, "configuration_backups", []) : [
        for v in lookup(value, "configuration_export", []) : [
          for s in v.remote_hosts : {
            annotation = lookup(
            v, "annotation", local.defaults.annotation)
            authentication_type = lookup(
              v, "authentication_type", local.defaults.admin.configuration_backups.configuration_export.authentication_type
            )
            description = lookup(
              v, "description", local.defaults.admin.configuration_backups.configuration_export.description
            )
            format = lookup(
              v, "format", local.defaults.admin.configuration_backups.configuration_export.format
            )
            include_secure_fields = lookup(
              v, "include_secure_fields", local.defaults.admin.configuration_backups.configuration_export.include_secure_fields
            )
            management_epg = lookup(
              v, "management_epg", local.defaults.admin.configuration_backups.configuration_export.management_epg
            )
            management_epg_type = lookup(
              v, "management_epg_type", local.defaults.admin.configuration_backups.configuration_export.management_epg_type
            )
            max_snapshot_count = lookup(
              v, "max_snapshot_count", local.defaults.admin.configuration_backups.configuration_export.max_snapshot_count
            )
            password = lookup(
              v, "password", local.defaults.admin.configuration_backups.configuration_export.password
            )
            protocol = lookup(
              v, "protocol", local.defaults.admin.configuration_backups.configuration_export.protocol
            )
            name        = value.name
            remote_host = s
            remote_path = lookup(
              v, "remote_path", local.defaults.admin.configuration_backups.configuration_export.remote_path
            )
            remote_port = lookup(
              v, "remote_port", local.defaults.admin.configuration_backups.configuration_export.remote_port
            )
            snapshot = lookup(
              v, "snapshot", local.defaults.admin.configuration_backups.configuration_export.snapshot
            )
            start_now = lookup(
              v, "start_now", local.defaults.admin.configuration_backups.configuration_export.start_now
            )
            username = lookup(
              v, "username", local.defaults.admin.configuration_backups.configuration_export.username
            )
          }
        ]
      ]
    ]) : i.remote_host => i
  }
  recurring_window = {
    for i in flatten([
      for value in lookup(local.admin, "configuration_backups", []) : [
        for v in lookup(value, "recurring_window", []) : {
          annotation = lookup(
          v, "annotation", local.defaults.annotation)
          delay_between_node_upgrades = lookup(
            v, "delay_between_node_upgrades", local.defaults.admin.configuration_backups.recurring_window.delay_between_node_upgrades
          )
          description = lookup(
            v, "description", local.defaults.admin.configuration_backups.recurring_window.description
          )
          maximum_concurrent_nodes = lookup(
            v, "maximum_concurrent_nodes", local.defaults.admin.configuration_backups.recurring_window.maximum_concurrent_nodes
          )
          maximum_running_time = lookup(
            v, "maximum_running_time", local.defaults.admin.configuration_backups.recurring_window.maximum_running_time
          )
          name = value.name
          processing_break = lookup(
            v, "processing_break", local.defaults.admin.configuration_backups.recurring_window.processing_break
          )
          processing_size_capacity = lookup(
            v, "processing_size_capacity", local.defaults.admin.configuration_backups.recurring_window.processing_size_capacity
          )
          schedule = {
            days = lookup(
              lookup(v, "schedule", local.defaults.admin.configuration_backups.recurring_window.schedule
              ), "days", local.defaults.admin.configuration_backups.recurring_window.schedule.days
            )
            hour = lookup(
              lookup(v, "schedule", local.defaults.admin.configuration_backups.recurring_window.schedule
              ), "hour", local.defaults.admin.configuration_backups.recurring_window.schedule.hour
            )
            minute = lookup(
              lookup(v, "schedule", local.defaults.admin.configuration_backups.recurring_window.schedule
              ), "minute", local.defaults.admin.configuration_backups.recurring_window.schedule.minute
            )
          }
          window_type = lookup(v, "window_type", local.defaults.admin.configuration_backups.recurring_window.window_type)
        }
      ]
    ]) : i.name => i
  }

  radius_providers = {
    for i in flatten([
      for v in lookup(local.admin, "radius", []) : [
        for value in lookup(v, "radius_providers", []) : {
          annotation = lookup(v, "annotation", local.defaults.annotation)
          authorization_protocol = lookup(
            value, "authorization_protocol", local.defaults.admin.radius.authorization_protocol
          )
          host                = value.host
          management_epg      = lookup(value, "management_epg", local.defaults.management_epg)
          management_epg_type = lookup(value, "management_epg_type", local.defaults.management_epg_type)
          login_domain        = v.login_domain
          order               = value.order
          password = lookup(
            lookup(v, "server_monitoring", local.defaults.admin.radius.server_monitoring
            ), "password", local.defaults.admin.radius.server_monitoring.password
          )
          port       = lookup(v, "port", local.defaults.admin.radius.port)
          radius_key = value.key
          retries    = lookup(v, "retries", local.defaults.admin.radius.retries)
          server_monitoring = lookup(
            lookup(v, "server_monitoring", local.defaults.admin.radius.server_monitoring
            ), "admin_state", local.defaults.admin.radius.server_monitoring.admin_state
          )
          timeout = lookup(v, "timeout", local.defaults.admin.radius.timeout)
          type    = lookup(v, "type", local.defaults.admin.radius.type)
          username = lookup(
            lookup(v, "server_monitoring", local.defaults.admin.radius.server_monitoring
            ), "username", local.defaults.admin.radius.server_monitoring.username
          )
        }
      ]
    ]) : i.host => i
  }

  tacacs_providers = {
    for i in flatten([
      for v in lookup(local.admin, "tacacs", []) : [
        for value in lookup(v, "tacacs_providers", []) : {
          annotation = lookup(v, "annotation", local.defaults.annotation)
          authorization_protocol = lookup(
            value, "authorization_protocol", local.defaults.admin.tacacs.authorization_protocol
          )
          host                = value.host
          management_epg      = lookup(value, "management_epg", local.defaults.management_epg)
          management_epg_type = lookup(value, "management_epg_type", local.defaults.management_epg_type)
          login_domain        = v.login_domain
          order               = value.order
          password = lookup(
            lookup(v, "server_monitoring", local.defaults.admin.tacacs.server_monitoring
            ), "password", local.defaults.admin.tacacs.server_monitoring.password
          )
          port    = lookup(v, "port", local.defaults.admin.tacacs.port)
          retries = lookup(v, "retries", local.defaults.admin.tacacs.retries)
          server_monitoring = lookup(
            lookup(v, "server_monitoring", local.defaults.admin.tacacs.server_monitoring
            ), "admin_state", local.defaults.admin.tacacs.server_monitoring.admin_state
          )
          tacacs_key = value.key
          timeout    = lookup(v, "timeout", local.defaults.admin.tacacs.timeout)
          username = lookup(
            lookup(v, "server_monitoring", local.defaults.admin.tacacs.server_monitoring
            ), "username", local.defaults.admin.tacacs.server_monitoring.username
          )
        }
      ]
    ]) : i.host => i
  }
}