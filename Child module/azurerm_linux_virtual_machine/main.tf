data "azurerm_subnet" "frontend-subnet" {
  name                 = var.frontend-subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.rg_name
}


resource "azurerm_network_interface" "nic1" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.frontend-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "frontend-vm" {
  name                = var.frontend_vm_name
  resource_group_name = var.rg_name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password = "Mitelhcl@123"

  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.nic1.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

