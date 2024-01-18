data "terraform_remote_state" "source_workspace" {
  backend = "remote"

  config = {
    organization = "mikevh"
    workspaces = {
      name = "token-workspace"
    }
  }
}

