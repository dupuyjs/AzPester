# Virtual Network with two Subnets

## Usage

```Powershell
PS C:\AzPester\Samples\network\vnet-two-subnets\azpester> Invoke-AzPester -Definition definition.json -Parameters definition.parameters.json
```

## Output details

```Powershell
Describing Virtual Network VNet1 Acceptance Tests
 Context Virtual Network VNet1
   [+] Validate virtual network VNet1 has been provisioned 66ms (56ms|9ms)
   [+] Validate virtual network location is westeurope 85ms (81ms|4ms)
   [+] Validate virtual network address space contains 10.0.0.0/16 64ms (63ms|1ms)
   [+] Validate virtual network subnets contains Subnet1 subnet 64ms (62ms|2ms)
   [+] Validate virtual network subnets contains Subnet2 subnet 4ms (2ms|2ms)
 Context Subnet Subnet1
   [+] Validate subnet addressPrefix is 10.0.0.0/24 69ms (63ms|6ms)
 Context Subnet Subnet2
   [+] Validate subnet addressPrefix is 10.0.1.0/24 7ms (3ms|4ms)
Tests completed in 6.91s
Tests Passed: 7, Failed: 0, Skipped: 0 NotRun: 0
```
