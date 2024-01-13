########### VNET E SUBNET #############
# Centralizando configurações de rede #
#######################################

############### FIREWALL NETWORK ###############
resource "azurerm_virtual_network" "firewall-network" {
  name                = "firewall-network"
  location            = var.location
  resource_group_name = var.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "firewall-subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.name
  virtual_network_name = azurerm_virtual_network.firewall-network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "firewall" {
  name                = "firewall-network-pip"
  location            = var.location
  resource_group_name = var.name
  allocation_method   = "Static"
  sku                 = "Standard"
  lifecycle {
    ignore_changes = [
      name
    ]
  }
}


############### Spoke1 ###############
resource "azurerm_virtual_network" "spoke1-network" {
  name                = "spoke1-network"
  location            = var.location
  resource_group_name = var.name
  address_space       = ["192.0.0.0/16"]
}

resource "azurerm_subnet" "spoke1-subnet" {
  name                 = "spoke1-subnet"
  resource_group_name  = var.name
  virtual_network_name = azurerm_virtual_network.spoke1-network.name
  address_prefixes     = ["192.0.1.0/27"]
}

############### Spoke2 ###############
resource "azurerm_virtual_network" "spoke2-network" {
  name                = "spoke2-network"
  location            = var.location
  resource_group_name = var.name
  address_space       = ["172.0.0.0/16"]
}

resource "azurerm_subnet" "spoke2-subnet" {
  name                 = "spoke2-network"
  resource_group_name  = var.name
  virtual_network_name = azurerm_virtual_network.spoke2-network.name
  address_prefixes     = ["172.0.1.0/28"]
}

#######################################
################ FIM ##################
#######################################