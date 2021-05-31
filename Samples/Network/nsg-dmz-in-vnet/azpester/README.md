# Multi tier VNet with NSGs and DMZ

## Usage

```Powershell
PS C:\AzPester\Samples\network\nsg-dmz-in-vnet\azpester> Invoke-AzPester -Definition definition.json -Parameters definition.parameters.json
```

## Output details

```Powershell
Describing Network Security Group FE_NSG Acceptance Tests
 Context Network Security Group FE_NSG
   [+] Validate network security group FE_NSG has been provisioned 7ms (2ms|5ms)
   [+] Validate network security group location is westeurope 3ms (2ms|1ms)
 Context Security Rule rdp_rule
   [+] Validate security rule rdp_rule has been provisioned 6ms (2ms|5ms)
   [+] Validate security rule protocol is Tcp 3ms (2ms|1ms)
   [+] Validate security rule sourcePortRange is * 3ms (3ms|1ms)
   [+] Validate security rule destinationPortRange is 3389 4ms (3ms|1ms)
   [+] Validate security rule sourceAddressPrefix is Internet 3ms (2ms|1ms)
   [+] Validate security rule destinationAddressPrefix is * 9ms (8ms|1ms)
   [+] Validate security rule access is Allow 4ms (3ms|2ms)
   [+] Validate security rule priority is 100 6ms (5ms|1ms)
   [+] Validate security rule direction is Inbound 4ms (3ms|1ms)
 Context Security Rule web_rule
   [+] Validate security rule web_rule has been provisioned 4ms (1ms|3ms)
   [+] Validate security rule protocol is Tcp 3ms (2ms|1ms)
   [+] Validate security rule sourcePortRange is * 4ms (3ms|1ms)
   [+] Validate security rule destinationPortRange is 80 5ms (4ms|1ms)
   [+] Validate security rule sourceAddressPrefix is Internet 4ms (3ms|1ms)
   [+] Validate security rule destinationAddressPrefix is * 4ms (3ms|1ms)
   [+] Validate security rule access is Allow 11ms (9ms|1ms)
   [+] Validate security rule priority is 101 5ms (3ms|1ms)
   [+] Validate security rule direction is Inbound 6ms (4ms|2ms)

Describing Network Security Group App_NSG Acceptance Tests
 Context Network Security Group App_NSG
   [+] Validate network security group App_NSG has been provisioned 9ms (2ms|7ms)
   [+] Validate network security group location is westeurope 3ms (2ms|1ms)
 Context Security Rule Allow_FE
   [+] Validate security rule Allow_FE has been provisioned 6ms (2ms|4ms)
   [+] Validate security rule protocol is Tcp 8ms (3ms|5ms)
   [+] Validate security rule sourcePortRange is * 4ms (3ms|1ms)
   [+] Validate security rule destinationPortRange is 443 4ms (3ms|1ms)
   [+] Validate security rule sourceAddressPrefix is 10.0.0.0/24 3ms (2ms|1ms)
   [+] Validate security rule destinationAddressPrefix is * 13ms (12ms|1ms)
   [+] Validate security rule access is Allow 4ms (3ms|2ms)
   [+] Validate security rule priority is 100 3ms (2ms|1ms)
   [+] Validate security rule direction is Inbound 5ms (4ms|1ms)
 Context Security Rule Block_RDP_Internet
   [+] Validate security rule Block_RDP_Internet has been provisioned 7ms (3ms|5ms)
   [+] Validate security rule protocol is Tcp 3ms (2ms|1ms)
   [+] Validate security rule sourcePortRange is * 3ms (2ms|1ms)
   [+] Validate security rule destinationPortRange is 3389 10ms (3ms|6ms)
   [+] Validate security rule sourceAddressPrefix is Internet 4ms (3ms|1ms)
   [+] Validate security rule destinationAddressPrefix is * 3ms (3ms|1ms)
   [+] Validate security rule access is Deny 4ms (3ms|2ms)
   [+] Validate security rule priority is 101 12ms (11ms|1ms)
   [+] Validate security rule direction is Inbound 5ms (4ms|1ms)
 Context Security Rule Block_Internet_Outbound
   [+] Validate security rule Block_Internet_Outbound has been provisioned 7ms (2ms|5ms)
   [+] Validate security rule protocol is * 4ms (2ms|2ms)
   [+] Validate security rule sourcePortRange is * 4ms (3ms|1ms)
   [+] Validate security rule destinationPortRange is * 5ms (4ms|1ms)
   [+] Validate security rule sourceAddressPrefix is * 13ms (12ms|1ms)
   [+] Validate security rule destinationAddressPrefix is Internet 5ms (4ms|1ms)
   [+] Validate security rule access is Deny 3ms (2ms|1ms)
   [+] Validate security rule priority is 200 5ms (3ms|1ms)
   [+] Validate security rule direction is Outbound 13ms (12ms|1ms)

Describing Network Security Group DB_NSG Acceptance Tests
 Context Network Security Group DB_NSG
   [+] Validate network security group DB_NSG has been provisioned 7ms (2ms|5ms)
   [+] Validate network security group location is westeurope 3ms (2ms|1ms)
 Context Security Rule Allow_App
   [+] Validate security rule Allow_App has been provisioned 7ms (2ms|5ms)
   [+] Validate security rule protocol is Tcp 8ms (3ms|5ms)
   [+] Validate security rule sourcePortRange is * 4ms (3ms|1ms)
   [+] Validate security rule destinationPortRange is 1433 5ms (3ms|1ms)
   [+] Validate security rule sourceAddressPrefix is 10.0.1.0/24 3ms (2ms|1ms)
   [+] Validate security rule destinationAddressPrefix is * 14ms (11ms|2ms)
   [+] Validate security rule access is Allow 5ms (4ms|1ms)
   [+] Validate security rule priority is 100 3ms (3ms|1ms)
   [+] Validate security rule direction is Inbound 4ms (3ms|1ms)
 Context Security Rule Block_FE
   [+] Validate security rule Block_FE has been provisioned 5ms (2ms|4ms)
   [+] Validate security rule protocol is * 4ms (3ms|1ms)
   [+] Validate security rule sourcePortRange is * 4ms (3ms|1ms)
   [+] Validate security rule destinationPortRange is * 4ms (3ms|1ms)
   [+] Validate security rule sourceAddressPrefix is 10.0.0.0/24 3ms (2ms|1ms)
   [+] Validate security rule destinationAddressPrefix is * 6ms (5ms|2ms)
   [+] Validate security rule access is Deny 5ms (3ms|1ms)
   [+] Validate security rule priority is 101 5ms (3ms|2ms)
   [+] Validate security rule direction is Inbound 8ms (6ms|1ms)
 Context Security Rule Block_App
   [+] Validate security rule Block_App has been provisioned 8ms (2ms|6ms)
   [+] Validate security rule protocol is * 3ms (2ms|1ms)
   [+] Validate security rule sourcePortRange is * 13ms (12ms|1ms)
   [+] Validate security rule destinationPortRange is * 6ms (5ms|1ms)
   [+] Validate security rule sourceAddressPrefix is 10.0.1.0/24 5ms (3ms|2ms)
   [+] Validate security rule destinationAddressPrefix is * 5ms (4ms|1ms)
   [+] Validate security rule access is Deny 12ms (11ms|1ms)
   [+] Validate security rule priority is 102 6ms (5ms|1ms)
   [+] Validate security rule direction is Inbound 4ms (3ms|1ms)
 Context Security Rule Block_Internet
   [+] Validate security rule Block_Internet has been provisioned 6ms (2ms|4ms)
   [+] Validate security rule protocol is * 2ms (2ms|1ms)
   [+] Validate security rule sourcePortRange is * 3ms (3ms|1ms)
   [+] Validate security rule destinationPortRange is * 11ms (10ms|1ms)
   [+] Validate security rule sourceAddressPrefix is * 3ms (3ms|1ms)
   [+] Validate security rule destinationAddressPrefix is Internet 4ms (3ms|1ms)
   [+] Validate security rule access is Deny 5ms (3ms|1ms)
   [+] Validate security rule priority is 200 6ms (4ms|1ms)
   [+] Validate security rule direction is Outbound 5ms (3ms|1ms)

Describing Virtual Network First_ARM_VNet Acceptance Tests
 Context Virtual Network First_ARM_VNet
   [+] Validate virtual network First_ARM_VNet has been provisioned 7ms (2ms|5ms)
   [+] Validate virtual network location is westeurope 3ms (2ms|1ms)
   [+] Validate virtual network address space contains 10.0.0.0/16 2ms (1ms|1ms)
   [+] Validate virtual network subnets contains FESubnet subnet 2ms (1ms|1ms)
   [+] Validate virtual network subnets contains AppSubnet subnet 3ms (2ms|1ms)
   [+] Validate virtual network subnets contains DBSubnet subnet 3ms (1ms|1ms)
 Context Subnet FESubnet
   [+] Validate subnet addressPrefix is 10.0.0.0/24 5ms (3ms|2ms)
   [+] Validate subnet networkSecurityGroup is FE_NSG 850ms (848ms|1ms)
 Context Subnet AppSubnet
   [+] Validate subnet addressPrefix is 10.0.1.0/24 6ms (3ms|4ms)
   [+] Validate subnet networkSecurityGroup is App_NSG 726ms (726ms|1ms)
 Context Subnet DBSubnet
   [+] Validate subnet addressPrefix is 10.0.2.0/24 6ms (2ms|4ms)
   [+] Validate subnet networkSecurityGroup is DB_NSG 987ms (986ms|1ms)
Tests completed in 9.01s
Tests Passed: 99, Failed: 0, Skipped: 0 NotRun: 0
```
