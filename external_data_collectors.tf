/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "callhomeSmartGroup"
 - Distinguished Name: "uni/fabric/smartgroup-{name}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > Smart Callhome > [Smart CallHome Dest Group]
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "smart_callhome_destination_groups" {
  for_each   = local.smart_callhome
  class_name = "callhomeSmartGroup"
  dn         = "uni/fabric/smartgroup-${each.key}"
  content = {
    descr = each.value.description
    name  = each.key
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "callhomeProf"
 - Distinguished Name: "uni/fabric/smartgroup-{name}/prof"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > Smart Callhome > [Smart CallHome Dest Group]
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "smart_callhome_destination_group_properties" {
  for_each   = local.smart_callhome
  class_name = "callhomeProf"
  dn         = "uni/fabric/smartgroup-${each.key}/prof"
  content = {
    addr       = each.value.street_address
    adminState = each.value.admin_state
    contract   = each.value.contract_id
    contact    = each.value.contact_information
    customer   = each.value.customer_id
    email      = each.value.customer_contact_email
    from       = each.value.from_email
    replyTo    = each.value.reply_to_email
    phone      = each.value.phone_contact
    port       = each.value.smtp_server.port_number
    pwd        = each.value.smtp_server.secure_smtp == true ? var.smtp_password : ""
    secureSmtp = each.value.smtp_server.secure_smtp == true ? "yes" : "no"
    site       = each.value.site_id
    username   = each.value.smtp_server.username
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "callhomeSmtpServer"
 - Distinguished Name: "uni/fabric/smartgroup-{name}/prof/smtp"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > Smart Callhome > [Smart CallHome Dest Group]
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "smart_callhome_smtp_server" {
  depends_on = [
    aci_rest_managed.smart_callhome_destination_groups
  ]
  for_each   = local.smart_callhome
  class_name = "callhomeSmtpServer"
  dn         = "uni/fabric/smartgroup-${each.key}/prof/smtp"
  content = {
    host = each.value.smtp_server.smtp_server
  }
  child {
    rn         = "rsARemoteHostToEpg"
    class_name = "fileRsARemoteHostToEpg"
    content = {
      tDn = "uni/tn-mgmt/mgmtp-default/${each.value.smtp_server.mgmt_epg_type}-${each.value.smtp_server.management_epg}"
    }
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "callhomeSmartDest"
 - Distinguished Name: "uni/fabric/smartgroup-{name}/smartdest-{destionation_group}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > Smart Callhome > {destionation_group}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "smart_callhome_destinations" {
  depends_on = [
    aci_rest_managed.smart_callhome_destination_groups
  ]
  for_each   = local.smart_callhome_destinations
  class_name = "callhomeSmartDest"
  dn         = "uni/fabric/smartgroup-${each.value.policy}/smartdest-${each.value.name}"
  content = {
    adminState   = each.value.admin_state
    email        = each.value.email
    format       = each.value.format
    name         = each.value.name
    rfcCompliant = each.value.rfc_compliant == true ? "yes" : "no"
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "callhomeSmartSrc"
 - Distinguished Name: "uni/infra/moninfra-default/smartchsrc"
GUI Location:
 - Fabric > Fabric Policies > Policies > Monitoring > Common Policies > Callhome/Smart Callhome/SNMP/Syslog/TACACS:Smart CallHome > Create Smart CallHome Source
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "smart_callhome_source" {
  depends_on = [
    aci_rest_managed.smart_callhome_destination_groups
  ]
  for_each   = local.smart_callhome
  dn         = "uni/fabric/moncommon/smartchsrc"
  class_name = "callhomeSmartSrc"
  content = {
    # incl = alltrue(
    #   [
    #     each.value.include_types[0].audit_logs,
    #     each.value.include_types[0].events,
    #     each.value.include_types[0].faults,
    #     each.value.include_types[0].session_logs
    #   ]
    #   ) ? "all" : anytrue(
    #   [
    #     each.value.include_types[0].audit_logs,
    #     each.value.include_types[0].events,
    #     each.value.include_types[0].faults,
    #     each.value.include_types[0].session_logs
    #   ]
    #   ) ? replace(trim(join(",", concat([
    #     length(regexall(true, each.value.include_types[0].audit_logs)) > 0 ? "audit" : ""], [
    #     length(regexall(true, each.value.include_types[0].events)) > 0 ? "events" : ""], [
    #     length(regexall(true, each.value.include_types[0].faults)) > 0 ? "faults" : ""], [
    #     length(regexall(true, each.value.include_types[0].session_logs)) > 0 ? "session" : ""]
    # )), ","), ",,", ",") : "none"
  }
  child {
    rn         = "rssmartdestGroup"
    class_name = "callhomeRsSmartdestGroup"
    content = {
      tDn = "uni/fabric/smartgroup-${each.key}"
    }
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "syslogGroup"
 - Distinguished Name: "uni/fabric/slgroup-{name}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > Syslog > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "syslog_destination_groups" {
  for_each   = local.syslog
  class_name = "syslogGroup"
  dn         = "uni/fabric/slgroup-${each.key}"
  content = {
    descr               = each.value.description
    format              = each.value.format
    includeMilliSeconds = each.value.show_milliseconds_in_timestamp == true ? "yes" : "no"
    includeTimeZone     = each.value.show_time_zone_in_timestamp == true ? "yes" : "no"
    name                = each.key
  }
  child {
    rn         = "console"
    class_name = "syslogConsole"
    content = {
      adminState = each.value.console_destination.admin_state
      severity   = each.value.console_destination.severity
    }
  }
  child {
    rn         = "file"
    class_name = "syslogFile"
    content = {
      adminState = each.value.local_file_destination.admin_state
      severity   = each.value.local_file_destination.severity
    }
  }
  child {
    rn         = "prof"
    class_name = "syslogProf"
    content = {
      adminState = each.value.admin_state
      # port      = each.value.port
      # transport = each.value.transport
    }
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "syslogRemoteDest"
 - Distinguished Name: " uni/fabric/slgroup-default/rdst-{destination_group}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > Syslog > {destination_group}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "syslog_remote_destinations" {
  depends_on = [
    aci_rest_managed.syslog_destination_groups
  ]
  for_each   = local.syslog_remote_destinations
  class_name = "syslogRemoteDest"
  dn         = "uni/fabric/slgroup-${each.value.syslog_policy}/rdst-${each.value.host}"
  content = {
    adminState         = each.value.admin_state
    forwardingFacility = each.value.forwarding_facility
    host               = each.value.host
    name               = each.value.host
    port               = each.value.port
    # protocol           = each.value.transport
    severity = each.value.severity
  }
  child {
    rn         = "rsARemoteHostToEpg"
    class_name = "fileRsARemoteHostToEpg"
    content = {
      tDn = "uni/tn-mgmt/mgmtp-default/${each.value.mgmt_epg_type}-${each.value.management_epg}"
    }
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "syslogSrc"
 - Distinguished Name: "uni/fabric/moncommon/slsrc-{Dest_Grp_Name}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Monitoring > Common Policies > 
   Callhome/Smart Callhome/SNMP/Syslog/TACACS:Syslog > Create Syslog Source
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "syslog_sources" {
  depends_on = [
    aci_rest_managed.syslog_destination_groups
  ]
  for_each   = local.syslog
  class_name = "syslogSrc"
  dn         = "uni/fabric/moncommon/slsrc-${each.key}"
  content = {
    incl = alltrue(
      [
        each.value.include_types.audit_logs,
        each.value.include_types.events,
        each.value.include_types.faults,
        each.value.include_types.session_logs
      ]
      ) ? "all,audit,events,faults,session" : anytrue(
      [
        each.value.include_types.audit_logs,
        each.value.include_types.events,
        each.value.include_types.faults,
        each.value.include_types.session_logs
      ]
      ) ? replace(trim(join(",", concat([
        length(regexall(true, each.value.include_types.audit_logs)) > 0 ? "audit" : ""], [
        length(regexall(true, each.value.include_types.events)) > 0 ? "events" : ""], [
        length(regexall(true, each.value.include_types.faults)) > 0 ? "faults" : ""], [
        length(regexall(true, each.value.include_types.session_logs)) > 0 ? "session" : ""]
    )), ","), ",,", ",") : "none"
    minSev = each.value.min_severity
    name   = each.key
  }
  child {
    rn         = "rsdestGroup"
    class_name = "syslogRsDestGroup"
    content = {
      tDn = "uni/fabric/slgroup-${each.key}"
    }
  }
}
