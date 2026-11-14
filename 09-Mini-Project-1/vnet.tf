resource "azurerm_resource_group" "mini-rg" {
  name = "project-rg"
  location = "East Asia"
  
}
resource "azurerm_virtual_network" "vnet-1" {
  name = "vnet-1"
  resource_group_name = azurerm_resource_group.mini-rg.name
  location = azurerm_resource_group.mini-rg.location
  address_space = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "subnet-1" {
  virtual_network_name = azurerm_virtual_network.vnet-1.name
  name = "subnet-1"
  resource_group_name = azurerm_resource_group.mini-rg.name
  address_prefixes = [ "10.0.0.0/20" ]
  
}
resource "azurerm_network_security_group" "myNSG" {
  name = "myNSG"
  location = azurerm_resource_group.mini-rg.location
  resource_group_name = azurerm_resource_group.mini-rg.name
  security_rule {
    name = "allow-http"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name = "allow-https"
    priority = 101
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "443"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name = "allow-ssh"
    priority = 102
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "subnetNSGassociation" {
  subnet_id = azurerm_subnet.subnet-1.id
  network_security_group_id = azurerm_network_security_group.myNSG.id
  
}
resource "azurerm_public_ip" "lb-publicip" {
  name                = "lb-publicip"
  resource_group_name = azurerm_resource_group.mini-rg.name
  location            = azurerm_resource_group.mini-rg.location
  allocation_method   = "Static"
  sku = "Standard"
  zones = ["1","2","3"]
  domain_name_label = "${azurerm_resource_group.mini-rg.name}-098"

}
resource "azurerm_lb" "mylb" {
    name = "myAzureLB098"
  location = azurerm_resource_group.mini-rg.location
  resource_group_name = azurerm_resource_group.mini-rg.name
  sku = "Standard"
  frontend_ip_configuration {
    name = "myPublicIp"
    public_ip_address_id = azurerm_public_ip.lb-publicip.id
  }
}
resource "azurerm_lb_backend_address_pool" "bepool" {
    name = "lb-backeend-pool"
  loadbalancer_id = azurerm_lb.mylb.id
  
}
resource "azurerm_lb_rule" "lbrule" {
  name = "lbrule"
  loadbalancer_id = azurerm_lb.mylb.id
  protocol = "Tcp"
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.bepool.id]
  frontend_port = "80"
  backend_port = "80"
  frontend_ip_configuration_name = "myPublicIp"
}

resource "azurerm_lb_probe" "lb-probe" {
  name = "lb-probe"
  loadbalancer_id = azurerm_lb.mylb.id
  protocol = "Http"
  port = 80
  request_path = "/"
}
resource "azurerm_lb_nat_rule" "ssh" { 
  resource_group_name = azurerm_resource_group.mini-rg.name
  loadbalancer_id = azurerm_lb.mylb.id
  name = "ssg"
  protocol = "Tcp"
  frontend_port_start = 50000
  frontend_port_end = 50119
  backend_port = 22
  frontend_ip_configuration_name = "myPublicIp"  
  backend_address_pool_id = azurerm_lb_backend_address_pool.bepool.id
}
resource "azurerm_public_ip" "natPublicip" {
  name = "natPublicip"
  resource_group_name = azurerm_resource_group.mini-rg.name 
  location = azurerm_resource_group.mini-rg.location
  allocation_method = "Static"
  sku = "Standard"
  zones = ["1"]
}
resource "azurerm_nat_gateway" "natGateway" {
  name = "NatGateWay"
  resource_group_name = azurerm_resource_group.mini-rg.name
  location = azurerm_resource_group.mini-rg.location
  idle_timeout_in_minutes = 10
  sku_name = "Standard"
  zones = ["1"] 
}
resource "azurerm_subnet_nat_gateway_association" "subnetNatAssociation" {
  nat_gateway_id = azurerm_nat_gateway.natGateway.id
  subnet_id = azurerm_subnet.subnet-1.id
}
resource "azurerm_nat_gateway_public_ip_association" "NatPublicIpAssociation" {
  nat_gateway_id = azurerm_nat_gateway.natGateway.id
  public_ip_address_id = azurerm_public_ip.natPublicip.id
}