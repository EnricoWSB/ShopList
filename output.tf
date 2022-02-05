output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "database_name" {
  value = azurerm_sql_database.db.name
}

output "connection_string" {
  description = "Connection string for the Azure SQL Database created."
  value = "Server=tcp:${azurerm_sql_server.appdb.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.db.name};Persist Security Info=False;User ID=${var.sql_admin_username};Password=${var.sql_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive   = true
}

output "vm_public_ip" {
    value = azurerm_linux_virtual_machine.main.public_ip_address
    sensitive = true
} 
