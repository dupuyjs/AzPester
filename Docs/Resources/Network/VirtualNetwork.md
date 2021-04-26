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
- `location`: (Optional) The location/region where the virtual network has been created.
- `enableDdosProtection`: (Optional) Specifies if DDoS protection is enabled for all the protected resources in the virtual network.
- `addressSpace`: (Optional) The address space that is used for the virtual network. Contains an array of `addressPrefix` objects that can be used by subnets.
- `subnets`: (Optional) An array of `subnet` objects defined in the virtual network.
- `virtualNetworkPeerings`: (Optional) An array of `virtualNetworkPeering` objects which targets remote virtual networks.

### addressPrefix object

- `addressPrefix`: (Required) The address prefix to use for the address space.
  
### subnet object

- `name`: (Required) The name of the subnet.
- `addressPrefix`: (Optional) The address prefix to use for the subnet.
- `networkSecurityGroup`: (Optional) A `networkSecurityGroup` object.
- `routeTable`: (Optional) A `routeTable` object.
  
### virtualNetworkPeering object

- `name`: (Required) The virtual network peering name.
- `remoteVirtualNetwork`: (Required) A `remoteVirtualNetwork` object.

### remoteVirtualNetwork object

- `name`: (Required) The remote virtual network name.
- `subscriptionId`: (Optional) The subscription identifier where is located the remote virtual network.
- `resourceGroupName`: (Optional) The resource group name where is located the remote virtual network.

Note: You can target a subsription different than default one. We will automatically detect the subscription and switch to the appropriate context.

Anyway, you have to reference this subscription identifier in the `contexts` section. If not, the following warning will be displayed:

```powershell
"Warning: Subscription $scopeSubscriptionId is unknown. This subscription should be referenced in contexts."
```

For more details about contexts, please read the [REAME.md](../../../README.md) file.

### networkSecurityGroup object

- `name`: (Required) The network security group name.
- `subscriptionId`: (Optional) The subscription identifier where is located the network security group.
- `resourceGroupName`: (Optional) The resource group name where is located the network security group.

Note: You can target a subsription different than default one. We will automatically detect the subscription and switch to the appropriate context.

Anyway, you have to reference this subscription identifier in the `contexts` section. If not, the following warning will be displayed:

```powershell
"Warning: Subscription $scopeSubscriptionId is unknown. This subscription should be referenced in contexts."
```

For more details about contexts, please read the [REAME.md](../../../README.md) file.

### routeTable object

- `name`: (Required) The route table name.
- `subscriptionId`: (Optional) The subscription identifier where is located the route table.
- `resourceGroupName`: (Optional) The resource group name where is located the route table.

Note: You can target a subsription different than default one. We will automatically detect the subscription and switch to the appropriate context.

Anyway, you have to reference this subscription identifier in the `contexts` section. If not, the following warning will be displayed:

```powershell
"Warning: Subscription $scopeSubscriptionId is unknown. This subscription should be referenced in contexts."
```

For more details about contexts, please read the [REAME.md](../../../README.md) file.
