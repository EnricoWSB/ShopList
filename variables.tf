variable "resource_group_name" {
  default     = "shoplistresourcegroup"
  description = "Resource group name."
}

variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "sql_admin_username" {
   description = "The administrator username of the SQL Server."
   default = "enrico"
}

variable "sql_password" {
   description = "The administrator password of the SQL Server."
   default = "Hta5SFVEZ75r#NpX"
}

variable "vm_password" {
   description = "The administrator password of the VM."
   default = "Hta5SFVEZ75r#NpX"
}

variable "sql_server_name" {
   description = "Name of the SQL server."
   default = "sqlservershoplistwebapp"
}

variable "sql_database_name" {
   description = "Name of the SQL Database."
   default = "sqldatabaseshoplistwebapp"
}

variable "storage_account_name" {
   description = "Name of the storage account name."
   default = "storageaccshoplist"
}

variable "app_service_name" {
   description = "Name of the app server."
   default = "appserviceshoplistwebappenrico"
}