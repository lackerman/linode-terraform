.PHONY: apply
apply:
	terraform init
	terraform apply -auto-approve
	@echo 'export LINODE_IP="$(shell terraform output -json | jq -r '.instance_ip_addr.value')"'
