terraform {
  backend "remote" {
    organization = "your-organization"

    workspaces {
      name = "your-target-workspace"
    }
  }
}
