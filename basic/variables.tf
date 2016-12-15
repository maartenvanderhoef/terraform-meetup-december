variable "region" {
  description = "The AWS region"
}
variable "access_key" {
  description = "The AWS Access key"
}

variable "secret_key" {
  description = "The AWS secret key"
}

variable "shortname" {
  description = "The name for everything related to this setup"
  default     = "tfmeetup"
}

variable "vpc_cidr" {
  description = "The CIDR of the network created in the VPC"
}

variable "subnet_cidr" {
  description = "The CIDR of the subnet created in the VPC"
}
