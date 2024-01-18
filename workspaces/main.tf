terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.25"
    }
  }
}

provider "tfe" {
  token = var.tfe_token
}

resource "tfe_workspace" "example" {
  name         = "my-new-workspace"
  organization = "my-organization"

  // Other optional fields...
}
