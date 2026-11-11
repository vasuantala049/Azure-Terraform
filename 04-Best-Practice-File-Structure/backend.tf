terraform {
 
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstate15768" # Replace with your storage account name
    container_name       = "tfstate"
    key                  = "04.terraform.tfstate"
  }
 
}

