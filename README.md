# ShopList App
ShopList is a WebApp consisting of a .NET Core WebApp project and a SQL database (ORM - Entity Framework). Once the project is deployed, file migrations will be applied automatically.

## _Prerequisities_

```
terraform
git
```

## _Installation_

##### INFO
###### You can set up your own / or copy existing passwords for DB & VM in variables.tf

### Clone repo to local
```
git clone https://github.com/EnricoWSB/ShopList.git
```

### From cmd/terminal open repo location and execue following commands
```
terraform init
sh Scripts/infra.sh
```


### After executing the infa.sh, Get VM_IP_ADDRESS & login into ssh
###### `(Passwords are defined variables.tf)`
```
terraform output vm_public_ip
ssh ubuntu@{vm_public_ip}
```

### Clone repo to VM
```
git clone https://github.com/msdfib/dwa.git
cd ShopListWebApp/
```

### From local repo upload .env file
```
scp -r  {LOCAL_REPO_LOCATION}/variables.env ubuntu@[VM_IP_ADDRESS]:/home/ubuntu/REMOTE_REPO_LOCATION/variables.env
```

### Prepare docker compose on VM
More details: https://docs.docker.com/compose/install/
```
sudo apt-get update

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
	
sudo apt install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt install docker-ce docker-ce-cli containerd.io
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Run docker-compose
```
sudo docker-compose build
sudo docker-compose up -d
```

### Site should be available under 
```sh
http://${vm_public_ip}:5000/
```
