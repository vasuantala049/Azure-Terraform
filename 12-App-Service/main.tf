resource "azurerm_resource_group" "appRG" {
  name = "appRG"
  location = "East Asia"
}
resource "azurerm_service_plan" "asp" {
  name = "asp"
  resource_group_name = azurerm_resource_group.appRG.name
  location = azurerm_resource_group.appRG.location
  sku_name = "S1"
  os_type = "Linux"
}
resource "azurerm_linux_web_app" "webApp" {
  name = "webApp1910"
  resource_group_name = azurerm_resource_group.appRG.name
  location = azurerm_resource_group.appRG.location
  service_plan_id = azurerm_service_plan.asp.id

  site_config {}
}
resource "azurerm_linux_web_app_slot" "slot1" {
  name = "slot1"
  app_service_id = azurerm_linux_web_app.webApp.id
  site_config {}
}