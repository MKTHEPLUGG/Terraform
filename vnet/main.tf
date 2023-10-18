module "network" {
  source = "../modules/network"

  resource_prefix = "test123"  # Provide necessary variable values here
  location        = "westeurope"
  resourceGroup = "test-tf-1"
}

output "subnet_id" {
  value = module.network.subnet_id
}
