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
                    "vmSize": "{parameters.vmSize}",
                    "imageReference": {
                        "gallery": "{parameters.imageGalleryName}",
                        "name": "{parameters.imageName}",
                        "version": "{parameters.imageVersion}",
                        "context": "gallery"
                    },
                    "networkProfile": {
                        "virtualNetwork": "{parameters.virtualNetwork}",
                        "subnet": "{parameters.subnet}"
                    },
                    "autoShutdown": {
                        "dailyRecurrence": "{parameters.autoShutdownTime}",
                        "timeZone": "{parameters.autoShutdownTimeZone}"    
                    },
                    "userAssignedIdentity": "{parameters.userAssignedIdentity}"
                }
            ]
        }
    }
}
```

## Objects and Properties

### vmSize

(Optional) Specifies the size of the virtual machine.

### imageReference

(Optional) The image reference of the virtual machine.

An object containing the following properties:

- `gallery`: (Required) The Image Gallery name.
- `name`: (Required) The Virtual Machine Image name.
- `version`: (Required) The Virtual Machine Image version.

### networkProfile

(Optional) The Virtual Machine network profile.

- `virtualNetwork`: (Required) The Virtual Network name.
- `subnet`: (Required) The Subnet name.

### autoShutdown

(Optional) The Virtual Machine auto shutdown settings.

- `dailyRecurrence`: (Required) The time of day the schedule will occur.
- `timeZone`: (Required) The time zone ID (e.g. Pacific Standard time).

### userAssignedIdentity

(Optional) The User Assigned Managed Identity name.
