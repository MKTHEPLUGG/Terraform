# Terraform Azure Deployment

This repository contains Terraform configurations to deploy Azure resources using GitHub Actions. The primary resource being deployed is a virtual network with associated subnets and network security groups.
you can create any subfolder you desire for a deployment that leverages the modules in this repo. On commit the resources will be automaticly deployed via pipeline.

## Repository Structure (example)

- **Root Directory/vnet**:
  - `backend.tf`: Contains the backend configuration for Terraform to store its state in Azure Blob Storage.
  - `main.tf`: Calls the network module to deploy the virtual network and associated resources.
  - `providers.tf`: Specifies the required providers and their versions.
  - `variables.tf`: Defines the variables used in the configurations.
  - `.github/workflows/`: Contains the GitHub Actions workflow for deploying the Terraform configurations.

- **Modules**:
  - `modules/network`: Contains the Terraform configurations for deploying the virtual network, subnet, network security group, and other related resources.

## How It Works

1. **Backend Configuration (`backend.tf`)**:
   The backend configuration is used to store the Terraform state in Azure Blob Storage. This ensures that the state is stored remotely and can be accessed by multiple team members or CI/CD pipelines. The actual values for the backend are provided during the GitHub Actions workflow execution.

2. **Azure Resource Deployment (`main.tf`)**:
   The main configuration file calls the `network` module to deploy the virtual network and associated resources in Azure.

3. **Providers and Variables (`providers.tf` and `variables.tf`)**:
   The required providers for the configurations are specified in `providers.tf`. Variables used across the configurations are defined in `variables.tf`.

4. **Network Module (`modules/network`)**:
   This module deploys the virtual network, subnet, and network security group in Azure. It also associates the network security group with the subnet.

5. **GitHub Actions Workflow**:
   The workflow is triggered on a push to the master branch. It sets up Terraform, checks out the code, and then uses the custom GitHub Action `MKTHEPLUGG/deploy-tf-vrs@v1` to deploy the Terraform configurations to Azure.

   - **Authentication**: 
     The workflow uses GitHub secrets to authenticate with Azure. These secrets are set in the repository settings and are used to provide values for the `client_id`, `client_secret`, `tenant_id`, and `subscription_id` variables. The `TF_VAR_` prefix is used to pass these values to the Terraform configurations.

   - **Storage Account Authentication**:
     The same Service Principal (SP) is used for both the backend storage account authentication and the Azure provider authentication. This simplifies the setup, but you can use separate SPs if needed.

## Deployment

To deploy the Terraform configurations:

1. Push changes to the master branch.
2. The GitHub Actions workflow will trigger and deploy the changes to Azure.

## Cleanup

To remove the deployed resources:

1. Run the `terraform destroy` command locally, or
2. Modify the GitHub Actions workflow to run `terraform destroy` instead of `terraform apply`.

---

This documentation provides an overview of the repository and its components. You can expand on it by adding more details, such as prerequisites, how to set up the Service Principal, how to set GitHub secrets, etc.


### HANDY VAR TRICK

1. **Environment Variables**: Terraform will automatically read environment variables that start with `TF_VAR_`. So, for your Azure authentication, you can set environment variables in your GitHub Actions workflow:

```yaml
env:
  TF_VAR_client_id: ${{ secrets.AZURE_CLIENT_ID }}
  TF_VAR_client_secret: ${{ secrets.AZURE_CLIENT_SECRET }}
  TF_VAR_tenant_id: ${{ secrets.AZURE_TENANT_ID }}
  TF_VAR_subscription_id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
```

2. **Terraform Variables**: In your Terraform code, you'll still define the variables:

```hcl
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}
```

3. **Provider Configuration**: In your `provider "azurerm"` block, you'll reference these variables as you did before:

```hcl
provider "azurerm" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  features        = {}
}
```

The key here is that by setting the environment variables in the GitHub Actions workflow with the `TF_VAR_` prefix, Terraform will automatically pick them up and use them as the values for the corresponding variables in your code. This way, you don't need to explicitly pass them using `-var` or any other method. 


Of course! Let's dive deeper into each section and provide more detailed information:

---

# Terraform Azure Deployment

This repository provides a structured approach to deploying Azure resources using Terraform and automating the deployment process with GitHub Actions.

## Prerequisites

1. **Azure Account**: Ensure you have an active Azure account.
2. **Service Principal**: A Service Principal with appropriate permissions is required. This will be used by Terraform to authenticate and deploy resources in Azure.
3. **GitHub Secrets**: Store the Service Principal credentials (Client ID, Client Secret, Tenant ID, and Subscription ID) as GitHub secrets for secure access during the workflow execution.

## Repository Structure

### Root Directory

- `backend.tf`: Configures Terraform's backend to use Azure Blob Storage. This ensures state files are stored remotely, allowing for collaboration and preventing local state discrepancies.
  
- `main.tf`: This is the entry point for Terraform and it invokes the `network` module to orchestrate the deployment of the virtual network and its related resources.
  
- `providers.tf`: Specifies the Terraform providers required for the deployment. This includes the AzureRM provider and any other providers needed for specific resources.
  
- `variables.tf`: Central location for defining and documenting variables used throughout the Terraform configurations.

### Modules

- `modules/network`: A modularized configuration for deploying Azure networking resources. This includes:
  - Virtual Network
  - Subnet
  - Network Security Group and its association with the subnet
  - Resource Group for organizing the resources

## Workflow

The GitHub Actions workflow automates the deployment process:

1. **Trigger**: The workflow activates upon a push to the master branch.
  
2. **Setup**: Initializes the environment by setting up Terraform and checking out the repository code.
  
3. **Deployment with Custom Action**: Uses the custom GitHub Action `MKTHEPLUGG/deploy-tf-vrs@v1` to apply the Terraform configurations to Azure.

   - **Authentication**: 
     The workflow uses GitHub secrets to securely pass authentication details to Terraform. The `TF_VAR_` prefix allows these environment variables to be directly used as Terraform variables.
     
   - **Storage Account Authentication**:
     The backend configuration for Terraform uses the same Service Principal for authentication. This ensures that Terraform can read/write state files to the Azure Blob Storage.

## Deployment Steps

1. **Code Push**: Make necessary changes to the Terraform configurations and push to the master branch.
  
2. **GitHub Actions**: The workflow will automatically trigger, setting up the environment and deploying the changes to Azure.

3. **Verification**: Post-deployment, verify the resources in the Azure portal or use Azure CLI to ensure everything is set up as expected.

## Cleanup

To remove the resources deployed by Terraform:

1. **Local Execution**: Clone the repository, set up Terraform locally, and run `terraform destroy`. Ensure you have the same state file or backend configuration to avoid discrepancies.
  
2. **Modify Workflow**: Adjust the GitHub Actions workflow to execute `terraform destroy` instead of `terraform apply`. This will remove the resources on the next push to the master branch. Remember to revert the workflow after cleanup to avoid accidental deletions in the future.

## Conclusion

This repository offers a streamlined approach to deploying Azure resources using Terraform, modularizing configurations for better management, and automating the deployment process with GitHub Actions. Proper management of secrets and Service Principal credentials ensures secure and efficient deployments.

---

This expanded documentation provides a more detailed overview, diving deeper into the prerequisites, workflow, and cleanup process. Adjustments can be made based on specific requirements or additional details you'd like to include.