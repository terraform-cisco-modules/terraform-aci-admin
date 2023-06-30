/*_____________________________________________________________________________________________________________________

API Information:
 - Classes: "aaaPwdProfile", "aaaUserEp", "pkiWebTokenData"
 - Distinguished Name: "uni/userext"
GUI Location:
 - Admin > AAA > Security
_______________________________________________________________________________________________________________________
*/
resource "aci_global_security" "security" {
  for_each                   = { for k, v in local.security : k => v if tostring(v.create) == "true" }
  annotation                 = each.value.annotation != "" ? each.value.annotation : var.annotation
  block_duration             = lookup(each.value.lockout_user, "lockout_duration", local.sec.lockout_user.lockout_duration)
  change_count               = each.value.password_changes_within_interval
  change_during_interval     = each.value.password_change_interval_enforce
  change_interval            = each.value.password_change_interval
  enable_login_block         = lookup(each.value.lockout_user, "enable_lockout", local.sec.lockout_user.enable_lockout)
  expiration_warn_time       = each.value.password_expiration_warn_time
  history_count              = each.value.user_passwords_to_store_count
  no_change_interval         = each.value.password_change_interval
  max_failed_attempts        = lookup(each.value.lockout_user, "max_failed_attempts", local.sec.lockout_user.max_failed_attempts)
  max_failed_attempts_window = lookup(each.value.lockout_user, "max_failed_attempts_window", local.sec.lockout_user.max_failed_attempts_window)
  maximum_validity_period    = each.value.maximum_validity_period
  pwd_strength_check         = each.value.password_strength_check == true ? "yes" : "no"
  session_record_flags       = ["login", "logout", "refresh"]
  ui_idle_timeout_seconds    = each.value.web_session_idle_timeout
  webtoken_timeout_seconds   = each.value.web_token_timeout
}
