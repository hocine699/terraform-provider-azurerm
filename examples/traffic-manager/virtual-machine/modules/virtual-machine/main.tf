# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "azurerm_resource_group" "example" {
  name = "${var.resource_group_name}"
}

resource "azurerm_network_interface" "example" {
  name                = "${var.prefix}-nic"
  location            = "${data.azurerm_resource_group.example.location}"
  resource_group_name = "${data.azurerm_resource_group.example.name}"

resource "azurerm_public_ip" "publicip" {
  name                = "ipmachine"
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  allocation_method = "Dynamic"

  ip_configuration {
    name                          = "example"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}

resource "azurerm_virtual_machine" "example" {
  name                          = "${var.prefix}-vm"
  location                      = "${data.azurerm_resource_group.example.location}"
  resource_group_name           = "${data.azurerm_resource_group.example.name}"
  network_interface_ids         = ["${azurerm_network_interface.example.id}"]
  vm_size                       = "Standard_DS1_v2"
  delete_os_disk_on_termination = true

 source_image_reference  {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts-gen2"
      version   = "latest"
    }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine_extension" "example" {
  name                       = "CustomScript"
  virtual_machine_id       = azurerm_virtual_machine.example.id
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = "2.0"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "commandToExecute": "sudo bash -c 'apt-get update && apt-get -y install apache2' "
    }
SETTINGS
}
