## REWRITE DOCUMENTATION WITH WORKING PROJECT AS SOURCE BEFORE RELEASE !!!



Absolutely, managing Terraform state is crucial, especially when you're using automation and CI/CD pipelines. The state file keeps track of the IDs and properties of the resources Terraform manages, so it's essential to keep it safe, consistent, and available.

When working on local machines, Terraform uses a local state file named `terraform.tfstate`. However, when you're using Terraform in a team or in an automated pipeline, it's vital to use **remote state**. Remote state allows Terraform to store its state file on a shared storage backend, which can be accessed by other team members or automation pipelines, ensuring consistency.

Azure Blob Storage is a common backend for storing Terraform state when deploying resources on Azure. 

### **Setting up Azure Blob Storage for Terraform State**:

1. **Create a Storage Account and Container**:
   - You can do this through the Azure Portal, Azure CLI, or even Terraform itself.
   - Make note of the Storage Account name and the container name.

2. **Configure Terraform to use Azure Blob Storage**:

In your Terraform configuration (usually at the root level where you execute your `terraform init` command), you'd use a `backend` configuration like this:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name   = "myResourceGroup"
    storage_account_name  = "mytfbackendstorage"
    container_name        = "mytfstatecontainer"
    key                   = "terraform.tfstate"
  }
}
```

3. **Initialize Terraform with the new Backend Configuration**:
   Run `terraform init` to initialize the new backend configuration. This will migrate any local state to the Azure Blob Storage backend.

4. **Role-Based Access Control (RBAC)**:
   - Ensure that the service principal or managed identity you're using to run Terraform has the correct permissions on the storage account.
   - Typically, you'd assign the "Storage Blob Data Contributor" role to the identity for the respective storage account.

5. **State Locking**:
   - Terraform can lock the state file to prevent concurrent modifications. Azure Blob Storage supports this locking.
   - When Terraform detects that another instance is already modifying a given state, it'll wait for that other Terraform to finish and release the lock.

6. **Accessing the State in Pipelines**:
   - Ensure your CI/CD environment has the necessary credentials to access Azure (either using a Service Principal or other means).
   - When Terraform runs in the pipeline, it will automatically interact with the remote state in Azure Blob Storage.

### **Best Practices**:

- **Secure Your State Files**: State files can contain sensitive data. Use Azure storage's encryption capabilities, and consider enabling features like Azure RBAC and private endpoints.
  
- **Regular Backups**: While Azure Blob Storage is reliable, ensure you have regular backups of your state files for disaster recovery.

- **Limit Access**: Limit who can read and write to the state file. In many cases, read access should be restricted since the state file can contain sensitive resource details.

- **Versioning**: Enable versioning on your Azure Blob Storage. This way, if something goes wrong, you can revert to a previous state.

- **Consistency**: Ensure everyone on the team and all CI/CD processes use remote state. Having a mix of local and remote states will lead to conflicts and confusion.

By integrating remote state into your CI/CD processes, you ensure a single source of truth for your infrastructure's current state, making your infrastructure deployments more consistent and reliable.


Certainly! Let's create a Terraform configuration that will set up Azure Blob Storage for Terraform state management.

### **Prerequisites**:
1. Ensure you have the Azure CLI and Terraform installed.
2. Authenticate with Azure using `az login`.

### **Terraform Configuration for Azure Blob Storage**:

**1. `main.tf`: Main Configuration File**
```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tfstate_rg" {
  name     = "TerraformStateRG"
  location = "West Europe"
}

resource "azurerm_storage_account" "tfstate_sa" {
  name                     = "tfstatestore12345" # Ensure this is unique across Azure
  resource_group_name      = azurerm_resource_group.tfstate_rg.name
  location                 = azurerm_resource_group.tfstate_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate_container" {
  name                  = "tfstatecontainer"
  storage_account_name  = azurerm_storage_account.tfstate_sa.name
  container_access_type = "private"
}
```

**2. `variables.tf`: Variable Definitions**
```hcl
# Define any variables if needed. For this setup, we don't need any external input.
```

**3. `outputs.tf`: Output Values**
```hcl
output "resource_group_name" {
  value = azurerm_resource_group.tfstate_rg.name
}

output "storage_account_name" {
  value = azurerm_storage_account.tfstate_sa.name
}

output "container_name" {
  value = azurerm_storage_container.tfstate_container.name
}
```

### **Steps to Deploy**:
1. **Initialize Terraform**: 
   ```bash
   terraform init
   ```
   
2. **Plan the Deployment**:
   ```bash
   terraform plan -out=tfplan
   ```

3. **Apply the Deployment**:
   ```bash
   terraform apply tfplan
   ```

After successful deployment, Terraform will output the resource group name, storage account name, and container name.

### **Using the Azure Blob Storage for Terraform State**:

In the Terraform configuration where you want to use the Azure Blob Storage for state management (not in this setup, but your actual infrastructure code), add:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name   = "<RESOURCE_GROUP_NAME_FROM_OUTPUT>"
    storage_account_name  = "<STORAGE_ACCOUNT_NAME_FROM_OUTPUT>"
    container_name        = "<CONTAINER_NAME_FROM_OUTPUT>"
    key                   = "terraform.tfstate"
  }
}
```

Replace the placeholders (`<RESOURCE_GROUP_NAME_FROM_OUTPUT>`, etc.) with the actual outputs from the Terraform setup.

When you run `terraform init` on this configuration, Terraform will configure the backend to use Azure Blob Storage. 

Remember to handle the permissions properly, ensuring the Service Principal or Managed Identity has the required access to this storage. You can do this through Azure Portal's RBAC settings, or using further Terraform configurations.

### **Notes**:
- Ensure the storage account name is globally unique. The example above uses "tfstatestore12345", but you might need to adjust this for your needs.
- For full production readiness, consider adding more features like network rules, encryption settings, and other security configurations to the storage account.

## Step 3, Create service principal for auth

Certainly! If you're planning on using GitHub Actions to deploy Terraform code to Azure, and want to persist your Terraform state in Azure Blob Storage, then using a Service Principal (essentially an Azure AD application registration with rights in Azure) is a sensible choice.

Here's a step-by-step guide to achieve this:

### 1. Create a Service Principal for GitHub Actions:

If you haven't already created a Service Principal, do so using:

```bash
# find sub current env
az account show --query "id" -o tsv

az ad sp create-for-rbac --name github-actions-sp --role="Contributor" --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"
```

Take note of the `appId`, `password`, and `tenant`. These will be used to authenticate Terraform with Azure.

### 2. Grant Permissions to the Service Principal to Access the Storage Account:

Provide the Service Principal permissions to the storage account:

```bash
az role assignment create --assignee APP_ID_FROM_PREVIOUS_STEP --role "Storage Blob Data Contributor" --scope "/subscriptions/YOUR_SUBSCRIPTION_ID/resourceGroups/YOUR_RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/YOUR_STORAGE_ACCOUNT_NAME"
```

### 3. Setup GitHub Secrets:

For security, store the Service Principal details and other sensitive information in GitHub Secrets. Go to your GitHub repo -> Settings -> Secrets, and add the following:

- `AZURE_CLIENT_ID`: `appId` from the service principal creation step
- `AZURE_CLIENT_SECRET`: `password` from the service principal creation step
- `AZURE_TENANT_ID`: `tenant` from the service principal creation step
- `AZURE_SUBSCRIPTION_ID`: Your Azure Subscription ID

### 4. Configure GitHub Actions to use Terraform with Azure:

Here's a sample GitHub Actions workflow for this:

```yaml
name: 'Terraform Deploy to Azure'
on:
  push:
    branches:
      - main

jobs:
  terraform:
    name: 'Deploy to Azure'
    runs-on: ubuntu-latest
    environment: production

    defaults:
      run:
        working-directory: ./path-to-terraform-files

    steps:
    - name: Checkout
      uses: actions/checkout@v2

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1

    - name: Terraform Initialize
      env:
        AZURE_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
        AZURE_CLIENT_SECRET: ${{ secrets.AZURE_CLIENT_SECRET }}
        AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
      run: |
        terraform init -backend-config="storage_account_name=YOUR_STORAGE_ACCOUNT_NAME" -backend-config="container_name=YOUR_CONTAINER_NAME" -backend-config="key=terraform.tfstate" -backend-config="resource_group_name=YOUR_RESOURCE_GROUP_NAME" -backend-config="client_id=$AZURE_CLIENT_ID" -backend-config="client_secret=$AZURE_CLIENT_SECRET" -backend-config="tenant_id=$AZURE_TENANT_ID"
    
    - name: Terraform Validate
      run: terraform validate

    - name: Terraform Plan
      run: terraform plan

    - name: Terraform Apply
      run: terraform apply -auto-approve

```

### 5. Use Terraform:

In your Terraform configuration, ensure that the backend is configured to use AzureRM:

```hcl
terraform {
  backend "azurerm" {
    storage_account_name = "YOUR_STORAGE_ACCOUNT_NAME"
    container_name       = "YOUR_CONTAINER_NAME"
    key                  = "terraform.tfstate"
  }
}
```

With this setup:

1. GitHub Actions will use the Service Principal to authenticate with Azure.
2. The Terraform state will be stored in the specified Azure Blob Storage, ensuring state consistency between runs.
3. Since the authentication details are stored in GitHub Secrets, they're encrypted and can't be viewed once set, providing a layer of security. 

Remember to replace placeholders like `YOUR_STORAGE_ACCOUNT_NAME` with your actual Azure resource details.