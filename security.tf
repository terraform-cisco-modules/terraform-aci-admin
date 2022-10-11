/*_____________________________________________________________________________________________________________________

API Information:
 - Classes: "aaaPwdProfile", "aaaUserEp", "pkiWebTokenData"
 - Distinguished Name: "uni/userext"
GUI Location:
 - Admin > AAA > Security
_______________________________________________________________________________________________________________________
*/
resource "aci_global_security" "security" {
  for_each   = { for v in lookup(local.aaa, "security", []) : "default" => v }
  annotation = lookup(each.value, "annotation", local.defaults.annotation)
  block_duration = lookup(lookup(
    each.value, "lockout_user", local.security.lockout_user
  ), "lockout_duration", local.security.lockout_user.lockout_duration)
  change_count = lookup(
    each.value, "password_changes_within_interval", local.security.password_changes_within_interval
  )
  change_during_interval = lookup(
    each.value, "password_change_interval_enforce", local.security.password_change_interval_enforce
  )
  change_interval = lookup(
    each.value, "password_change_interval", local.security.password_change_interval
  )
  enable_login_block = lookup(lookup(
    each.value, "lockout_user", local.security.lockout_user
  ), "enable_lockout", local.security.lockout_user.enable_lockout)
  expiration_warn_time = lookup(
    each.value, "password_expiration_warn_time", local.security.password_expiration_warn_time
  )
  history_count = lookup(
    each.value, "user_passwords_to_store_count", local.security.user_passwords_to_store_count
  )
  no_change_interval = lookup(
    each.value, "no_change_interval", local.security.password_change_interval
  )
  max_failed_attempts = lookup(lookup(
    each.value, "lockout_user", local.security.lockout_user
  ), "max_failed_attempts", local.security.lockout_user.max_failed_attempts)
  max_failed_attempts_window = lookup(lookup(
    each.value, "lockout_user", local.security.lockout_user
  ), "max_failed_attempts_window", local.security.lockout_user.max_failed_attempts_window)
  maximum_validity_period = lookup(
    each.value, "maximum_validity_period", local.security.maximum_validity_period
  )
  pwd_strength_check = lookup(
    each.value, "password_strength_check", local.security.password_strength_check
  ) == true ? "yes" : "no"
  session_record_flags = ["login", "logout", "refresh"]
  ui_idle_timeout_seconds = lookup(
    each.value, "web_session_idle_timeout", local.security.web_session_idle_timeout
  )
  webtoken_timeout_seconds = lookup(
    each.value, "web_token_timeout", local.security.web_token_timeout
  )
}
