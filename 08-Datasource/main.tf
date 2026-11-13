variable "prefix" {
  default = "tfvmex"
}

data "azurerm_resource_group" "shared_rg" {
  name = "shared-netrwork-rg" // must match with already created resource group name in azure, also same applied for all data source
}

data "azurerm_virtual_network" "shared-network" {
  name                = "shared-network" 
  resource_group_name = data.azurerm_resource_group.shared_rg.name
}

data "azurerm_subnet" "devops" {
  name                 = "devops"
  resource_group_name  = data.azurerm_resource_group.shared_rg.name
  virtual_network_name = data.azurerm_virtual_network.shared-network.name
 
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = data.azurerm_resource_group.shared_rg.location
  resource_group_name = data.azurerm_resource_group.shared_rg.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = data.azurerm_subnet.devops.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = data.azurerm_resource_group.shared_rg.location
  resource_group_name   = data.azurerm_resource_group.shared_rg.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_B2ats_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
