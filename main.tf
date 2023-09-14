terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.14.0"
    }

    linode = {
      source  = "linode/linode"
      version = "2.7.2"
    }

    vault = {
      source = "hashicorp/vault"
      version = "3.20.0"
    }

    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "vault" {
  address = var.vault_address

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = var.login_approle_role_id
      secret_id = var.login_approle_secret_id
    }
  }
}

provider "cloudflare" {
  api_token = data.vault_kv_secret_v2.provider_auth.data.cloudflare
}

provider "linode" {
  token = data.vault_kv_secret_v2.provider_auth.data.linode
}
