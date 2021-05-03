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
  
### virtualNetworkPeering object

- `name`: (Required) The virtual network peering name.
  - Type: string
- `remoteVirtualNetwork`: (Required) A `remoteVirtualNetwork` object.
  - Type: remoteVirtualNetwork

### remoteVirtualNetwork object

- `name`: (Required) The remote virtual network name.
  - Type: string
- `subscriptionId`: (Optional) The subscription identifier where is located the remote virtual network.
  - Type: string
- `resourceGroupName`: (Optional) The resource group name where is located the remote virtual network.
  - Type: string

Note: You can target a subsription different than default one. We will automatically detect the subscription and switch to the appropriate context.

Anyway, you have to reference this subscription identifier in the `contexts` section. If not, the following warning will be displayed:

```powershell
"Warning: Subscription $scopeSubscriptionId is unknown. This subscription should be referenced in contexts."
```

For more details about contexts, please read the [REAME.md](../../../README.md) file.

### networkSecurityGroup object

- `name`: (Required) The network security group name.
  - Type: string
- `subscriptionId`: (Optional) The subscription identifier where is located the network security group.
  - Type: string
- `resourceGroupName`: (Optional) The resource group name where is located the network security group.
  - Type: string

Note: You can target a subsription different than default one. We will automatically detect the subscription and switch to the appropriate context.

Anyway, you have to reference this subscription identifier in the `contexts` section. If not, the following warning will be displayed:

```powershell
"Warning: Subscription $scopeSubscriptionId is unknown. This subscription should be referenced in contexts."
```

For more details about contexts, please read the [REAME.md](../../../README.md) file.

### routeTable object

- `name`: (Required) The route table name.
  - Type: string
- `subscriptionId`: (Optional) The subscription identifier where is located the route table.
  - Type: string
- `resourceGroupName`: (Optional) The resource group name where is located the route table.
  - Type: string

Note: You can target a subsription different than default one. We will automatically detect the subscription and switch to the appropriate context.

Anyway, you have to reference this subscription identifier in the `contexts` section. If not, the following warning will be displayed:

```powershell
"Warning: Subscription $scopeSubscriptionId is unknown. This subscription should be referenced in contexts."
```

For more details about contexts, please read the [REAME.md](../../../README.md) file.
