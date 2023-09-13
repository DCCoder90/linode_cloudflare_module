output "root_password_identifier" {
  #Root password should be placed in secret storage, and then the secret storage location output here

  value = random_password.password.result
  sensitive = true
  description = "The root password to the instance"
}

output "ssh_key"{
  value = linode_instance.web.authorized_keys[0]
  description = "Authorized SSH keys that can access this instance"
}

output "dns" {
  value = "${cloudflare_record.example.name}.${var.domain}"
  description = "The subdomain the new resource is located"
}