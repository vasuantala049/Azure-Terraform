

resource "azurerm_resource_group" "example" {
  name     = "${var.environment}-resources"
  location = "East Asia"
}
resource "azurerm_storage_account" "example" {
  for_each = toset(var.storage_acc_name)
  name = each.key
  //count = length(var.storage_acc_name)
  //name                     = var.storage_acc_name[count.index]
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = var.environment
  }
}