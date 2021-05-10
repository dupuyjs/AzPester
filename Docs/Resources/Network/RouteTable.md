# Route Table Documentation

## Usage

```json
"definition": {
    "network": {
        "routeTables": [
            {
                "name": "{parameters.azureFirewall.routeName}",
                "location": "{parameters.location}",
                "routes": [{
                    "name": "{parameters.azureFirewall.routeName}",
                    "addressPrefix": "0.0.0.0/0",
                    "nextHopType": "VirtualAppliance",
                    "nextHopIpAddress": "10.0.3.4"
                }]
            }
        ]
    }
}
```

## Objects and Properties

### routeTables

(Required) An array of `routeTable` objects.

### routeTable object

- `name`: (Required) The name of the route table.
  - Type: string
- `context`: (Optional) The context name used for this resource. default context used if not specified.
  - Type: string

Note: You can target a subscription different than default one by using `context` property. However, you have to reference the associated subscription identifier and resource group name in the `contexts` section.

For more details about contexts, please read the [REAME.md](../../../README.md) file.

- `location`: (Optional) The location of the route table.
  - Type: string
- `routes`: (Optional) List of all routes. Contains an array of `route` objects.
  - Type: route[]

### route object

- `name`: (Required) The route name.
  - Type: string
- `addressPrefix`: (Optional) The destination CIDR to which the route applies.
  - Type: string
- `nextHopType`: (Optional) The type of Azure hop the packet should be sent to.
  - Type: string
  - Valid Values: `VirtualNetworkGateway`, `VnetLocal` `Internet`, `VirtualAppliance` or `None`
- `nextHopIpAddress`: (Optional) The IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance.
  - Type: string
