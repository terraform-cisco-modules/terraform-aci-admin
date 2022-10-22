/*_____________________________________________________________________________________________________________________

Model Data from Top Level Module
_______________________________________________________________________________________________________________________
*/
variable "model" {
  description = "Model data."
  type        = any
}


/*_____________________________________________________________________________________________________________________

Global Shared Variables
_______________________________________________________________________________________________________________________
*/


variable "annotation" {
  default     = "orchestrator:terraform:easy-aci-v2.0"
  description = "The Version of this Script."
  type        = string
}

variable "annotations" {
  default = [
    {
      key   = "orchestrator"
      value = "terraform:easy-aci:v2.0"
    }
  ]
  description = "The Version of this Script."
  type = list(object(
    {
      key   = string
      value = string
    }
  ))
}

variable "management_epgs" {
  default = [
    {
      name = "default"
      type = "oob"
    }
  ]
  description = <<-EOT
    The Management EPG's that will be used by the script.
    - name: Name of the EPG
    - type: Type of EPG
      * inb
      * oob
  EOT
  type = list(object(
    {
      name = string
      type = string
    }
  ))
}


/*_____________________________________________________________________________________________________________________

Admin > AAA > Authentication: RADIUS — Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "radius_key" {
  default     = ""
  description = "RADIUS Key."
  sensitive   = true
  type        = string
}

variable "radius_monitoring_password" {
  default     = ""
  description = "RADIUS Monitoring Password."
  sensitive   = true
  type        = string
}


/*_____________________________________________________________________________________________________________________

Admin > AAA > Authentication: TACACS+ — Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "tacacs_key" {
  default     = ""
  description = "TACACS Key."
  sensitive   = true
  type        = string
}

variable "tacacs_monitoring_password" {
  default     = ""
  description = "TACACS Monitoring Password."
  sensitive   = true
  type        = string
}

/*_____________________________________________________________________________________________________________________

Admin > External Data Collectors > Monitoring Destinations > Smart CallHome: {policy_name} — Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "smtp_password" {
  default     = ""
  description = "Password to use if Secure SMTP is enabled for the Smart CallHome Destination Group Mail Server."
  sensitive   = true
  type        = string
}

/*_____________________________________________________________________________________________________________________

Admin > Import/Export > Remote Locations
_______________________________________________________________________________________________________________________
*/
variable "remote_password" {
  default     = ""
  description = "Remote Host Password."
  sensitive   = true
  type        = string
}

variable "ssh_key_contents" {
  default     = ""
  description = "SSH Private Key Based Authentication Contents."
  sensitive   = true
  type        = string
}

variable "ssh_key_passphrase" {
  default     = ""
  description = "SSH Private Key Based Authentication Passphrase."
  sensitive   = true
  type        = string
}
