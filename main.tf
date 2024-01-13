######### FIREWALL CONFIGURAÇÂO ###########
# Centralizando configurações do Firewall #
###########################################

############### FIREWALL ###############
resource "azurerm_firewall" "firewall" {

  name                = "Firewall-B3Digitas"
  location            = var.location
  resource_group_name = var.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall-subnet.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

############### Associar NSG na subnets ###############
resource "azurerm_subnet_network_security_group_association" "spoke1-association" {
  subnet_id                 = azurerm_subnet.spoke1-subnet.id
  network_security_group_id = azurerm_network_security_group.spoke1-nsg.id
}

resource "azurerm_subnet_network_security_group_association" "spoke2-association" {
  subnet_id                 = azurerm_subnet.spoke2-subnet.id
  network_security_group_id = azurerm_network_security_group.spoke2-nsg.id
}

############### NSG Spoke1 ###############
resource "azurerm_network_security_group" "spoke1-nsg" {
  name                = "spoke1-nsg"
  location            = var.location
  resource_group_name = var.name
  security_rule       = [
    {
      access                                     = "Allow"
      description                                = ""
      destination_address_prefix                 = "*"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "22"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "entrada-ssh"
      priority                                   = 200
      protocol                                   = "Tcp"
      source_address_prefix                      = "*"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    },
    {
      access                                     = "Deny"
      description                                = ""
      destination_address_prefix                 = "*"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "*"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "denyTcpAll"
      priority                                   = 201
      protocol                                   = "Tcp"
      source_address_prefix                      = "*"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    },
    {
      access                                     = "Allow"
      description                                = ""
      destination_address_prefix                 = "*"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "*"
      destination_port_ranges                    = []
      direction                                  = "Outbound"
      name                                       = "Saida"
      priority                                   = 200
      protocol                                   = "*"
      source_address_prefix                      = "*"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    },
  ]
}

############### NSG spoke2 ###############
resource "azurerm_network_security_group" "spoke2-nsg" {
  name                = "spoke2-nsg"
  location            = var.location
  resource_group_name = var.name
  security_rule       = [
    {
      access                                     = "Allow"
      description                                = ""
      destination_address_prefix                 = "*"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "80"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "entrada-apache2"
      priority                                   = 100
      protocol                                   = "Tcp"
      source_address_prefix                      = "*"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    },
     {
      access                                     = "Allow"
      description                                = ""
      destination_address_prefix                 = "*"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "22"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "entrada-ssh"
      priority                                   = 200
      protocol                                   = "Tcp"
      source_address_prefix                      = "*"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    },
    {
      access                                     = "Deny"
      description                                = ""
      destination_address_prefix                 = "*"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "*"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "denyTcpAll"
      priority                                   = 201
      protocol                                   = "Tcp"
      source_address_prefix                      = "*"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    },
  ]
}

############### Permite comunicação com subs atraves do firewall ###############
resource "azurerm_firewall_network_rule_collection" "firewall" {
  name                = "aceitacomunicaosubs"
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = var.name
  priority            = 200
  action              = "Allow"

  rule {
    name = "rota-all"
    source_addresses = [
      "192.0.0.0/16",
      "172.0.0.0/16",
      "10.0.0.0/16",
    ]
    destination_ports = [
      "*",
    ]
    destination_addresses = [
      "192.0.0.0/16",
      "172.0.0.0/16",
      "10.0.0.0/16",
    ]
    protocols = [
      "Any"
    ]
}
rule {
   destination_addresses = [
       "*",
     ]
   destination_ports  = [
       "*",
     ]
   name = "acesso-internet"
   protocols  = [
       "Any",
     ]
   source_addresses = [
       "*",
     ]
 }
}

############### Faz redirecionamento de porta para rede interna ###############
resource "azurerm_firewall_nat_rule_collection" "firewall" {
  name                = "regra-firewall"
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = var.name
  priority            = 200
  action              = "Dnat"

  rule {
    name = "ssh"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "22",
    ]

    destination_addresses = [
      azurerm_public_ip.firewall.ip_address
    ]

    translated_port = 22

    translated_address = var.spoke1-ip-static-privado

    protocols = [
      "TCP"
    ]
  }

  rule {
    name = "http-spoke2"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "80",
    ]

    destination_addresses = [
      azurerm_public_ip.firewall.ip_address
    ]

    translated_port = 80

    translated_address = var.spoke2-ip-static-privado

    protocols = [
      "TCP"
    ]
  }
}

#######################################
################ FIM ##################
#######################################