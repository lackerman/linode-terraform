terraform {
  backend "remote" {
    organization = "lackerman"

    workspaces {
      name = "tf-linode"
    }
  }
}

provider "linode" {
  token = var.linode_token
}