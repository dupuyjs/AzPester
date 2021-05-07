# Network Security Group Documentation

## Usage

```json
"definition": {
    "network": {
        "networkSecurityGroups": [
            {
                "name": "{parameters.spokeNetwork.subnetNsgName}",
                "location": "{parameters.location}",
                "securityRules": [
                    {
                        "name": "bastion-in-vnet",
                        "protocol": "Tcp",
                        "sourcePortRange": "*",
                        "destinationPortRange": [
                            "22",
                            "3389"
                        ],
                        "sourceAddressPrefix": "10.0.1.0/29",
                        "destinationAddressPrefix": "*",
                        "access": "Allow",
                        "priority": 100,
                        "direction": "Inbound"
                    },
                    {
                        "name": "DenyAllInBound",
                        "protocol": "Tcp",
                        "sourcePortRange": "*",
                        "destinationPortRange": [
                            "*"
                        ],
                        "sourceAddressPrefix": "*",
                        "destinationAddressPrefix": "*",
                        "access": "Deny",
                        "priority": 1000,
                        "direction": "Inbound"
                    }
                ],
                "defaultSecurityRules": [
                    {
                        "name": "AllowVnetInBound",
                        "protocol": "*",
                        "sourcePortRange": "*",
                        "destinationPortRange": "*",
                        "sourceAddressPrefix": "VirtualNetwork",
                        "destinationAddressPrefix": "VirtualNetwork",
                        "access": "Allow",
                        "priority": 65000,
                        "direction": "Inbound"
                    },
                    {
                        "name": "AllowAzureLoadBalancerInBound",
                        "protocol": "*",
                        "sourcePortRange": "*",
                        "destinationPortRange": "*",
                        "sourceAddressPrefix": "AzureLoadBalancer",
                        "destinationAddressPrefix": "*",
                        "access": "Allow",
                        "priority": 65001,
                        "direction": "Inbound"
                    },
                    {
                        "name": "DenyAllInBound",
                        "protocol": "*",
                        "sourcePortRange": "*",
                        "destinationPortRange": "*",
                        "sourceAddressPrefix": "*",
                        "destinationAddressPrefix": "*",
                        "access": "Deny",
                        "priority": 65500,
                        "direction": "Inbound"
                    },
                    {
                        "name": "AllowVnetOutBound",
                        "protocol": "*",
                        "sourcePortRange": "*",
                        "destinationPortRange": "*",
                        "sourceAddressPrefix": "VirtualNetwork",
                        "destinationAddressPrefix": "VirtualNetwork",
                        "access": "Allow",
                        "priority": 65000,
                        "direction": "Outbound"
                    },
                    {
                        "name": "AllowInternetOutBound",
                        "protocol": "*",
                        "sourcePortRange": "*",
                        "destinationPortRange": "*",
                        "sourceAddressPrefix": "*",
                        "destinationAddressPrefix": "Internet",
                        "access": "Allow",
                        "priority": 65001,
                        "direction": "Outbound"
                    },
                    {
                        "name": "DenyAllOutBound",
                        "protocol": "*",
                        "sourcePortRange": "*",
                        "destinationPortRange": "*",
                        "sourceAddressPrefix": "*",
                        "destinationAddressPrefix": "*",
                        "access": "Deny",
                        "priority": 65500,
                        "direction": "Outbound"
                    }
                ]
            }
        ]
    }
}
```

## Objects and Properties

### networkSecurityGroups

(Required) An array of `networkSecurityGroup` objects.

### networkSecurityGroup object

- `name`: (Required) The name of the network security group.
  - Type: string
- `context`: (Optional) The context name used for this resource. default context used if not specified.
  - Type: string

Note: You can target a subscription different than default one by using `context` property. However, you have to reference the associated subscription identifier and resource group name in the `contexts` section.

For more details about contexts, please read the [REAME.md](../../../README.md) file.

- `location`: (Optional) The location/region where the network security group has been created.
  - Type: string
- `securityRules`: (Optional) An array of `securityRule` objects.
  - Type: securityRule[]

### securityRule object

A network security group contains security rules that allow or deny inbound network traffic to, or outbound network traffic from, several types of Azure resources. For each rule, you can specify source and destination, port, and protocol.

- `protocol`: (Optional) The network protocol this rule applies to.
  - Type: string
  - Valid Values: `Tcp`,`Udp`,`Icmp`,`Esp`,`Ah` or `*`
- `sourcePortRange`: (Optional) The source port ranges. Integer or range between 0 and 65535. Asterisk '*' can also be used to match all ports.
  - Type: string or string[]
- `destinationPortRange`: (Optional) The destination port ranges. Integer or range between 0 and 65535. Asterisk '*' can also be used to match all ports.
  - Type: string or string[]
- `sourceAddressPrefix`: (Optional) The CIDR or source IP ranges. Asterisk '*' can also be used to match all source IPs. Default tags such as 'VirtualNetwork', 'AzureLoadBalancer' and 'Internet' can also be used. If this is an ingress rule, specifies where network traffic originates from.
  - Type: string or string[]
- `destinationAddressPrefix`: (Optional) The destination address prefixes. CIDR or destination IP range. Asterisk '*' can also be used to match all source IPs. Default tags such as 'VirtualNetwork', 'AzureLoadBalancer' and 'Internet' can also be used.
  - Type: string or string[]
- `access`: (Optional) Specifies whether network traffic is allowed or denied.
  - Type: string
  - Valid Values: `Allow` or `Deny`
- `priority`: (Optional) The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.
  - Type: int
- `direction`: (Optional) Specifies whether a rule is evaluated on incoming or outgoing traffic.
  - Type: string
  - Valid Values: `Inbound` or `Outbound`
