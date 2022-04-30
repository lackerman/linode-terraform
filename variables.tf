variable "linode_token" {
  type        = string
  description = "The linode v4 API token to use"
}

variable "linode_region" {
  type        = string
  description = "The region to use for the compute deployment."
}

variable "ssh_key" {
  type        = string
  description = "The ssh public key to be added to linode and the instances."
}

variable "email" {
  type        = string
  description = "email address linked to the domain for linode DNS"
}

variable "domain" {
  type        = string
  description = "the domain to use, for example 'example.com'"
}