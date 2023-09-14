data "cloudflare_zone" "domain" {
  name = var.domain
}

resource "cloudflare_record" "instance_record" {
  zone_id = data.cloudflare_zone.domain.zone_id
  name    = var.label
  value   = linode_instance.web.ip_address
  type    = "A"
  ttl     = var.dns_ttl
}