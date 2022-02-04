terraform validate
terraform apply
terraform output connection_string| sed -e 's/^/CONNECTION_STRING=/' >> variables.env