# Virtual Machines

## Usage

```json
{
    "definition": {
        "compute": {
            "virtualMachines": [
                {
                    "name": "{parameters.vmName}",
                    "location": "{parameters.location}",
                    "hardwareProfile": {
                        "vmSize": "{parameters.vmSize}"
                    },
                    "storageProfile": {
                        "imageReference": {
                            "publisher": "MicrosoftWindowsServer",
                            "offer": "WindowsServer",
                            "sku": "{parameters.OSVersion}",
                            "version": "latest"
                        }
                    },
                    "networkProfile": {
                        "networkInterfaces": [
                            {
                                "name": "{parameters.nicName}"
                            }
                        ]
                    },
                    "identity": {
                        "type": "None"
                    },
                    "autoShutdown": {
                        "status": "Disabled"
                    }
                }
            ]
        }
    }
}
```

## Objects and Properties

### virtualMachines

(Required) An array of `virtualMachine` objects.

### virtualMachine object

- `name`: (Required) The name of the virtual machine.
  - Type: string
- `location`: (Optional) Resource location.
  - Type: string
- `hardwareProfile`: (Optional) Specifies the hardware settings for the virtual machine.
  - Type: hardwareProfile
- `storageProfile`: (Optional) Specifies the storage settings for the virtual machine disks.
  - Type: storageProfile
- `networkProfile`: (Optional) Specifies the network interfaces of the virtual machine.
  - Type: networkProfile
- `identity`: (Optional) Identity for the virtual machine.
  - Type: identity
- `autoShutdown`: (Optional) Specifies auto shutdown settings.
  - Type: autoShutdown

### hardwareProfile object

(Optional) Specifies the storage settings for the virtual machine disks.

- `vmSize`: (Required) Specifies the size of the virtual machine.
  - Type: string

### storageProfile object

(Optional) Specifies the storage settings for the virtual machine disks.

- `imageReference`: (Required) Specifies information about the image to use.
  - Type: imageReference

### imageReference object

(Required) Specifies information about the image to use.

Two options are possible, depending if you targets a public image or a shared gallery one.

Shared gallery:

- `gallery`: (Required) The Image Gallery name.
  - Type: string
- `name`: (Required) The Virtual Machine Image name.
  - Type: string
- `version`: (Required) The Virtual Machine Image version.
  - Type: string
- `context`: (Optional) The name of the Azure context to use to resolve the gallery.
  - Type: string

> Note: You can target a subscription different than default one by using `context` property. However, you have to reference the associated subscription identifier and resource group name in the `contexts` section. For more details about contexts, please read the [REAME.md](../../../README.md) file.

Public image:

- `publisher`: (Required) The image publisher.
  - Type: string
- `offer`: (Required) The image offer.
  - Type: string
- `sku`: (Required) The image sku.
  - Type: string
- `version`: (Required) The image version.
  - Type: string
  
### networkProfile object

(Optional) Specifies the network interfaces of the virtual machine.

- `networkInterfaces`: (Required) Specifies the list of network interfaces associated with the virtual machine.
  - Type: networkInterface[]

### networkInterface object

- `name`: (Required) The network interface name..
  - Type: string
- `context`: (Optional) The name of the Azure context to use to resolve the network interface.
  - Type: string

### autoShutdown object

(Optional) Specifies auto shutdown settings.

- `status`: (Required) Specifies if auto-shutdown is enabled or disabled.
  - Type: string
  - Values: `Enabled` or `Disabled`
- `dailyRecurrence`: (Required) The time of day the schedule will occur.
  - Type: string
- `timeZoneId`: (Required) The time zone ID (e.g. Pacific Standard time).
  - Type: string

### identity object

(Optional) Identity for the virtual machine.

- `type`: (Required) The type of identity used for the virtual machine.
  - Type: string
  - Values: `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` or `None`
- `userAssignedIdentities`: (Optional) Specifies the list of user assigned identities associated with the virtual machine.
  - Type: userAssignedIdentity[]

### userAssignedIdentity object

- `name`: (Required) The user assigned managed identity name used for the virtual machine.
  - Type: string
- `context`: (Optional) The name of the Azure context to use to resolve the user assigned managed identity.
  - Type: string