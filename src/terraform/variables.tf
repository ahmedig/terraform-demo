terraform {
  backend "local" {}
}

provider "azurerm" {}

variable "subscription_id" {
  default = ""
}

variable "resource_group_name" {
  default = "myresourcegroup"
}

variable "location" {
  default = "australiaeast"
}

variable "vm_prefix" {
  default = "vm"
}

variable "tag_environment" {
  default = "dev"
}

#### Virtual Machine settings
variable "vm_count" {
  default = 2
}

variable "managed_disk_type" {
  default = "Standard_LRS"
}

variable "vm_size" {
  default = "Standard_D4s_v3"
}

variable "vm_disk_size" {
  default = "130"
}

variable "vm_username" {
  default = "testadmin"
}

variable "vm_userpassword" {
  default = "Password1234!"
}
