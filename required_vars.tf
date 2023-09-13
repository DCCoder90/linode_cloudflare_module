variable "cloudflare_api_token" {
  description = ""
  type = string
  sensitive = true
}

variable "linode_api_token" {
  description = ""
  type = string
  sensitive = true
}

variable "label"{
  description = ""
  type = string
}

variable "domain" {
  description = ""
  type = string
}

variable "ssh_key"{
  description = ""
  type = string
}
