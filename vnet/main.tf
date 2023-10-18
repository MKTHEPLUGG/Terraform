module "network" {
  source = "../modules/network"

  resource_prefix = "test123"  # Provide necessary variable values here
  location        = "westeurope"
}

output "subnet_id" {
  value = module.network.subnet_id
}
