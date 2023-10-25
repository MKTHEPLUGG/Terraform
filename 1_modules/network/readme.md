# Terraform `network` Module Documentation

The `network` module provides a structured approach to deploy Azure networking resources. This includes creating a virtual network, subnet, network security group, and associating the security group with the subnet.

## Resources Deployed

1. **Virtual Network (`azurerm_virtual_network`)**:
   - Creates a virtual network in Azure.
   - Uses a predefined address space of `10.0.0.0/16`.
   - The name of the virtual network is derived from the local `resource_name` variable with a `-vnet` suffix.

2. **Subnet (`azurerm_subnet`)**:
   - Creates a subnet within the virtual network.
   - Uses an address prefix of `10.0.1.0/24`.
   - The name of the subnet is derived from the local `resource_name` variable with a `-subnet` suffix.

3. **Network Security Group (`azurerm_network_security_group`)**:
   - Creates a network security group (NSG) with a rule to allow SSH traffic.
   - The rule allows inbound TCP traffic on port 22 (SSH) from any source.
   - The name of the NSG is derived from the local `resource_name` variable with a `-nsg` suffix.

4. **Resource Group (`azurerm_resource_group`)**:
   - Creates a resource group in Azure where all the networking resources will reside.
   - The name and location of the resource group are defined by the `resourceGroup` and `location` variables, respectively.

5. **Subnet-Network Security Group Association (`azurerm_subnet_network_security_group_association`)**:
   - Associates the created subnet with the network security group. This ensures that the security rules defined in the NSG are applied to the subnet.

## Variables

- **resource_prefix (`variable "resource_prefix"`)**:
  - Description: Prefix used for naming all resources.
  - Type: String
  - Default: "myunique"

- **location (`variable "location"`)**:
  - Description: Azure region where the resources will be deployed.
  - Type: String
  - Default: "westeurope"

- **resourceGroup (`variable "resourceGroup"`)**:
  - Description: Name of the Azure resource group.
  - Type: String
  - Default: "Test-RG-TF"

## Outputs

- **subnet_id**:
  - Description: Outputs the ID of the created subnet.
  - Value: ID of the `azurerm_subnet` resource.

## Usage

To use this module in your Terraform configuration:

```hcl
module "network" {
  source = "./modules/network"  # Adjust the path as necessary

  resource_prefix = "myapp"  # Provide necessary variable values here
  location        = "westeurope"
  resourceGroup   = "myapp-rg"
}
```

## Conclusion

The `network` module offers a modularized approach to deploying Azure networking resources. By using this module, you can ensure consistent and repeatable deployments of your Azure network infrastructure.