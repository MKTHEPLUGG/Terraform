I apologize for the oversight. You're right; when using Terraform in automation, especially with GitHub Actions, you cannot directly use variables in the provider block due to the order of operations. 

Here's how you can handle this:

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

Again, I apologize for the confusion, and thank you for pointing it out.