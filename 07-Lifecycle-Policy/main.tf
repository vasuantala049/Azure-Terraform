

resource "azurerm_resource_group" "example" {
  name     = "${var.environment}-resources"
  location = var.location
  lifecycle {
    ignore_changes = [ location ] //after applying the code changes made to the location field will be ignored
    prevent_destroy = true // you can not destroy this resource until you change this line to false 
    precondition {
      condition = contains(var.allowed_location, var.location)
      error_message = "Please enter a valid location!"
    }
  }
}
resource "azurerm_storage_account" "example" {
  for_each = toset(var.storage_acc_name)
  name = each.key
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  lifecycle {
    prevent_destroy = true // you can not destroy this resource until you change this line to false 
    replace_triggered_by = [ azurerm_resource_group.example.id ]
    // create_before_destroy = true  --> whenever the new changes had been made to the resource that triggers the recreation of the resource then first create the new resource then destroy the older one

  }
  tags = {
    environment = var.environment
  }
}