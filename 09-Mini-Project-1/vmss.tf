resource "azurerm_orchestrated_virtual_machine_scale_set" "vmss" {
  name = "vmss"
  resource_group_name = azurerm_resource_group.mini-rg.name
  location = azurerm_resource_group.mini-rg.location
  sku_name = "Standard_D2s_v4"
  instances = 3
  platform_fault_domain_count = 1
  zones = ["1"]

  user_data_base64 = base64decode(file("user-data.sh"))
  os_profile {
    linux_configuration {
        disable_password_authentication = true
        admin_username = "azureuser"
        admin_ssh_key {
            username = "azureuser"
            public_key = file("ssh-key.pub")
        }
    }
  }
  source_image_reference {
    publisher = "Cononical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-LTS-gen2"
    version = "latest"
  }
  os_disk {
    storage_account_type = "Premium_LRS"
    caching = "ReadWrite"
  }
  network_interface {
    name = "nic"
    primary = true
    ip_configuration {
        name = "ipconfig"
        primary = true
        subnet_id = azurerm_subnet.subnet-1.id
        load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bepool.id]
    }
  }
  boot_diagnostics {storage_account_uri = ""}
  lifecycle {
    ignore_changes = [ instances ]
  }
  
}