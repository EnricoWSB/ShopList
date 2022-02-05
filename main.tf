terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.36.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "#"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_server" "appdb" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = random_password.password.result
}


resource "azurerm_sql_database" "db" {
  name                = var.sql_database_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  server_name         = azurerm_sql_server.appdb.name
}

resource "azurerm_virtual_network" "main" {
  name                = "wsb-network"
  address_space       = ["10.0.0.0/22"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "shoplist-public-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "main" {
  name                = "shoplist-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "shoplist-vm"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_B1ms"
  admin_username                  = "ubuntu"
  admin_password                  = random_password.password.result
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

resource "azurerm_sql_firewall_rule" "fr" {
  name                = "OnlyVM"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.appdb.name
  start_ip_address    = azurerm_linux_virtual_machine.main.public_ip_address
  end_ip_address      = azurerm_linux_virtual_machine.main.public_ip_address
}
