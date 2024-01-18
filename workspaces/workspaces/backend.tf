terraform {
  backend "remote" {
    organization = "mikevh"

    workspaces {
      name = "token-workspace"
    }
  }
}
