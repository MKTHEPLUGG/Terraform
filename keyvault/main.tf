module "keyvault" {
  source = "../modules/keyvault_and_key"

  location        = "westeurope"
  rgName = "test-tf-2"

}