data "terraform_remote_state" "source_workspace" {
  backend = "remote"

  config = {
    organization = "mikevh"
    workspaces = {
      name = "token-workspace"
    }
  }
}
resource "tfe_workspace" "aks" {
  name         = "aks"
  organization = "mikevh"

  // Link to a VCS repository
  vcs_repo {
    identifier     = "your-org/your-repo"  // Format: "org-name/repo-name"
    branch         = "main"                // Specify a branch, defaults to the repository's default branch if not set
    ingress_submodules = false             // Set to 'true' if you want Terraform Cloud to clone submodules
    oauth_token_id = "your-vcs-oauth-token-id"  // The VCS OAuth token ID in Terraform Cloud
  }

  // Set the working directory within the repo
  // If your Terraform configurations are in a subdirectory, specify it here
  working_directory = "path/to/your/configs"

  // Enable or disable automatic speculative plans
  auto_apply = true

  // Configure Terraform version
  terraform_version = "1.0.0"
}
