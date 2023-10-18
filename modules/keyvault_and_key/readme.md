Certainly! Here's a detailed documentation for the `keyvault` module in Terraform:

---

# Terraform `keyvault` Module Documentation

The `keyvault` module provides a structured approach to deploy Azure Key Vault resources, including the Key Vault itself, a secret within the vault, and associated role assignments.

## Resources Deployed

1. **Resource Group (`azurerm_resource_group`)**:
   - Creates a resource group in Azure.
   - Allows for ignoring changes to the tags of the resource group.
   - Tags the resource group with `Env: Prod`.

2. **Random String Generators (`random_string`)**:
   - Generates random strings for the Key Vault name and key name if they are not provided.
   - Ensures uniqueness of the Key Vault and key names.

3. **Random Password Generator (`random_password`)**:
   - Generates a random password.
   - Ensures complexity requirements are met.

4. **Key Vault (`azurerm_key_vault`)**:
   - Creates a Key Vault in Azure.
   - Configures the Key Vault with RBAC authorization, template deployment, and deployment settings.
   - Assigns the current Azure tenant to the Key Vault.

5. **Role Assignment (`azurerm_role_assignment`)**:
   - Assigns the "key vault administrator" role to the currently logged-in Azure user for the created Key Vault.

6. **Key Vault Secret (`azurerm_key_vault_secret`)**:
   - Creates a secret within the Key Vault.
   - Uses the generated random password as the secret value.

## Variables

- **rgName**:
  - Description: Name of the Azure resource group.
  - Default: "app-rg-ex3"

- **location**:
  - Description: Azure region where the resources will be deployed.
  - Default: "westeurope"

- **vault_name**:
  - Description: Name for the Key Vault.
  - Default: Generated random name if not provided.

- **sku_name**:
  - Description: SKU name for the Key Vault.
  - Default: "standard"

- **key_type**:
  - Description: Type of the key to create in Key Vault.
  - Default: "RSA"

- **key_size**:
  - Description: Size of the key to create in Key Vault.
  - Default: 2048

- **key_opts**:
  - Description: Key operations for the key in Key Vault.
  - Default: ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]

- **key_name**:
  - Description: Name for the key in Key Vault.
  - Default: Generated random name if not provided.

## Outputs

- **resource_group_name**: Name of the created resource group.
- **azurerm_key_vault_name**: Name of the created Key Vault.
- **azurerm_key_vault_id**: ID of the created Key Vault.
- **key_vault_key_uri**: URI of the created key/secret in the Key Vault.
- **key_name**: Name of the key/secret in the Key Vault.
- **secret_id**: ID of the created secret in the Key Vault.
- **secret_name**: Name of the created secret in the Key Vault.

## Usage

To use this module in your Terraform configuration:

```hcl
module "keyvault" {
  source = "./modules/keyvault"  # Adjust the path as necessary

  rgName      = "myapp-rg"  # Provide necessary variable values here
  location    = "westeurope"
  vault_name  = "myapp-kv"
  sku_name    = "premium"
  key_name    = "myapp-key"
}
```

## Conclusion

The `keyvault` module offers a modularized approach to deploying Azure Key Vault resources. By using this module, you can ensure consistent and repeatable deployments of your Azure Key Vault infrastructure.


Certainly! Let's delve deeper into the `keyvault` module, breaking down its components and providing more context on its design and usage.

---

# In-Depth Documentation: Terraform `keyvault` Module

## Introduction

The `keyvault` module in Terraform is designed to streamline the deployment of Azure Key Vault resources. This module encapsulates the complexity of creating and managing these resources, offering a modular and reusable approach.

## Module Components

### 1. **Resource Group (`azurerm_resource_group`)**

Every Azure resource needs to reside within a Resource Group. This module creates a dedicated resource group for the Key Vault, ensuring a logical grouping of related resources. The `lifecycle` block within this resource ensures that any changes to the tags of the resource group won't trigger a recreation of the entire resource group, preserving existing resources.

### 2. **Random String and Password Generators**

To ensure unique naming and strong security:

- **Random String Generators (`random_string`)**: These are used to generate unique names for the Key Vault and its keys if names aren't provided. This ensures that even if the module is used multiple times, there won't be naming conflicts.
  
- **Random Password Generator (`random_password`)**: Generates a secure password, ensuring that the password meets complexity requirements. This is particularly useful for creating secure secrets within the Key Vault.

### 3. **Key Vault (`azurerm_key_vault`)**

The heart of the module. The Key Vault is a centralized cloud service for storing application secrets. This module's design ensures:

- **RBAC Authorization**: Role-Based Access Control (RBAC) is enabled, ensuring that only authorized users and services can access the Key Vault.
  
- **Template and Deployment Settings**: The Key Vault is configured to support deployments from Azure Resource Manager templates and to allow Azure services to retrieve secrets.

### 4. **Role Assignment (`azurerm_role_assignment`)**

This ensures that the currently logged-in Azure user is given the "key vault administrator" role for the created Key Vault. This is crucial for managing the Key Vault post-deployment.

### 5. **Key Vault Secret (`azurerm_key_vault_secret`)**

This resource creates a secret within the Key Vault, storing the generated random password. This showcases how secrets can be programmatically added to the Key Vault.

## Variables Explained

Variables in Terraform allow for customization and flexibility. In this module:

- **rgName, location, vault_name**: These allow you to specify the names and location for the resource group and Key Vault. If not provided, defaults are used.
  
- **sku_name**: Determines the pricing tier and features of the Key Vault.
  
- **key_type, key_size, key_opts**: These variables allow customization of the key within the Key Vault, from its type and size to its operations.

## Outputs

Outputs provide a way to expose certain data from a module. This module offers outputs like the names and IDs of the created resources, which can be useful for integrating with other Terraform configurations or for reference.

## How to Use the Module

To utilize this module in your Terraform setup:

```hcl
module "keyvault" {
  source = "./modules/keyvault"  # Adjust the path as necessary

  # Provide necessary variable values or rely on defaults
  rgName      = "myapp-rg"
  location    = "westeurope"
  vault_name  = "myapp-kv"
}
```

By referencing the module in this manner, you can deploy a Key Vault setup with minimal effort, ensuring best practices are followed.

## Conclusion

The `keyvault` module is a testament to the power of modular infrastructure as code. By encapsulating the complexity of Azure Key Vault deployment into a reusable module, Terraform allows for efficient, consistent, and error-free deployments. Whether you're a seasoned Azure expert or just starting out, this module offers a simplified approach to deploying and managing Azure Key Vaults.