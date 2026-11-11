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
