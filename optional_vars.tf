variable "instance_type" {
  description = ""
  type = string
  default = "Nanode 1GB"
}

variable "image_name" {
  description = ""
  type = string
  default = "Ubuntu 22.04 LTS"
}

variable "region"{
  description = ""
  type = string
  default = "us-southeast"
}

variable "dns_ttl"{
  description = ""
  type = number
  default = 3600
}
