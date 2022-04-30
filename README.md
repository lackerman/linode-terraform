## Linode Infrastructure

Used primarily to set up the linode DNS and spin up a linode instance to run certbot
or [acme.sh][linode_wildcard_acme] to generate certificates for offline use.

For detailed instructions, check out the [certbot docs][certbot_docs]

Define the necessary env vars for Terraform Cloud
```shell
cat >> config.auto.tfvars <<EOF
linode_token=
linode_region=
ssh_key=
domain=
email=
EOF
```

Spin up the infrastructure
```shell
git clone git@github.com:lackerman/linode-terraform.git
cd terraform/linode
make apply
```

ssh into the linode instance (ssh key should have been updated as part of the automation)
```shell
ssh root@${LINODE_IP}
```

### certbot

Install certbot for generating offline/manual certificates. You can also use the
[linode plugin][linode_plugin] but acme (next step) is far simpler
```shell
sudo snap install core
sudo snap refresh core
sudo snap install --classic certbot
sudo certbot certonly --standalone
```

### acme.sh

```shell
sudo apt-get update
sudo apt-get install socat
curl https://get.acme.sh | sh
source ~/.bashrc
acme.sh version
acme.sh --set-default-ca --server letsencrypt

DOMAIN="<-- replace example.com -->"
mkdir "${DOMAIN}"
export LINODE_V4_API_KEY="<-- https://cloud.linode.com/profile/tokens -->"

# Wildcard
acme.sh --issue --dns dns_linode_v4 --dnssleep 90 -d "${DOMAIN}" -d "*.${DOMAIN}"

# Single Cert
acme.sh --issue --dns dns_linode_v4 --dnssleep 90 -d "${DOMAIN}" -d "www.${DOMAIN}"

# Generate the pem files (run it as is)
acme.sh --install-cert --domain "${DOMAIN}" \
    --key-file "${DOMAIN}/key.pem" \
    --cert-file "${DOMAIN}/cert.pem" \
    --fullchain-file "${DOMAIN}/fullchain.pem"
```

### copy the certs locally

```shell
cd roles/automation/files/
rsync -auv root@${LINODE_IP}:/etc/letsencrypt/archive/* traefik/
```

[linode_wildcard_acme]: https://www.linode.com/docs/guides/secure-website-lets-encrypt-acme-sh/
[certbot_docs]: https://certbot.eff.org/instructions?ws=other&os=ubuntu-20
[linode_plugin]: https://certbot-dns-linode.readthedocs.io/en/stable/
