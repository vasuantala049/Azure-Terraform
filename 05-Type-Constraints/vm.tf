

resource "azurerm_resource_group" "example" {
  name     = "${var.environment}-resources"
  location = var.allowed_regions[0]
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.environment}-network"
  address_space       = ["${element(var.networking,0)}/${element(var.networking,2)}"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/${var.subnet_mask}"]
}

resource "azurerm_public_ip" "main" {
  name                = "${var.environment}-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "main" {
  name                = "${var.environment}-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.environment}-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_B2ats_v2"

  storage_image_reference {
    publisher = var.vm_config.publisher
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = var.vm_config.sku
    version   = var.vm_config.version
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
    disable_password_authentication = var.disable_pass_auth
  }
  tags = {
    environment = var.environment
    managed_by = var.tags["managed_by"]
    department = var.tags["department"]
  }
}
