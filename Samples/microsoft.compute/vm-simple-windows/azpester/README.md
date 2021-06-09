# Very simple deployment of a Windows VM

[![CI vm-simple-windows](https://github.com/dupuyjs/AzPester/actions/workflows/vm-simple-windows.yml/badge.svg)](https://github.com/dupuyjs/AzPester/actions/workflows/vm-simple-windows.yml)

## Usage

```Powershell
PS C:\AzPester\Samples\microsoft.compute\vm-simple-windows\azpester> Invoke-AzPester -Definition definition.json -Parameters definition.parameters.json
```

## Output details

```Powershell
Running tests from 'C:\Projects\GitHub\AzPester\Source\Resources\Compute\VirtualMachine\VirtualMachine.Tests.ps1'
Describing Virtual Machine simple-vm Acceptance Tests
 Context Virtual Machine simple-vm
   [+] Validate virtual machine simple-vm has been provisioned 14ms (2ms|12ms)
   [+] Validate virtual machine location is westeurope 3ms (2ms|1ms)
 Context Virtual Machine simple-vm Hardware Profile
   [+] Validate virtual machine size is Standard_D2_v3 6ms (2ms|4ms)
 Context Virtual Machine simple-vm Storage Profile
   [+] Validate image reference is MicrosoftWindowsServer 9ms (5ms|4ms)
 Context Virtual Machine simple-vm Network Profile
   [+] Validate network interfaces contains myVMNic 896ms (892ms|4ms)
 Context Virtual Machine simple-vm Identity
   [+] Validate identity type is None 5ms (2ms|4ms)
 Context Virtual Machine simple-vm Auto-shutdown
   [+] Validate auto shutdown status is Disabled 12ms (5ms|8ms)

Running tests from 'C:\Projects\GitHub\AzPester\Source\Resources\Network\NetworkSecurityGroup\NetworkSecurityGroup.Tests.ps1'
Describing Network Security Group default-NSG Acceptance Tests
 Context Network Security Group default-NSG
   [+] Validate network security group default-NSG has been provisioned 7ms (2ms|5ms)
   [+] Validate network security group location is westeurope 5ms (4ms|1ms)
 Context Security Rule default-allow-3389
   [+] Validate security rule default-allow-3389 has been provisioned 6ms (2ms|4ms)
   [+] Validate security rule protocol is Tcp 2ms (2ms|1ms)
   [+] Validate security rule sourcePortRange is * 3ms (2ms|1ms)
   [+] Validate security rule destinationPortRange is 3389 4ms (3ms|1ms)
   [+] Validate security rule sourceAddressPrefix is * 13ms (12ms|1ms)
   [+] Validate security rule destinationAddressPrefix is * 4ms (3ms|1ms)
   [+] Validate security rule access is Allow 6ms (4ms|2ms)
   [+] Validate security rule priority is 1000 6ms (5ms|1ms)
   [+] Validate security rule direction is Inbound 11ms (10ms|1ms)

Running tests from 'C:\Projects\GitHub\AzPester\Source\Resources\Network\VirtualNetwork\VirtualNetwork.Tests.ps1'
Describing Virtual Network MyVNET Acceptance Tests
 Context Virtual Network MyVNET
   [+] Validate virtual network MyVNET has been provisioned 7ms (1ms|6ms)
   [+] Validate virtual network location is westeurope 2ms (2ms|1ms)
   [+] Validate virtual network address space contains 10.0.0.0/16 7ms (6ms|1ms)
   [+] Validate virtual network subnets contains Subnet subnet 2ms (1ms|1ms)
 Context Subnet Subnet
   [+] Validate subnet addressPrefix is 10.0.0.0/24 10ms (6ms|4ms)
   [+] Validate subnet networkSecurityGroup is default-NSG 1.08s (1.08s|1ms)
Tests completed in 7.89s
Tests Passed: 24, Failed: 0, Skipped: 0 NotRun: 0
```
