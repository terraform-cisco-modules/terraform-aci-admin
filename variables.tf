/*_____________________________________________________________________________________________________________________

Model Data from Top Level Module
_______________________________________________________________________________________________________________________
*/
variable "admin" {
  description = "Model data."
  type        = any
}


/*_____________________________________________________________________________________________________________________

Admin Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "admin_sensitive" {
  default = {
    configuration_backup = {
      password               = {}
      private_key            = {}
      private_key_passphrase = {}
    }
    radius = {
      key      = {}
      password = {}
    }
    security = {
      ca_certificate = {}
      certificate    = {}
      private_key    = {}
    }
    smart_callhome = {
      password = {}
    }
    tacacs = {
      key      = {}
      password = {}
    }
  }
  description = <<EOT
    Note: Sensitive Variables cannot be added to a for_each loop so these are added seperately.
    * mcp_instance_policy_default: MisCabling Protocol Instance Settings.
      - key: The key or password used to uniquely identify this configuration object.
    * virtual_networking: ACI to Virtual Infrastructure Integration.
      - password: Username/Password combination to Authenticate to the Virtual Infrastructure.
  EOT
  sensitive   = true
  type = object({
    configuration_backup = object({
      password               = map(string)
      private_key            = map(string)
      private_key_passphrase = map(string)
    })
    radius = object({
      key      = map(string)
      password = map(string)
    })
    security = object({
      ca_certificate = map(string)
      certificate    = map(string)
      private_key    = map(string)
    })
    tacacs = object({
      key      = map(string)
      password = map(string)
    })
  })
}
