
module "azurerm_resource_group" {
  source      = "../../Child module/azurerm_resource_group"
  rg_name     = "rg-todoapp"
  rg_location = "centralindia"

module "azurerm_virtual_network" {
  source        = "../../Child module/azurerm_virtual_network"
  depends_on    = [module.azurerm_resource_group]
  vnet_name     = "vnet1"
  vnet_location = "centralindia"
  rg_name       = "rg-todoapp"
}
#frontend subnet
module "azurerm_frontend_subnet" {
  depends_on       = [module.azurerm_virtual_network]
  source           = "../../Child module/azurerm_subnet"
  subnet_name      = "frontend-subnet"
  rg_name          = "rg-todoapp"
  vnet_name        = "vnet1"
  address_prefixes = ["10.0.1.0/24"]

}
#backend subnet

module "azurerm_backend_subnet" {
  depends_on       = [module.azurerm_virtual_network]
  source           = "../../Child module/azurerm_subnet"
  subnet_name      = "backend-subnet"
  rg_name          = "rg-todoapp"
  vnet_name        = "vnet1"
  address_prefixes = ["10.0.2.0/24"]


}
#frontend vm 
module "frontend_vm" {
  depends_on           = [module.azurerm_frontend_subnet]
  source               = "../../Child module/azurerm_linux_virtual_machine"
  frontend_vm_name     = "frontend-vm1"
  vnet_name            = "vnet12"
  rg_name              = "rg-todoapp"
  location             = "centralIndia"
  nic_name             = "frontend-nic"
  frontend-subnet_name = "frontend-subnet"
}

#backend vm
module "backend_vm" {
  depends_on           = [module.azurerm_backend_subnet]
  source               = "../../Child module/azurerm_linux_virtual_machine"
  frontend_vm_name     = "backend-vm"
  rg_name              = "rg-todoapp"
  location             = "centralIndia"
  nic_name             = "backend_nic"
  frontend-subnet_name = "backend-subnet"
  vnet_name            = "vnet1"

}

#SQL server
module "sql_server" {
  depends_on                   = [module.azurerm_resource_group]
  source                       = "../../Child module/azurerm_sql_server"
  sql_server_name              = "mysql-server-vandana"
  resource_group_name          = "rg-todoapp"
  location                     = "centralIndia"
  administrator_login          = "mysqladmin"
  administrator_login_password = "Mitehcl@123"

}
#SQL database
module "sql_database" {
  depends_on          = [module.sql_server]
  source              = "../../Child module/azurerm_sql_database"
  sql_server_name     = "mysql-server-vandana"
  resource_group_name = "rg-todoapp"
  sql_database_name   = "sql_database_name-vandana"

}
# Log Analytics Workspace
module "log_analytics_workspace" {
  depends_on                   = [module.azurerm_resource_group]  
  source                     = "../../Child module/azurerm_log_analytic_workspace"
  log_analytics_workspace_name = "log-analytics-workspace-vandana"
  rg_name        = "rg-todoapp"
  location                   = "centralIndia"
  sku                        = "PerGB2018"
  retention_in_days          = 30
}




