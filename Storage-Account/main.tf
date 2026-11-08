terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~>5.13.0"
    }
  }
  required_version = "1.15.9"
}

provider "azurerm" {
    features {
      
    }
}



resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East Asia"
}

resource "azurerm_storage_account" "example" {
  name                     = "tfpracticestorageaccount"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}
