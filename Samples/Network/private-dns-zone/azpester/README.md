# Azure private DNS zone

## Usage

```Powershell
PS C:\AzPester\Samples\network\private-dns-zone\azpester> Invoke-AzPester -Definition definition.json -Parameters definition.parameters.json
```

## Output details

```Powershell
Running tests from 'C:\Projects\GitHub\AzPester\Source\Resources\Network\PrivateDnsZone\PrivateDnsZone.Tests.ps1'
Describing Private DNS Zone contoso.com Acceptance Tests
 Context Private DNS Zone contoso.com
   [+] Validate private DNS zone contoso.com has been provisioned 10ms (5ms|5ms)
 Context Virtual Network Link contoso.com-link
   [+] Validate link contoso.com-link has been provisioned 16ms (10ms|7ms)
   [+] Validate link virtualNetwork is VNet1 966ms (965ms|1ms)
   [+] Validate link registrationEnabled is True 3ms (2ms|1ms)

Running tests from 'C:\Projects\GitHub\AzPester\Source\Resources\Network\VirtualNetwork\VirtualNetwork.Tests.ps1'
Describing Virtual Network VNet1 Acceptance Tests
 Context Virtual Network VNet1
   [+] Validate virtual network VNet1 has been provisioned 7ms (2ms|5ms)
   [+] Validate virtual network location is westeurope 3ms (2ms|1ms)
   [+] Validate virtual network address space contains 10.0.0.0/16 2ms (1ms|1ms)
   [+] Validate virtual network subnets contains App subnet 2ms (1ms|1ms)
   [+] Validate virtual network subnets contains Utility subnet 2ms (1ms|1ms)
 Context Subnet App
   [+] Validate subnet addressPrefix is 10.0.0.0/24 6ms (2ms|4ms)
 Context Subnet Utility
   [+] Validate subnet addressPrefix is 10.0.1.0/24 6ms (3ms|4ms)
Tests completed in 4.54s
Tests Passed: 11, Failed: 0, Skipped: 0 NotRun: 0
```
