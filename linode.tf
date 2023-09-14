data "linode_sshkey" "foo" {
  label = var.ssh_key != "" ? var.ssh_key : "default"
}

data "linode_images" "specific-images" {
  filter {
    name   = "label"
    values = [var.image_name]
  }

  filter {
    name   = "is_public"
    values = ["true"]
  }
}

data "linode_instance_types" "specific-types" {
  filter {
    name   = "label"
    values = [var.instance_type]
  }
}

resource "linode_instance" "web" {
  label           = var.label
  image           = data.linode_images.specific-images.*.id[0]
  region          = var.region
  type            = data.linode_instance_types.specific-types.*.id[0]
  authorized_keys = [data.linode_sshkey.foo.ssh_key]
  root_pass       = vault_kv_secret_v2.instance_root_password.data.root_password

  group      = "foo"
  tags       = ["foo"]
  swap_size  = 256
  private_ip = true
}