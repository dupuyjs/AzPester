# VNET to VNET connection

[![CI vnet-to-vnet-peering](https://github.com/dupuyjs/AzPester/actions/workflows/vnet-to-vnet-peering.yml/badge.svg)](https://github.com/dupuyjs/AzPester/actions/workflows/vnet-to-vnet-peering.yml)

## Usage

```Powershell
PS C:\AzPester\Samples\network\vnet-to-vnet-peering\azpester> Invoke-AzPester -Definition definition.json -Parameters definition.parameters.json
```

## Output details

```Powershell
Describing Virtual Network vNet1 Acceptance Tests
 Context Virtual Network vNet1
   [+] Validate virtual network vNet1 has been provisioned 18ms (10ms|8ms)
   [+] Validate virtual network location is westeurope 5ms (4ms|1ms)
   [+] Validate virtual network address space contains 10.0.0.0/24 3ms (1ms|1ms)
   [+] Validate virtual network subnets contains subnet1 subnet 3ms (2ms|1ms)
 Context Subnet subnet1
   [+] Validate subnet addressPrefix is 10.0.0.0/24 5ms (2ms|3ms)
 Context Virtual Network Peering with vNet2
   [+] Validate virtual network peering with vNet2 is connected 1.33s (1.32s|4ms)
   [+] Validate virtual network peering allowVirtualNetworkAccess is True 44ms (42ms|2ms)
   [+] Validate virtual network peering allowForwardedTraffic is False 7ms (5ms|1ms)
   [+] Validate virtual network peering allowGatewayTransit is False 6ms (5ms|1ms)
   [+] Validate virtual network peering useRemoteGateways is False 4ms (3ms|1ms)

Describing Virtual Network vNet2 Acceptance Tests
 Context Virtual Network vNet2
   [+] Validate virtual network vNet2 has been provisioned 7ms (2ms|6ms)
   [+] Validate virtual network location is westeurope 3ms (2ms|1ms)
   [+] Validate virtual network address space contains 192.168.0.0/24 2ms (1ms|1ms)
   [+] Validate virtual network subnets contains subnet1 subnet 2ms (1ms|1ms)
 Context Subnet subnet1
   [+] Validate subnet addressPrefix is 192.168.0.0/24 9ms (3ms|6ms)
 Context Virtual Network Peering with vNet1
   [+] Validate virtual network peering with vNet1 is connected 1.14s (1.14s|4ms)
   [+] Validate virtual network peering allowVirtualNetworkAccess is True 8ms (8ms|1ms)
   [+] Validate virtual network peering allowForwardedTraffic is False 4ms (3ms|1ms)
   [+] Validate virtual network peering allowGatewayTransit is False 5ms (4ms|1ms)
   [+] Validate virtual network peering useRemoteGateways is False 5ms (4ms|1ms)
Tests completed in 5.11s
Tests Passed: 20, Failed: 0, Skipped: 0 NotRun: 0
```
