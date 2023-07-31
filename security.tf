/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "pkiTP"
 - Distinguished Name: "uni/userext/pkiext/tp-{{name}}"
GUI Location:
 - Admin > AAA > Security: Certificate Authorities
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "certificate_authorities" {
  for_each = {
    for k, v in local.certificate_authorities_and_key_rings : v.trustpoint => v if length(regexall("[1-2]", v.var_identity)) > 0
  }
  class_name = "pkiTP"
  dn         = "uni/userext/pkiext/tp-${each.key}"
  content = {
    certChain = length(regexall("1", each.value.var_identity)
      ) > 0 ? "${var.apic_ca_certificate_chain_1}" : length(
      regexall("2", each.value.var_identity)
    ) > 0 ? "${var.apic_ca_certificate_chain_2}" : ""
    descr = each.value.trustpoint_description
    name  = each.key
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "pkiTP"
 - Distinguished Name: "uni/userext/pkiext/keyring-{{name}}"
GUI Location:
 - Admin > AAA > Security: Key Rings
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "key_rings" {
  for_each   = { for k, v in local.certificate_authorities_and_key_rings : k => v if length(regexall("[1-2]", v.var_identity)) > 0 }
  class_name = "pkiKeyRing"
  dn         = "uni/userext/pkiext/keyring-${each.key}"
  content = {
    adminState = "completed"
    cert = length(regexall("1", each.value.var_identity)
      ) > 0 ? "${var.apic_certificate_1}" : length(
      regexall("2", each.value.var_identity)
    ) > 0 ? "${var.apic_certificate_2}" : ""
    descr = each.value.description
    key = length(regexall("1", each.value.var_identity)
      ) > 0 ? "${var.apic_private_key_1}" : length(
      regexall("2", each.value.var_identity)
    ) > 0 ? "${var.apic_private_key_2}" : ""
    modulus = "mod${each.value.modulus}"
    name    = each.value.name
    regen   = "no"
    tp      = each.value.trustpoint
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "commRsKeyRing"
 - Distinguished Name: "uni/fabric/comm-default/https/rsKeyRing"
GUI Location:
 - Admin > AAA > Security: Key Rings
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "key_ring_operational" {
  for_each   = { for k, v in local.certificate_authorities_and_key_rings : k => v if v.activate_certificate == true }
  class_name = "commRsKeyRing"
  dn         = "uni/fabric/comm-default/https/rsKeyRing"
  content = {
    tnPkiKeyRingName = each.key
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Classes: "aaaPwdProfile", "aaaUserEp", "pkiWebTokenData"
 - Distinguished Name: "uni/userext"
GUI Location:
 - Admin > AAA > Security
_______________________________________________________________________________________________________________________
*/
resource "aci_global_security" "security" {
  for_each                   = local.security_default_settings
  block_duration             = each.value.lockout_user.lockout_duration
  change_count               = each.value.password_changes_within_interval
  change_during_interval     = each.value.password_change_interval_enforce
  change_interval            = each.value.password_change_interval
  enable_login_block         = each.value.lockout_user.enable_lockout
  expiration_warn_time       = each.value.password_expiration_warn_time
  history_count              = each.value.user_passwords_to_store_count
  no_change_interval         = each.value.password_change_interval
  max_failed_attempts        = each.value.lockout_user.max_failed_attempts
  max_failed_attempts_window = each.value.lockout_user.max_failed_attempts_window
  maximum_validity_period    = each.value.maximum_validity_period
  pwd_strength_check         = each.value.password_strength_check == true ? "yes" : "no"
  session_record_flags       = ["login", "logout", "refresh"]
  ui_idle_timeout_seconds    = each.value.web_session_idle_timeout
  webtoken_timeout_seconds   = each.value.web_token_timeout
}
