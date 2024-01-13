variable "subscription_id" {
  description = "ID da Sub."
  type = string
  #default = ""
}

variable "name" {
  description = "Nome do projeto"
  type        = string
  default     = "case1"
}

variable "location" {
  description = "Zona"
  type        = string
  default     = "eastus"
}

variable "firewall-ip-static-privado" {
  type        = string
  description = "IP Privado que deseja para subir firewall"
  default = "10.0.1.4"
}

variable "spoke1-ip-static-privado" {
  type        = string
  description = "IP Privado que deseja para subir firewall"
  default = "192.0.1.5"
}

variable "spoke2-ip-static-privado" {
  type        = string
  description = "IP Privado que deseja para subir firewall"
  default = "172.0.1.5"
}

variable "username" {
    description = "Username para VM"
    default     = "azureuser"
}

variable "password" {
    description = "Password para VM"
    default     = "Qwert@12345&"
}

variable "vmsize" {
    description = "Tamanho da VM"
    default     = "Standard_DS1_v2"
}