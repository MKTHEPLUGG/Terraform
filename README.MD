## Terraform


### What is terraform?

With terraform you can automate the provisioning of your infrastructure using code instead of having to provision it yourself, works well together with ansible that you can use for configuring the provisioned infrastructure afterwards.

You can also use it to replicate infrastructure for example to have a dev and prod env

### Key Components:

`Terraform CLI`: The command-line interface for Terraform.

`Configuration Files`: Defined in HCL, they dictate the infrastructure to be created.

`Providers`: Plugins Terraform uses to communicate with cloud platforms.

`State`: A file Terraform maintains to track existing infrastructure and its configuration.

`Resource`: Infrastructure components like AWS instances or Google Cloud Storage buckets.


### Common Terraform Commands:

`terraform init`: Initializes the Terraform directory.

`terraform plan`: Previews changes Terraform will enact based on configuration files.

`terraform apply`: Achieves the desired infrastructure state.

`terraform destroy`: Removes the infrastructure.

`terraform validate`: Validates configuration files for correctness.

`terraform fmt`: Standardizes configuration file formatting.

`terraform state`: Manages state with various sub-commands.

`terraform output`: Shows outputs from the state.

### Basic Steps to Using Terraform:

`Write Configuration`: Use a .tf extension (like main.tf).

`Initialization`: Execute terraform init.

`Planning & Applying`: Preview with terraform plan and enact with terraform apply.

#### Example AWS EC2 Configuration:

```hcl
provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
}
```

### Terraform commands summary

#### Run a terraform file

in the working directory (or specify directory):

```terraform
terraform init
terraform validate
terraform fmt
terraform plan
terraform apply
```

if changes are made to your provider defs you need to `terraform init --upgrade`

#### Check out the .tfstate file

```terraform
terraform show

# see what is being managed by state file
terraform state list
```

#### Remove all your resources

```terraform
terraform destroy
```


### Sources

https://www.youtube.com/watch?v=l5k1ai_GBDE


