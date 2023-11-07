# https://developer.hashicorp.com/terraform/language/modules/develop/providers
# Provider version in a module

# Although provider configurations are shared between modules,
# each module must declare its own provider requirements,
# so that Terraform can ensure that there is a single version of the provider that is compatible 
# with all modules in the configuration and to specify the source address that serves 
# as the global (module-agnostic) identifier for a provider.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.32"
    }
  }

  required_version = ">= 1.3.0"
}
