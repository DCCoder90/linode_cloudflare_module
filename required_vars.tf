variable login_approle_role_id {
  description = "The approle id to authorize this module to pull secrets from Vault"
  type = string
}

variable login_approle_secret_id {
  description = "The approle secret id to authorize this module to pull secrets from Vault"
  type = string
}

variable "label"{
  description = "The label to apply to the new instance, this will also be the subdomain. eg. example will become example.domain.com"
  type = string
}
