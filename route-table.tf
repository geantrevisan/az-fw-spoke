############# Roteamento ##############
# Aqui iremos criar peering para      #
# comunicação de cada vnet e          #
# roteamento para se comunicarem      #
# realizando gateway                  #
# saida para firewall                 #
#######################################

############### Peering´s ###############

resource "azurerm_virtual_network_peering" "spoke1-firewall" {
  name = "spoke1-firewall"
  virtual_network_name = azurerm_virtual_network.spoke1-network.name
  remote_virtual_network_id = azurerm_virtual_network.firewall-network.id
  resource_group_name = var.name
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "firewall-spoke1" {
  name = "firewall-spoke1"
  virtual_network_name = azurerm_virtual_network.firewall-network.name
  remote_virtual_network_id = azurerm_virtual_network.spoke1-network.id
  resource_group_name = var.name
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "spoke2-firewall" {
  name = "spoke2-firewall"
  virtual_network_name = azurerm_virtual_network.spoke2-network.name
  remote_virtual_network_id = azurerm_virtual_network.firewall-network.id
  resource_group_name = var.name
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "firewall-spoke2" {
  name = "firewall-spoke2"
  virtual_network_name = azurerm_virtual_network.firewall-network.name
  remote_virtual_network_id = azurerm_virtual_network.spoke2-network.id
  resource_group_name = var.name
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
}

############### Route Tables ###############

############### Spoke1 e 2 Route Tables ###############
resource "azurerm_route_table" "spoke1e2-route-table" {
  name                          = "spoke1e2-route-table"
  location                      = var.location
  resource_group_name           = var.name
  route                         = [
          {
              address_prefix         = "192.0.0.0/16"
              name                   = "spoke1-vnet"
              next_hop_in_ip_address = var.firewall-ip-static-privado
              next_hop_type          = "VirtualAppliance"
            },
          {
              address_prefix         = "172.0.0.0/16"
              name                   = "spoke2-vnet"
              next_hop_in_ip_address = var.firewall-ip-static-privado
              next_hop_type          = "VirtualAppliance"
            },
            {
              address_prefix         = "0.0.0.0/0"
              name                   = "internet"
              next_hop_in_ip_address = var.firewall-ip-static-privado
              next_hop_type          = "VirtualAppliance"
            }
        ]
}

############### Route Tables Associar subnets ###############
resource "azurerm_subnet_route_table_association" "spoke1e2-route-table1" {
  subnet_id      = azurerm_subnet.spoke1-subnet.id
  route_table_id = azurerm_route_table.spoke1e2-route-table.id
}
resource "azurerm_subnet_route_table_association" "spoke1e2-route-table2" {
  subnet_id      = azurerm_subnet.spoke2-subnet.id
  route_table_id = azurerm_route_table.spoke1e2-route-table.id
}

#######################################
################ FIM ##################
#######################################