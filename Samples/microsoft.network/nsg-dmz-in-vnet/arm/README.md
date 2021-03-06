# Multi tier VNet with NSGs and DMZ

This template creates a VNet with 3 subnets:

* **Frontend** - _FESubnet / 10.0.0.0/24_
* **Application** - _AppSubnet / 10.0.1.0/24_
* **Database** - _DBSubnet / 10.0.2.0/24_

It also creates three Network Security Groups - one per subnet:

* **Frontend** - _FE_NSG_
* **Application** - _App_NSG_
* **Database** - _DB_NSG_

Each NSG is then associated with a subnet:

* _FESubnet_ to _FE_NSG_
* _AppSubnet_ to _App_NSG_
* _DBSubnet_ to _DB_NSG_

It creates DMZ rules for the App subnet to expose endpoints to the Internet. It secures the App subnet and the Database subnet with appropriate rules. It blocks Outbound Internet access to VMs in the App and Database subnets. It opens up the Database Subnet only on port 1433 the App Subnet.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdupuyjs%2FAzPester%2Fmain%2FSamples%2Fmicrosoft.network%2Fnsg-dmz-in-vnet%2Farm%2Fazuredeploy.json)

The template used in this samples section is from [Azure Quickstart templates](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.network/nsg-dmz-in-vnet).
