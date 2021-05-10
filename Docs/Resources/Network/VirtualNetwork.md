# Virtual Network Documentation

## Usage

```json
"definition": {
    "network": {
        "virtualNetworks": [
            {
                "name": "{parameters.spokeNetwork.name}",
                "location": "{parameters.location}",
                "enableDdosProtection": false,
                "addressSpace": [
                    {
                        "addressPrefix": "{parameters.spokeNetwork.addressPrefix}"
                    }
                ],
                "subnets": [
                    {
                        "name": "{parameters.spokeNetwork.subnetName}",
                        "addressPrefix": "{parameters.spokeNetwork.subnetPrefix}",
                        "networkSecurityGroup": {
                            "name": "{parameters.spokeNetwork.subnetNsgName}"
                        },
                        "routeTable": {
                            "name": "{parameters.azureFirewall.routeName}"
                        }
                    }
                ],
                "virtualNetworkPeerings": [
                    {
                        "name": "spoke-one-to-hub",
                        "remoteVirtualNetwork": {
                            "name": "{parameters.hubNetwork.name}"
                        }
                    }
                ]
            }
        ]
    }
}
```

## Objects and Properties

### virtualNetworks

(Required) An array of `virtualNetwork` objects.

### virtualNetwork object

- `name`: (Required) The name of the virtual network.
  - Type: string
- `context`: (Optional) The context name used for this resource. default context used if not specified.
  - Type: string

Note: You can target a subscription different than default one by using `context` property. However, you have to reference the associated subscription identifier and resource group name in the `contexts` section.

For more details about contexts, please read the [REAME.md](../../../README.md) file.

- `location`: (Optional) The location/region where the virtual network has been created.
  - Type: string
- `enableDdosProtection`: (Optional) Specifies if DDoS protection is enabled for all the protected resources in the virtual network.
  - Type: boolean
- `addressSpace`: (Optional) The address space that is used for the virtual network. Contains an array of `addressPrefix` objects that can be used by subnets.
  - Type: addressPrefix[]
- `subnets`: (Optional) An array of `subnet` objects defined in the virtual network.
  - Type: subnet[]
- `virtualNetworkPeerings`: (Optional) An array of `virtualNetworkPeering` objects which targets remote virtual networks.
  - Type: virtualNetworkPeering[]

### addressPrefix object

- `addressPrefix`: (Required) The address prefix to use for the address space.
  - Type: string

### subnet object

- `name`: (Required) The name of the subnet.
  - Type: string
- `addressPrefix`: (Optional) The address prefix to use for the subnet.
  - Type: string
- `networkSecurityGroup`: (Optional) A `networkSecurityGroup` object.
  - Type: networkSecurityGroup
- `routeTable`: (Optional) A `routeTable` object.
  - Type: routeTable
- `privateEndpointNetworkPolicies`: (Optional) Enable or Disable apply network policies on private endpoint in the subnet.
  - Type: string
  - Valid values: `Enabled` or `Disabled`
- `privateLinkServiceNetworkPolicies`: (Optional) Enable or Disable apply network policies on private link service in the subnet.
  - Type: string
  - Valid Values: `Enabled` or `Disabled`

### virtualNetworkPeering object

- `name`: (Required) The virtual network peering name.
  - Type: string
- `allowVirtualNetworkAccess`: (Optional) Whether the VMs in the local virtual network space would be able to access the VMs in remote virtual network space.
  - Type: boolean
- `allowForwardedTraffic`: (Optional) Whether the forwarded traffic from the VMs in the local virtual network will be allowed/disallowed in remote virtual network.
  - Type: boolean
- `allowGatewayTransit`: (Optional) If gateway links can be used in remote virtual networking to link to this virtual network.
  - Type: boolean
- `useRemoteGateways`: (Optional) If remote gateways can be used on this virtual network.
  - Type: boolean
- `remoteVirtualNetwork`: (Required) A `remoteVirtualNetwork` object.
  - Type: remoteVirtualNetwork

### remoteVirtualNetwork object

- `name`: (Required) The remote virtual network name.
  - Type: string
- `context`: (Optional) The context name used for this resource. default context used if not specified.
  - Type: string

Note: You can target a subscription different than default one by using `context` property. However, you have to reference the associated subscription identifier and resource group name in the `contexts` section.

For more details about contexts, please read the [REAME.md](../../../README.md) file.

### networkSecurityGroup object

- `name`: (Required) The network security group name.
  - Type: string
- `context`: (Optional) The context name used for this resource. default context used if not specified.
  - Type: string

Note: You can target a subscription different than default one by using `context` property. However, you have to reference the associated subscription identifier and resource group name in the `contexts` section.

For more details about contexts, please read the [REAME.md](../../../README.md) file.

### routeTable object

- `name`: (Required) The route table name.
  - Type: string
- `context`: (Optional) The context name used for this resource. default context used if not specified.
  - Type: string

Note: You can target a subscription different than default one by using `context` property. However, you have to reference the associated subscription identifier and resource group name in the `contexts` section.

For more details about contexts, please read the [REAME.md](../../../README.md) file.
