resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.vnet_location
  resource_group_name = var.rg_name
  address_space       = ["10.0.0.0/16"]
}

 