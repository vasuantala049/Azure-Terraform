output "storage_acc_name" {
    value = [for i in azurerm_storage_account.example: i.name]
  
}