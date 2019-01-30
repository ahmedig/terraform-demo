terraform {
  backend "local" {}

  # You can put your storage account details that will hold the state file.
  # https://www.terraform.io/docs/backends/types/azurerm.html
  # backend "azurerm" {
  #   storage_account_name = "abcd1234"
  #   container_name       = "tfstate"
  #   key                  = "terraform.tfstate"
  #   access_key           = "STORAGE ACCOUNT ACCESS KEY"
  # }
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

variable "vm_properties" {
  type = "map"

  default = {
    disk_size         = "130"
    vm_size           = "Standard_B1s"
    managed_disk_type = "Standard_LRS"
  }
}

variable "vm_username" {
  default = "testadmin"
}

variable "vm_userpassword" {
  default = "Password1234!"
}
