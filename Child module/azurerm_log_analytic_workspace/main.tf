resource "azurerm_log_analytics_workspace" "azurermloganalyticsworkspace" {
  
  name                = var.log_analytics_workspace_name
  resource_group_name = var.rg_name
  location = var.location
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
}
