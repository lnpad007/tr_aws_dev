variable "region" {
  default = "eu-central-1"
}

variable "public_subnet_cidr_blocks" {
  default = ["172.20.0.0/22", "172.20.4.0/22"]
}

variable "private_subnet_cidr_blocks" {
  default = ["172.20.32.0/19", "172.20.64.0/19"]
}

variable "az" {
  default = ["eu-central-1a", "eu-central-1b"]
}

