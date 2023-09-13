data "vault_kv_secret_v2" "provider_auth" {
  mount = var.provider_auth_secrets_path
  name  = var.provider_auth_secrets_name
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "vault_mount" "kvv2" {
  path        = "kvv2"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

resource "vault_kv_secret_v2" "instance_root_password" {
  mount               = vault_mount.kvv2.path
  name                = var.label
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      root_password = random_password.password.result
    }
  )
}