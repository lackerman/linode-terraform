resource "linode_sshkey" "devmachine" {
  label   = "ssh_key"
  ssh_key = var.ssh_key
}

resource "linode_instance" "ingressvm" {
  label           = "ingressvm"
  image           = "linode/ubuntu20.04"
  type            = "g6-nanode-1"
  region          = var.linode_region
  authorized_keys = [linode_sshkey.devmachine.ssh_key]
}

resource "linode_domain" "domain" {
  type      = "master"
  domain    = var.domain
  soa_email = var.email
}

resource "linode_domain_record" "arecord" {
  domain_id   = linode_domain.domain.id
  record_type = "A"
  name        = "*"
  target      = linode_instance.ingressvm.ip_address
}
