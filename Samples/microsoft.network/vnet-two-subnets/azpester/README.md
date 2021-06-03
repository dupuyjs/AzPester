# Virtual Network with two Subnets

[![CI vnet-two-subnets](https://github.com/dupuyjs/AzPester/actions/workflows/vnet-two-subnets.yml/badge.svg)](https://github.com/dupuyjs/AzPester/actions/workflows/vnet-two-subnets.yml)

## Usage

```Powershell
PS C:\AzPester\Samples\network\vnet-two-subnets\azpester> Invoke-AzPester -Definition definition.json -Parameters definition.parameters.json
```

## Output details

```Powershell
Running tests from '/home/runner/work/AzPester/AzPester/Source/Resources/Network/VirtualNetwork/VirtualNetwork.Tests.ps1'
Describing Virtual Network VNet1 Acceptance Tests
 Context Virtual Network VNet1
   [+] Validate virtual network VNet1 has been provisioned 158ms (122ms|36ms)
   [+] Validate virtual network location is westeurope 14ms (11ms|2ms)
   [+] Validate virtual network address space contains 10.0.0.0/16 10ms (8ms|2ms)
   [+] Validate virtual network subnets contains Subnet1 subnet 9ms (7ms|2ms)
   [+] Validate virtual network subnets contains Subnet2 subnet 5ms (3ms|2ms)
 Context Subnet Subnet1
   [+] Validate subnet addressPrefix is 10.0.0.0/24 13ms (10ms|3ms)
 Context Subnet Subnet2
   [+] Validate subnet addressPrefix is 10.0.1.0/24 10ms (7ms|3ms)
Tests completed in 3.6s
Tests Passed: 7, Failed: 0, Skipped: 0 NotRun: 0
```
