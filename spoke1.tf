resource "azurerm_network_interface" "spoke1-nic" {
  name                = "spoke1-nic"
  location            = var.location
  resource_group_name = var.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke1-subnet.id
    #private_ip_address_allocation = "Dynamic"
    private_ip_address_allocation = "Static"
    private_ip_address            = var.spoke1-ip-static-privado
  }
  lifecycle {
    ignore_changes = [
      name,
      ip_configuration["name"]
    ]
  }
}

resource "azurerm_linux_virtual_machine" "spoke1-vm" {
  name                = "spoke1-vm"
  resource_group_name = var.name
  location            = var.location
  size                = var.vmsize
  admin_username      = var.username
  admin_password      = var.password
  network_interface_ids = [
    azurerm_network_interface.spoke1-nic.id,
  ]
  disable_password_authentication = false
  # admin_ssh_key {
  #   username   = var.username
  #   public_key = file("C:/Users/geank/.ssh/id_rsa.pub")
  # }

  os_disk {
    name                 = "spoke1-disk"
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