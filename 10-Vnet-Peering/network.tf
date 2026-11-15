resource "azurerm_resource_group" "rg" {
  name = "peeringRG"
  location = "East Asia"
}
resource "azurerm_virtual_network" "vnet1" {
    name = "vnet1"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "sbnt1" {
    name = "subnet1"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes = ["10.0.0.0/24"]
}
resource "azurerm_virtual_network" "vnet2" {
    name = "vnet2"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = ["10.1.0.0/16"]
}
resource "azurerm_subnet" "sbnt2" {
    name = "subnet2"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes = ["10.1.0.0/24"]
}
# resource "azurerm_virtual_network_peering" "peer1to2" {
#   name = "peer1to2"
#   resource_group_name = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet1.name
#   remote_virtual_network_id = azurerm_virtual_network.vnet2.id
# }
resource "azurerm_virtual_network_peering" "peer2to1" {
  name = "peer2to1"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
}