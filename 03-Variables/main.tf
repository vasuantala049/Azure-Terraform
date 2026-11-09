terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~>5.13.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstate15768" # Replace with your storage account name
    container_name       = "tfstate"
    key                  = "vars.terraform.tfstate"
  }
  required_version = "1.15.9"
}

provider "azurerm" {
    features {
      
    }
}

variable "environment" {
    type=string
    description = "environment"
    default = "staging"
}// you can override this variable either by tfvars file or by -var=environment=dev in terraform command but remmember that command take higher precedance than tfvars

locals {
  common_tags={
    location = "East Asia"
    account_tier = "Standard"
  }
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = local.common_tags.location
}

resource "azurerm_storage_account" "example" {
  name                     = "tfpracticestorageaccount"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = local.common_tags.location
  account_tier             = local.common_tags.account_tier
  account_replication_type = "GRS"

  tags = {
    environment = var.environment
  }
}

output "storage_account_id" {
  value = azurerm_storage_account.example.id
}
