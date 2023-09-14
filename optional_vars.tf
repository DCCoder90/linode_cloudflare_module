variable "vault_address"{
  description = "Address to access vault"
  type = string
  default = "http://vault.dccapp.io:8200"
}

variable "instance_type" {
  description = "The type of instance to stand up"
  type = string
  default = "Nanode 1GB"
}

variable "image_name" {
  description = "The name of the image to use for the linode instance"
  type = string
  default = "Ubuntu 22.04 LTS"
}

variable "region"{
  description = "The linode region to stand up the instance in"
  type = string
  default = "us-southeast"
}

variable "dns_ttl"{
  description = "The TTL for the DNS record"
  type = number
  default = 3600
}

variable "provider_auth_secrets_path" {
  description = "Path to the provider authorization secrets in Vault"
  default = "kvv2/provider"
  type = string
}

variable "provider_auth_secrets_name" {
  description = "Name of the provider authorization secrets in vault"
  default = "auth"
  type = string
}

variable "domain" {
  description = "The domain to configure subdomains for"
  type = string
  default = "dccapp.io"
}

variable "ssh_key"{
  description = "The SSH key to add to the linode instance"
  type = string
  default = "Default"
}