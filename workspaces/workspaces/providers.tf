provider "tfe" {
  // Terraform Cloud API token is sourced from the environment variable
  // No explicit token is needed here
}

terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.25"
    }
  }
}
