terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }

    linode = {
      source  = "linode/linode"
      version = "2.7.2"
    }
  }
}

provider "vault" {
  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = var.login_approle_role_id
      secret_id = var.login_approle_secret_id
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "linode" {
  token = var.linode_api_token
}

data "cloudflare_zone" "domain" {
  name = var.domain
}

data "linode_sshkey" "foo" {
  label = var.ssh_key
}

data "linode_images" "specific-images" {
  filter {
    name = "label"
    values = [var.image_name]
  }

  filter {
    name = "is_public"
    values = ["true"]
  }
}

data "linode_instance_types" "specific-types" {
  filter {
    name = "label"
    values = [var.instance_type]
  }
}

resource "vault_mount" "kvv2" {
  path        = "kvv2"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

resource "vault_kv_secret_v2" "example" {
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

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "linode_instance" "web" {
  label = var.label
  image = data.linode_images.specific-images.*.id[0]
  region = var.region
  type = data.linode_instance_types.specific-types.*.id[0]
  authorized_keys = [data.linode_sshkey.foo.ssh_key]
  root_pass = random_password.password.result

  group = "foo"
  tags = [ "foo" ]
  swap_size = 256
  private_ip = true
}

resource "cloudflare_record" "example" {
  zone_id = data.cloudflare_zone.domain.zone_id
  name    = var.label
  value   = linode_instance.web.ip_address
  type    = "A"
  ttl     = var.dns_ttl
}