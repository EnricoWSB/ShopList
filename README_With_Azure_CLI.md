# Prepare local environment

```
git clone https://github.com/EnricoWSB/ShopList
cd shoplist
git branch -m main
```

# Prerequisites
- Azure account
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
-  Entity Framework 
```
# Run the following command in the project directory
dotnet tool install -g dotnet-ef
```

# Prepare SQL Database (Azure)

Create resource group
```
az group create --name <myResourceGroup> --location "West Europe"
```

Create SQL Database server
```
az sql server create --name <server-name> --resource-group <myResourceGroup> --location "West Europe" --admin-user <db-username> --admin-password <db-password>
```

Firewall configuration
```
# This will only allow you to connect to the server with the ip azure

az sql server firewall-rule create --resource-group <myResourceGroup> --server <server-name> --name AllowAzureIps --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0
```

Create Database

```
az sql db create --resource-group <myResourceGroup> --server <server-name> --name <db-name> --service-objective S0
```

Get connection params
```
az sql db show-connection-string --client ado.net --server <server-name> --name <db-name>
```

In project directory set up new database migration and connection string

```
# Recreate migrations with UseSqlServer (see previous snippet)
dotnet ef migrations add InitialCreate

# Set connection string to production database
# PowerShell
$env:CONNECTION_STRING="<connection-string>"
# CMD (no quotes)
set CONNECTION_STRING=<connection-string>
# Bash (no quotes)
export CONNECTION_STRING=<connection-string>

# Run migrations
dotnet ef database update
```

Create service plan
```
az appservice plan create --name <servicePlanName> --resource-group shoplist --location "West Europe" --sku FREE --is-linux
```

# Deploy App to Azure

Set up deployment user
```
az webapp deployment user set --user-name <username> --password <password>
```

Create app in Azure
```
After executing following command you will get GIT url for the app - save the url

az webapp create --resource-group shoplist --plan <servicePlanName> --name <appName> --runtime 'DOTNET|5.0' --deployment-local-git
```

Configure connection parameters
```
#Get connection params / connection string
az sql db show-connection-string --client ado.net --server <server-name> --name <db-name>

#Place above connection string to the following command
az webapp config connection-string set --resource-group <myResourceGroup> --name <app-name> --settings MyDbConnection='<connection-string>' --connection-string-type SQLAzure
```

Set up web app deployment branch (default = master for VS2019)
```
az webapp config appsettings set --name <app-name> --resource-group <myResourceGroup> --settings DEPLOYMENT_BRANCH='main'
```

Set up GIT URL & deploy the app
```
 git remote set-url origin <GIT-url-for-the-app>
 git push -u origin main
```

App should be avaiable under the link
```
http://<app-name>.azurewebsites.net
```
