resource "azurerm_network_interface" "spoke2-nic" {
  name                = "spoke2-nic"
  location            = var.location
  resource_group_name = var.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke2-subnet.id
    #private_ip_address_allocation = "Dynamic"
    private_ip_address_allocation = "Static"
    private_ip_address            = var.spoke2-ip-static-privado
  }
  lifecycle {
    ignore_changes = [
      name,
      ip_configuration["name"]
    ]
  }
}

resource "azurerm_linux_virtual_machine" "spoke2-vm" {
  name                = "spoke2-vm"
  resource_group_name = var.name
  location            = var.location
  size                = var.vmsize
  admin_username      = var.username
  admin_password      = var.password
  network_interface_ids = [
    azurerm_network_interface.spoke2-nic.id,
  ]

  disable_password_authentication = false
  # admin_ssh_key {
  #   username   = var.username
  #   public_key = file("C:/Users/geank/.ssh/id_rsa.pub")
  # }

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

resource "time_sleep" "wait_90_seconds" {
  depends_on = [azurerm_linux_virtual_machine.spoke2-vm]

  create_duration = "90s"
}

resource "azurerm_virtual_machine_extension" "spoke2-run" {
  depends_on=[time_sleep.wait_90_seconds]

  name                 = "spoke2-run"
  virtual_machine_id   = azurerm_linux_virtual_machine.spoke2-vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
 {
  "commandToExecute": "wget https://raw.githubusercontent.com/geantrevisan/az-fw-spoke/main/extra/run.sh; sudo chmod 777 run.sh;./run.sh;"
 }
SETTINGS

}