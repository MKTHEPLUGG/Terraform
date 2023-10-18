locals {
  key_name = coalesce(var.key_name, "key-${random_string.key_name.result}")
}