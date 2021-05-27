# Private DNS Zone documentation

## Usage

```json
"definition": {
    "network": {
        "privateDnsZones": [
            {
                "name": "{parameters.privateDnsZoneName}",
                "virtualNetworkLinks": [
                    {
                        "name": "{parameters.virtualNetworkLinkName}",
                        "virtualNetworkName": "{parameters.virtualNetworkLinkVnetName}",
                        "registrationEnabled": false
                    }
                ]
            }
        ]
    }
}
```

## Objects and Properties

### privateDnsZones

(Required) An array of `privateDnsZone` objects.

### privateDnsZone

- `name`: (Required) The name of the private DNS zone.
- `context`: (Optional) The context name used for this resource.
- `virtualNetworkLinks`: (Optional) An array of `virtualNetworkLink` objects.

### virtualNetworkLink

- `name`: (Required) The name of the virtual network link.
- `context`: (Optional) The context name used for this resource.
- `virtualNetworkName`: (Required) The name of the linked virtual network.
- `registrationEnabled`: (Optional) Is auto-registration enabled.
