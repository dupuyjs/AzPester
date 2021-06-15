# Integration Documentation

## Usage

```json
"definition": {
  "integration": {
      "testDeploymentInfo": {
          "location": "{parameters.location}",
          "resourceGroupName": "{parameters.testResourceGroupName}",
          "cleanupTestDeployment": true 
      },
      "runners": {
          "vm1": {
              "vnet": "{parameters.vnet}",
              "subnet": "{parameters.subnet1}",
              "sku": "{parameters.testVmSku}",
              "sshPublicKey": "{parameters.sshPublicKey}"
          },
          "vm2": {
              "vnet": "{parameters.vnet}",
              "subnet": "{parameters.subnet2}",
              "sku": "{parameters.testVmSku}",
              "sshPublicKey": "{parameters.sshPublicKey}"
          }
      },
      "resourceAccessChecks": [
          {
              "targetHost": "bing.com",
              "targetPort": 443,
              "runFrom": ["vm1", "vm2"]
          },
          {
              "targetHost": "google.com",
              "targetPort": 443,
              "runFrom": ["vm1", "vm2"]
          }
      ]
  }
}
```

## Objects and Properties

### testDeploymentInfo

(Required) Properties for the deployment of the test infrastructure (runners):

- `location`: (Required) The Azure region to use for the deployment of the runners.
- `resourceGroupName`: (Required) The name of the resource group to use for the deployment of the runners. If the resource group does not exist, it will be created.
- `cleanup`: (Optional) A flag that indicates that the resource group used for the runners must be cleaned up at the end of the test. Default value is `false`.

> Caution: if you set `true` to `cleanupTestDeployment` the whole resource group `resourceGroupName` will be removed at the end of the test. It is recommended to use a dedicated resource group for the runners and not mix them with any existing infrastructure, to avoid any accidental removal.

### runners

(Required) An array of [runner](#runner-object) to execute the integration tests.

### runner object

This represent a virtual machine that will be created for the integration test. It has the following properties:

- `context`: (Optional) The name of the Azure context to use to resolve the subnet. If not specified, it will use `default`. See [Contexts documentation](../../../README.md#Contexts)
- `sku`: (Required) The SKU to use for the runner. The SKU must be supported by [Ephemeral OS](https://docs.microsoft.com/azure/virtual-machines/ephemeral-os-disks).
- `sshPublicKey`: (Required) The SSH public key to use for the runner.
- `subnet`: (Required) The name of the source subnet.
- `vnet`: (Required) The name of the source virtual network.

### resourceAccessChecks

(Optional) An array of [resourceAccessCheck](#resourceAccessCheck-object) that represent the different resource access checks to perform during the test.

### resourceAccessCheck object

- `targetHost`: (Required) The host of the target resource to check access.
- `targetPort`: (Required) The port of the target resource to check access.
- `runFrom`: (Required) An array of string where each item is a reference to the name of a runner declared in the runners collection.
