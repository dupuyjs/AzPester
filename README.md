# AzPester

AzPester is a superset framework built on top of [Pester](https://github.com/pester/Pester) to validate Azure environments. You have just to define your target infrastucture using a json definition file and AzPester will evaluate if your cloud environment is alligned.

AzPester will only read Azure resource. No change can be made.  

## Requirements

- PowerShell 7.1 (version >= 7.1.3)
  - [Installing various versions of PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.1)
- Powershell Modules:
  - Az (version >= 5.8.0)
  - Az.ManagedServiceIdentity (version >= 0.7.3)
  - Pester (version >= 5.1.1)

Note: Version requirements reflects our development environment installation. It can probably work with earlier versions but has not been tested.

## Installation

```powershell
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Find-Module -Name Az | Install-Module -Scope CurrentUser
Find-Module -Name Az.ManagedServiceIdentity | Install-Module -Scope CurrentUser
Find-Module -Name Pester | Install-Module -Scope CurrentUser
```

And clone the repository.

```powershell
git clone https://github.com/dupuyjs/AzPester.git
```

This framework cannot be packaged as a standalone Powershell module as *.Tests.p1 files used by Pester should be located in a child repository from where you invoke `Invoke-AzPester` command.

## Usage

### Declare a definition file

Update `subscriptionId` and `resourceGroupName` with appropriate values.

```json
{
    "$schema": "../../Source/Schemas/2021-04/schema.definition.json",
    "contentVersion": "1.0.0.0",
    "contexts": {
        "default": {
            "subscriptionId": "__SUBSCRIPTION_ID__",
            "resourceGroupName": "__RESOURCE_GROUP_NAME__"
        }
    },
    "definition": {
        "network": {
            "virtualNetworks": [
                {
                    "name": "vnet-hub",
                    "location": "northeurope"
                }
            ]
        }
    }
}
```

### Invoke AzPester using the definition file

```powershell
PS C:\AzPester> Import-Module .\Source\AzPester.psm1
PS C:\AzPester> Connect-AzAccount 
PS C:\AzPester> Invoke-AzPester -Definition definition.json
```

![Output Screen Capture](./Docs/Images/output-101.png)

## Parameters

You can declare an array of `parameter` objects in your definition file. `type` property is required, and `defaultValue` optional.

These parameters can then be used in the definition file using the syntax `{parameters.<parameterName>}`. Complex object types are supported.

```json
{
    "$schema": "../../Source/Schemas/2021-04/schema.definition.json",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "subscriptionId": {
            "type": "string",
            "defaultValue": "__SUBSCRIPTION_ID__"
        },
        "resourceGroupName": {
            "type": "string",
            "defaultValue": "__RESOURCE_GROUP_NAME__"
        },
        "location": {
            "type": "string",
            "defaultValue": "northeurope"
        },
        "hubNetwork": {
            "type": "object",
            "defaultValue": {
                "name": "vnet-hub",
            }
        }
    },
    "contexts": {
        "default": {
            "subscriptionId": "{parameters.subscriptionId}",
            "resourceGroupName": "{parameters.resourceGroupName}"
        }
    },
    "definition": {
        "network": {
            "virtualNetworks": [
                {
                    "name": "{parameters.hubNetwork.name}",
                    "location": "{parameters.location}"
                }
            ]
        }
    }
}
```

In addition, you can dissociate parameters values (at least the ones with no default values) into a separate file.

```json
{
    "$schema": "../../Source/Schemas/2021-04/schema.definition.parameters.json",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "subscriptionId": {
            "value": "__SUBSCRIPTION_ID__"
        },
        "resourceGroupName": {
            "value": "__RESOURCE_GROUP_NAME__"
        }
    }
}
```

```powershell
PS C:\AzPester> Invoke-AzPester -Definition definition.json -Parameters definition.parameters.json
```

## Contexts

This section will define the default subscription and resource group targeted for tests. By the way, `default` property is required, and json schema validation will fail if you don't provide it.

```json
"contexts": {
    "default": {
        "subscriptionId": "{parameters.subscriptionId}",
        "resourceGroupName": "{parameters.resourceGroupName}"
    }
}
```

This section has another purpose. Some resources need to switch to a different subscription context to make appropriate call to Azure. This process of context switching is unfortunately time consuming.

So, to avoid performance loss, we are loading all contexts just once before invoking tests. These contexts are passed to all Pester tests and reused as needed when a context switch is detected.

If you need to target a specific subscription when declaring a resource (different than default one), you can reference one of these contexts by using the associated `context` property.

```json
"contexts": {
    "default": {
        "subscriptionId": "{parameters.subscriptionId}",
        "resourceGroupName": "{parameters.resourceGroupName}"
    },
    "dns": {
        "subscriptionId": "{parameters.dnsSubscriptionId}",
        "resourceGroupName": "{parameters.dnsResourceGroupName}"
    }
}
```

```json
"definition": {
    "network": {
        "routeTables": [
            {
                "name": "{parameters.routeTable.name}",
                "context": "dns",
                "location": "{parameters.location}",
            }
        ]
    }
}
```

## Resources

Please find below documentation of resources currently supported.

### Identity Documentation

[Identies and Scopes definition](Docs/Resources/Identity/Identity.md)

These resources will validate if service principals, managed identies and groups are correctly provisioned. In addition, you can also check role assignments associated to these identities.

### Network Documentation

[Network Security Group definition](Docs/Resources/Network/NetworkSecurityGroup.md.md)

These resources will validate if network security groups are correctly provisioned with associated security rules.

[Route Table definition](Docs/Resources/Network/RouteTable.md)

These resources will validate if route tables are correctly provisioned with associated routes.

[Virtual Network definition](Docs/Resources/Network/VirtualNetwork.md)

These resources will validate if virtual networks are correctly provisioned with associated properties (ex. subnets, peerings).

### Compute

[Virtual Machine definition](Docs/Resources/Compute/VirtualMachine.md)

This resource will check if Virtual Machines are correct provisioned with their associated properties (hardware profile, OS profile, etc.)
