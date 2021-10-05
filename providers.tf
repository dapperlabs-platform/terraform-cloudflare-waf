# Each module must declare its own provider requirements. 
# This is especially important for non-HashiCorp providers.
# https://www.terraform.io/docs/language/modules/develop/providers.html

# Offical Issue on this
# Non-hashicorp provders
# https://github.com/hashicorp/terraform/issues/26448

# To get around declaring the same file - symlinks are used
terraform {

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 2.18.0"
    }
  }
}
