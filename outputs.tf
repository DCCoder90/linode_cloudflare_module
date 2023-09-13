output "root_password_identifier" {
  value       = vault_kv_secret_v2.instance_root_password.path
  description = "The path to the root password in vault"
}

output "ssh_key" {
  value       = linode_instance.web.authorized_keys[0]
  description = "Authorized SSH keys that can access this instance"
}

output "dns" {
  value       = "${cloudflare_record.instance_record.name}.${var.domain}"
  description = "The subdomain the new resource is located"
}