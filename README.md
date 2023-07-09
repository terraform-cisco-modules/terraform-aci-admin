<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)

# Terraform ACI - Admin Module

A Terraform module to configure ACI Admin Policies.

This module is part of the Cisco [*Intersight as Code*](https://cisco.com/go/intersightascode) project. Its goal is to allow users to instantiate network fabrics in minutes using an easy to use, opinionated data model. It takes away the complexity of having to deal with references, dependencies or loops. By completely separating data (defining variables) from logic (infrastructure declaration), it allows the user to focus on describing the intended configuration while using a set of maintained and tested Terraform Modules without the need to understand the low-level Intersight object model.

A comprehensive example using this module is available here: https://github.com/terraform-cisco-modules/easy-aci-complete

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.9.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | 2.9.0 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin"></a> [admin](#input\_admin) | Model data. | `any` | n/a | yes |
| <a name="input_annotations"></a> [annotations](#input\_annotations) | The Version of this Script. | <pre>list(object(<br>    {<br>      key   = string<br>      value = string<br>    }<br>  ))</pre> | <pre>[<br>  {<br>    "key": "orchestrator",<br>    "value": "terraform:easy-aci:v2.0"<br>  }<br>]</pre> | no |
| <a name="input_management_epgs"></a> [management\_epgs](#input\_management\_epgs) | The Management EPG's that will be used by the script.<br>- name: Name of the EPG<br>- type: Type of EPG<br>  * inb<br>  * oob | <pre>list(object(<br>    {<br>      name = string<br>      type = string<br>    }<br>  ))</pre> | <pre>[<br>  {<br>    "name": "default",<br>    "type": "oob"<br>  }<br>]</pre> | no |
| <a name="input_radius_key"></a> [radius\_key](#input\_radius\_key) | RADIUS Key. | `string` | `""` | no |
| <a name="input_radius_monitoring_password"></a> [radius\_monitoring\_password](#input\_radius\_monitoring\_password) | RADIUS Monitoring Password. | `string` | `""` | no |
| <a name="input_tacacs_key"></a> [tacacs\_key](#input\_tacacs\_key) | TACACS Key. | `string` | `""` | no |
| <a name="input_tacacs_monitoring_password"></a> [tacacs\_monitoring\_password](#input\_tacacs\_monitoring\_password) | TACACS Monitoring Password. | `string` | `""` | no |
| <a name="input_smtp_password"></a> [smtp\_password](#input\_smtp\_password) | Password to use if Secure SMTP is enabled for the Smart CallHome Destination Group Mail Server. | `string` | `""` | no |
| <a name="input_remote_password"></a> [remote\_password](#input\_remote\_password) | Remote Host Password. | `string` | `""` | no |
| <a name="input_ssh_key_contents"></a> [ssh\_key\_contents](#input\_ssh\_key\_contents) | SSH Private Key Based Authentication Contents. | `string` | `""` | no |
| <a name="input_ssh_key_passphrase"></a> [ssh\_key\_passphrase](#input\_ssh\_key\_passphrase) | SSH Private Key Based Authentication Passphrase. | `string` | `""` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aaa"></a> [aaa](#output\_aaa) | Identifiers for:<br>  authentication:<br>    authentication\_default\_settings:<br>      * console\_authentication: Admin => AAA => Authentication: Authentication Default Settings: Console Authentication.<br>      * default\_authentication: Admin => AAA => Authentication: Authentication Default Settings: Default Authentication.<br>      * remote\_authentication:  Admin => AAA => Authentication: Authentication Default Settings: Remote Authentication.<br>    login\_domains:  Admin => AAA => Authentication: Authentication Default Settings: Login Domains<br>    login\_domain\_providers: Admin => AAA => Authentication: Authentication Default Settings: Providers<br>    providers:<br>      radius:<br>        * duo\_provider\_groups:  Admin => AAA => Authentication: Providers.<br>        * radius\_providers:  Admin => AAA => Authentication: Providers.<br>        * radius\_provider\_groups:  Admin => AAA => Authentication: Providers.<br>        * rsa\_providers:  Admin => AAA => Authentication: Providers.<br>      tacacs:<br>        * tacacs\_accounting: Admin => External Data Collectors => Monitoring Destinations => TACACS: {Name}.<br>        * tacacs\_accounting\_destinations: Admin => External Data Collectors => Monitoring Destinations => TACACS: {Name} => TACACS Destinations.<br>        * tacacs\_providers: Admin => AAA => Authentication: Providers.<br>        * tacacs\_provider\_groups: Admin => AAA => Authentication: Providers.<br>        * tacacs\_sources: Fabric => Fabric Policies => Policies => Monitoring => Common Policies => Callhome/Smart Callhome/SNMP/Syslog/TACACS: TACACS.<br>    security: Admin => AAA => Security. |
| <a name="output_external_data_collectors"></a> [external\_data\_collectors](#output\_external\_data\_collectors) | Identifiers for:<br>  smart\_callhome:<br>    * destination\_groups: Admin => External Data Collectors => Monitoring Destinations => Smart Callhome: {Name}.<br>    * destination\_group\_properties: Admin => External Data Collectors => Monitoring Destinations => Smart Callhome: {Name} => Properties.<br>    * destinations: Admin => External Data Collectors => Monitoring Destinations => Smart Callhome: {Name} => Smart Destination.<br>    * smtp\_server: Admin => External Data Collectors => Monitoring Destinations => Smart Callhome: {Name} => Properties.<br>    * source: Fabric => Fabric Policies => Policies => Monitoring => Common Policies => Callhome/Smart Callhome/SNMP/Syslog/TACACS: Smart Callhome.<br>  syslog:<br>    * destination\_groups: Admin => External Data Collectors => Monitoring Destinations => Syslog: {Name}.<br>    * remote\_destinations: Admin => External Data Collectors => Monitoring Destinations => Syslog: {Name} => Syslog Remote Destination.<br>    * sources: Fabric => Fabric Policies => Policies => Monitoring => Common Policies => Callhome/Smart Callhome/SNMP/Syslog/TACACS: Syslog. |
| <a name="output_firmware"></a> [firmware](#output\_firmware) | Identifiers for:<br>Identifiers for:<br>  firmware:<br>    switches:<br>      firmware\_group: Admin => Firmware => Switches: Firmware Updates {Update Group Name}<br>      firmware\_group\_nodes:  Admin => Firmware => Switches: Firmware Updates {Update Group Name}<br>      firmware\_policy:  Admin => Firmware => Switches: Firmware Updates {Update Group Name}<br>      maintenance\_group:  Admin => Firmware => Switches: Firmware Updates {Update Group Name}<br>      maintenance\_group\_nodes:  Admin => Firmware => Switches: Firmware Updates {Update Group Name}<br>      maintenance\_policy: Admin => Firmware => Switches: Firmware Updates {Update Group Name} |
| <a name="output_import_export"></a> [import\_export](#output\_import\_export) | Identifiers for:<br>  * configuration\_export: Admin => Import/Export => Export Policies => Configuration.<br>  * recurring\_window: Admin => Schedulers => Fabric => {schedule\_name} => Recurring Windows.<br>  * remote\_locations: Admin => Import/Export => Remote Locations.<br>  * schedulers: Admin => Schedulers => Fabric. |
## Resources

| Name | Type |
|------|------|
| [aci_authentication_properties.remote_authentication](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/authentication_properties) | resource |
| [aci_configuration_export_policy.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/configuration_export_policy) | resource |
| [aci_console_authentication.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/console_authentication) | resource |
| [aci_default_authentication.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/default_authentication) | resource |
| [aci_duo_provider_group.duo_provider_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/duo_provider_group) | resource |
| [aci_file_remote_path.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/file_remote_path) | resource |
| [aci_global_security.security](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/global_security) | resource |
| [aci_login_domain.login_domains](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/login_domain) | resource |
| [aci_login_domain_provider.login_domain_providers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/login_domain_provider) | resource |
| [aci_maintenance_group_node.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/maintenance_group_node) | resource |
| [aci_pod_maintenance_group.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/pod_maintenance_group) | resource |
| [aci_radius_provider.radius_providers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/radius_provider) | resource |
| [aci_radius_provider_group.radius_provider_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/radius_provider_group) | resource |
| [aci_recurring_window.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/recurring_window) | resource |
| [aci_rest_managed.firmware_group](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.firmware_group_nodes](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.firmware_policy](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.maintenance_policy](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.smart_callhome_destination_group_properties](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.smart_callhome_destination_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.smart_callhome_destinations](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.smart_callhome_smtp_server](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.smart_callhome_source](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.syslog_destination_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.syslog_remote_destinations](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.syslog_sources](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rsa_provider.rsa_providers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rsa_provider) | resource |
| [aci_tacacs_accounting.tacacs_accounting](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/tacacs_accounting) | resource |
| [aci_tacacs_accounting_destination.tacacs_accounting_destinations](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/tacacs_accounting_destination) | resource |
| [aci_tacacs_provider.tacacs_providers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/tacacs_provider) | resource |
| [aci_tacacs_provider_group.tacacs_provider_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/tacacs_provider_group) | resource |
| [aci_tacacs_source.tacacs_sources](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/tacacs_source) | resource |
| [aci_trigger_scheduler.map](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/trigger_scheduler) | resource |
<!-- END_TF_DOCS -->