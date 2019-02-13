resource "azurerm_resource_group" "resourceGroup" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"

  tags {
    Key        = "Value"
    AnotherKey = "Another Value"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# locals {
#   custom_data_content = "../scripts/Init-VirtualMachine.sh"
# }

resource "azurerm_availability_set" "availabilityset" {
  name                         = "${var.vm_prefix}${var.tag_environment}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  managed                      = true
}

resource "azurerm_network_interface" "nic" {
  count                         = "${var.vm_count}"
  name                          = "Nic-${var.vm_prefix}${var.tag_environment}${format("%02d", count.index +1)}"
  location                      = "${var.location}"
  resource_group_name           = "${var.resource_group_name}"
  enable_accelerated_networking = true
  network_security_group_id     = "${azurerm_network_security_group.networksecuritygroup.id}"

  ip_configuration {
    name                          = "ipconfig"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "vm" {
  count                         = "${var.vm_count}"
  name                          = "${var.vm_prefix}${var.tag_environment}${format("%02d", count.index +1)}"
  location                      = "${var.location}"
  resource_group_name           = "${var.resource_group_name}"
  network_interface_ids         = ["${element(azurerm_network_interface.nic.*.id, count.index)}"]
  vm_size                       = "${lookup(var.vm_properties, "vm_size")}"
  availability_set_id           = "${element(azurerm_availability_set.availabilityset.*.id, count.index)}"
  delete_os_disk_on_termination = "true"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "OSDisk-${var.vm_prefix}${var.tag_environment}${format("%02d", count.index +1)}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${lookup(var.vm_properties, "managed_disk_type")}"
    disk_size_gb      = "${lookup(var.vm_properties, "disk_size")}"
  }

  os_profile {
    computer_name  = "${var.vm_prefix}${var.tag_environment}${format("%02d", count.index +1)}"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_userpassword}"

    # custom_data    = "${file(local.custom_data_content)}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_network_security_group" "networksecuritygroup" {
  name                = "${var.vm_prefix}${var.tag_environment}-nsg"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}
