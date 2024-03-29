Considering that I do a lot of expiramentation using linode and I have a domain set up for my simple projects, I decided to make the creation of these resources a little easier and create a terraform module.

This module creates a linode instance and creates a DNS record under the specified domain in cloudflare to allow for easy access.  Credentials such as the [Cloudflare API key](https://developers.cloudflare.com/api/), [Linode PAT](https://www.linode.com/docs/api/), or the root password for created instances are never shown or stored.  These are kept inside of a [Vault instance](https://www.hashicorp.com/products/vault). 

This module could be updated to use any secret storage, but I chose to go with Vault due to my familiarity and not wanting to bring in yet another provider into this.

## Vault Configuration

Prior to running this module an instance of [Hashicorp Vault](https://www.hashicorp.com/products/vault) must be accessbile to this module.  Vault is where the module will retrieve the credentials it needs to access Cloudflare and Linode.

By default, this module makes use of the [KV secrets engine - V2](https://developer.hashicorp.com/vault/docs/secrets/kv/kv-v2).  Follow the documentation to get it set up.  Next by default the module is going to look under `kvv2/provider` for the secrets.

The secrets should be formatted in a manner as such:

```json
{
  "linode": "LINODE PAT",
  "cloudflare": "CLOUDFLARE API KEY"
}
```

Once vault is configured you can begin using the module.  See the documentation below for details on how to use it.

# Module Documentation
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | 4.14.0 |
| <a name="requirement_linode"></a> [linode](#requirement\_linode) | 2.7.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | 3.20.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 4.14.0 |
| <a name="provider_linode"></a> [linode](#provider\_linode) | 2.7.2 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 3.20.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_record.instance_record](https://registry.terraform.io/providers/cloudflare/cloudflare/4.14.0/docs/resources/record) | resource |
| [linode_instance.web](https://registry.terraform.io/providers/linode/linode/2.7.2/docs/resources/instance) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/password) | resource |
| [vault_kv_secret_v2.instance_root_password](https://registry.terraform.io/providers/hashicorp/vault/3.20.0/docs/resources/kv_secret_v2) | resource |
| [vault_mount.kvv2](https://registry.terraform.io/providers/hashicorp/vault/3.20.0/docs/resources/mount) | resource |
| [cloudflare_zone.domain](https://registry.terraform.io/providers/cloudflare/cloudflare/4.14.0/docs/data-sources/zone) | data source |
| [linode_images.specific-images](https://registry.terraform.io/providers/linode/linode/2.7.2/docs/data-sources/images) | data source |
| [linode_instance_types.specific-types](https://registry.terraform.io/providers/linode/linode/2.7.2/docs/data-sources/instance_types) | data source |
| [linode_sshkey.foo](https://registry.terraform.io/providers/linode/linode/2.7.2/docs/data-sources/sshkey) | data source |
| [vault_kv_secret_v2.provider_auth](https://registry.terraform.io/providers/hashicorp/vault/3.20.0/docs/data-sources/kv_secret_v2) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_ttl"></a> [dns\_ttl](#input\_dns\_ttl) | The TTL for the DNS record | `number` | `3600` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain to configure subdomains for | `string` | `"dccapp.io"` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | The name of the image to use for the linode instance | `string` | `"Ubuntu 22.04 LTS"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of instance to stand up | `string` | `"Nanode 1GB"` | no |
| <a name="input_label"></a> [label](#input\_label) | The label to apply to the new instance, this will also be the subdomain. eg. example will become example.domain.com | `string` | n/a | yes |
| <a name="input_login_approle_role_id"></a> [login\_approle\_role\_id](#input\_login\_approle\_role\_id) | The approle id to authorize this module to pull secrets from Vault | `string` | n/a | yes |
| <a name="input_login_approle_secret_id"></a> [login\_approle\_secret\_id](#input\_login\_approle\_secret\_id) | The approle secret id to authorize this module to pull secrets from Vault | `string` | n/a | yes |
| <a name="input_provider_auth_secrets_name"></a> [provider\_auth\_secrets\_name](#input\_provider\_auth\_secrets\_name) | Name of the provider authorization secrets in vault | `string` | `"auth"` | no |
| <a name="input_provider_auth_secrets_path"></a> [provider\_auth\_secrets\_path](#input\_provider\_auth\_secrets\_path) | Path to the provider authorization secrets in Vault | `string` | `"kvv2/provider"` | no |
| <a name="input_region"></a> [region](#input\_region) | The linode region to stand up the instance in | `string` | `"us-southeast"` | no |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | The SSH key to add to the linode instance | `string` | `"Default"` | no |
| <a name="input_vault_address"></a> [vault\_address](#input\_vault\_address) | Address to access vault | `string` | `"http://vault.dccapp.io:8200"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns"></a> [dns](#output\_dns) | The subdomain the new resource is located |
| <a name="output_root_password_identifier"></a> [root\_password\_identifier](#output\_root\_password\_identifier) | The path to the root password in vault |
| <a name="output_ssh_key"></a> [ssh\_key](#output\_ssh\_key) | Authorized SSH keys that can access this instance |
