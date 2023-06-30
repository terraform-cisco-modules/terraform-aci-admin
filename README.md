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
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.8.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.8.0 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_model"></a> [model](#input\_model) | Model data. | `any` | n/a | yes |
| <a name="input_annotation"></a> [annotation](#input\_annotation) | The Version of this Script. | `string` | `"orchestrator:terraform:easy-aci-v2.0"` | no |
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
| <a name="output_aaa-authentication-default_settings-console_authentication"></a> [aaa-authentication-default\_settings-console\_authentication](#output\_aaa-authentication-default\_settings-console\_authentication) | Identifiers for Console Authentication.  Admin => AAA => Authentication: Authentication Default Settings: => Console Authentication. |
| <a name="output_aaa-authentication-default_settings-default_authentication"></a> [aaa-authentication-default\_settings-default\_authentication](#output\_aaa-authentication-default\_settings-default\_authentication) | Identifiers for Default Authentication.  Admin => AAA => Authentication: Authentication Default Settings: Console Authentication. |
| <a name="output_aaa-authentication-default_settings-remote_authentication"></a> [aaa-authentication-default\_settings-remote\_authentication](#output\_aaa-authentication-default\_settings-remote\_authentication) | Identifiers for Remote Authentication.  Admin => AAA => Authentication: Authentication Default Settings: Remote Authentication. |
| <a name="output_aaa-authentication-login_domains"></a> [aaa-authentication-login\_domains](#output\_aaa-authentication-login\_domains) | * login\_domains - Identifiers for Login Domains.  Admin => AAA => Authentication: Login Domains.<br>* login\_domain\_providers - Identifiers for VMM Controllers.  Admin => AAA => Authentication: Providers. |
| <a name="output_aaa-authentication-radius"></a> [aaa-authentication-radius](#output\_aaa-authentication-radius) | * duo\_provider\_groups - Identifiers for Duo Radius Provider Groups.  Admin => AAA => Authentication: Providers.<br>* radius\_providers - Identifiers for Radius Providers.  Admin => AAA => Authentication: Providers.<br>* radius\_provider\_groups - Identifiers for Radius Provider Groups.  Admin => AAA => Authentication: Providers.<br>* rsa\_providers - Identifiers for Radius RSA Providers.  Admin => AAA => Authentication: Providers. |
| <a name="output_aaa-authentication-tacacs"></a> [aaa-authentication-tacacs](#output\_aaa-authentication-tacacs) | * tacacs\_accounting - Identifiers for TACACS Accounting.  Admin => External Data Collectors => Monitoring Destinations => TACACS: {Name}.<br>* tacacs\_accounting\_destinations - Identifiers for TACACS Accounting Destinations.    Admin => External Data Collectors => Monitoring Destinations => TACACS: {Name} => TACACS Destinations.<br>* tacacs\_providers - Identifiers for TACACS Providers.  Admin => AAA => Authentication: Providers.<br>* tacacs\_provider\_groups - Identifiers for TACACS Provider Groups.  Admin => AAA => Authentication: Providers.<br>* tacacs\_sources - Identifiers for TACACS Sources.  Fabric => Fabric Policies => Policies => Monitoring => Common Policies => Callhome/Smart Callhome/SNMP/Syslog/TACACS: TACACS. |
| <a name="output_aaa-security"></a> [aaa-security](#output\_aaa-security) | Identifiers for Global Security Policy.  Admin => AAA => Security. |
| <a name="output_external_data_collectors-smart_callhome"></a> [external\_data\_collectors-smart\_callhome](#output\_external\_data\_collectors-smart\_callhome) | * smart\_callhome\_destination\_groups - Identifiers for Smart Callhome Destination Groups.  Admin => External Data Collectors => Monitoring Destinations => Smart Callhome: {Name}.<br>* smart\_callhome\_destination\_group\_properties - Identifiers for Smart Callhome Destination Groups Properties.  Admin => External Data Collectors => Monitoring Destinations => Smart Callhome: {Name} => Properties.<br>* smart\_callhome\_destinations - Identifiers for Smart Callhome Destinations.  Admin => External Data Collectors => Monitoring Destinations => Smart Callhome: {Name} => Smart Destination.<br>* smart\_callhome\_smtp\_server - Identifiers for Smart Callhome SMTP Server.  Admin => External Data Collectors => Monitoring Destinations => Smart Callhome: {Name} => Properties.<br>* smart\_callhome\_source - Identifiers for Smart Callhome Sources.  Fabric => Fabric Policies => Policies => Monitoring => Common Policies => Callhome/Smart Callhome/SNMP/Syslog/TACACS: Smart Callhome. |
| <a name="output_external_data_collectors-syslog"></a> [external\_data\_collectors-syslog](#output\_external\_data\_collectors-syslog) | * syslog\_destination\_groups - Identifiers for Syslog Destination Groups.  Admin => External Data Collectors => Monitoring Destinations => Syslog: {Name}.<br>* syslog\_remote\_destinations - Identifiers for Syslog Destinations.  Admin => External Data Collectors => Monitoring Destinations => Syslog: {Name} => Syslog Remote Destination.<br>* syslog\_sources - Identifiers for Syslog Sources.  Fabric => Fabric Policies => Policies => Monitoring => Common Policies => Callhome/Smart Callhome/SNMP/Syslog/TACACS: Syslog. |
| <a name="output_import_export-configuration_backups"></a> [import\_export-configuration\_backups](#output\_import\_export-configuration\_backups) | * configuration\_export - Identifiers for Configuration Export.  Admin => Import/Export => Export Policies => Configuration.<br>* recurring\_window - Identifiers for Recurring Windows.  Admin => Schedulers => Fabric => {schedule\_name} => Recurring Windows.<br>* remote\_locations - Identifiers for Remote Locations.  Admin => Import/Export => Remote Locations.<br>* schedulers - Identifiers for Schedulers.  Admin => Schedulers => Fabric. |
## Resources

| Name | Type |
|------|------|
| [aci_authentication_properties.remote_authentication](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/authentication_properties) | resource |
| [aci_configuration_export_policy.configuration_export](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/configuration_export_policy) | resource |
| [aci_console_authentication.console_authentication](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/console_authentication) | resource |
| [aci_default_authentication.default_authentication](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/default_authentication) | resource |
| [aci_duo_provider_group.duo_provider_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/duo_provider_group) | resource |
| [aci_file_remote_path.remote_locations](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/file_remote_path) | resource |
| [aci_global_security.security](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/global_security) | resource |
| [aci_login_domain.login_domains](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/login_domain) | resource |
| [aci_login_domain_provider.login_domain_providers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/login_domain_provider) | resource |
| [aci_radius_provider.radius_providers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/radius_provider) | resource |
| [aci_radius_provider_group.radius_provider_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/radius_provider_group) | resource |
| [aci_recurring_window.recurring_window](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/recurring_window) | resource |
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
| [aci_trigger_scheduler.schedulers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/trigger_scheduler) | resource |
<!-- END_TF_DOCS -->