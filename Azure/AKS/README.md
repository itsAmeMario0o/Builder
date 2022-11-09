`az login`
`az ad sp create-for-rbac --skip-assignment`
</br>
Replace the values in your `terraform.tfvars` file with your appId and password. Terraform will use these values to authenticate to Azure before provisioning your resources.
</br>

`terraform init`
`terraform plan`
`terraform apply`