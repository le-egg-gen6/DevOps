terraform init
terraform plan -var-file=production.tfvars
terraform apply -var-file=production.tfvars -auto-approve
terraform destroy -var-file=production.tfvars -auto-approve