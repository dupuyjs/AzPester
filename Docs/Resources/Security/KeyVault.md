# Key Vault Documentation

## Usage

```json
"definition": {
    "security": {
        "keyVaults": [
            {
                "name": "{parameters.keyVaultName}",
                "location": "{parameters.location}",
                "sku": "standard",
                "enabledForDeployment": true,
                "enabledForTemplateDeployment": true,
                "enabledForDiskEncryption": true,
                "enableSoftDelete": true,
                "accessPolicies": [
                    {
                        "identity": {
                            "name": "{parameters.principalName}",
                            "type": "ServicePrincipal"
                        },
                        "permissions": {
                            "secrets": [
                                "get",
                                "list",
                                "set"
                            ],
                            "certificates": [
                                "create",
                                "get"
                            ]
                        }
                    }
                ],
                "keys": [
                    {
                        "name": "{parameters.keyName}"
                    }
                ],
                "secrets": [
                    {
                        "name": "{parameters.secretName}"
                    }
                ],
                "certificates": [
                    {
                        "name": "{parameters.certificate.name}",
                        "thumbprint": "{parameters.certificate.thumbprint}",
                        "expirationThresholdInDays": 30
                    }
                ]
            }
        ]
    }
}
```

## Objects and Properties

### keyVaults

(Required) An array of `keyVault` objects.

### keyVault object

- `name`: (Required) The name of the key vault.
  - Type: string
- `context`: (Optional) The context name used for this resource. default context used if not specified.
  - Type: string

Note: You can target a subscription different than default one by using `context` property. However, you have to reference the associated subscription identifier and resource group name in the `contexts` section.

For more details about contexts, please read the [REAME.md](../../../README.md) file.

- `location`: (Optional) The location where the key vault has been created.
  - Type: string
- `enabledForDeployment`: (Optional) Property to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault.
  - Type: boolean
- `enabledForDiskEncryption`: (Optional) Property to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys.
  - Type: boolean
- `enabledForTemplateDeployment`: (Optional) Property to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault.
  - Type: boolean
- `enablePurgeProtection`: (Optional) Property specifying whether protection against purge is enabled for this vault.
  - Type: boolean
- `enableRbacAuthorization`: (Optional) Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be  ignored (warning: this is a preview feature).
  - Type: boolean
- `enableSoftDelete`: (Optional) Property to specify whether the 'soft delete' functionality is enabled for this key vault.
  - Type: boolean
- `sku`: (Optional) (Optional) SKU to specify whether the key vault is a standard vault or a premium vault.
  - Type: string
  - Valid Values: `standard` or `premium`.
- `softDeleteRetentionInDays`: (Optional) softDelete data retention days.
  - Type: integer
- `accessPolicies`: (Optional) List of identities that have access to the key vault. Contains an array of `accessPolicy` objects.
  - Type: accessPolicy[]
- `keys`: (Optional) List of keys stored in the key vault. Contains an array of `key` objects.
  - Type: key[]
- `secrets`: (Optional) List of secrets stored in the key vault. Contains an array of `secret` objects.
  - Type: secret[]
- `certificates`: (Optional) List of certificates stored in the key vault. Contains an array of `certificate` objects.
  - Type: certificate[]

### accessPolicy object

- `identity`: (Required) Identity definition that has access to the key vault. Contains an `identity` object.
- Type: identity
- `permissions`: (Required) List of permissions. Contains an array of `permission` objects.
- Type: permission[]

### identity object

- `name`: (Required) The identity name.
  - Type: string
- `context`: (Optional) The context name used for this resource. default context used if not specified. Used only if type is `ManagedIdentity`.
  - Type: string

Note: You can target a subscription different than default one by using `context` property. However, you have to reference the associated subscription identifier and resource group name in the `contexts` section.

For more details about contexts, please read the [REAME.md](../../../README.md) file.

- `type`: (Required) The identity type.
  - Type: string
  - Valid Values: `ServicePrincipal`, `ManagedIdentity` and `Group`.

### permission object

- `keys`: (Optional) Permissions to keys. Array of strings.
  - Type: string[]
  - Valid Values: `all`, `encrypt`, `decrypt`, `wrapKey`, `unwrapKey`, `sign`, `verify`, `get`, `list`, `create`, `update`, `import`, `delete`, `backup`, `restore`, `recover`, `purge`
- `secrets`: (Optional) Permissions to secrets. Array of strings.
  - Type: string[]
  - Valid Values: `all`, `get`, `list`, `set`, `delete`, `backup`, `restore`, `recover`, `purge`
- `certificates`: (Optional) Permissions to certificates. Array of strings.
  - Type: string[]
  - Valid Values: `all`, `get`, `list`, `create`, `update`, `import`, `delete`, `managecontacts`, `getissuers`, `listissuers`, `setissuers`, `deleteissuers`, `manageissuers`, `backup`, `restore`, `recover`, `purge`
- `storage`: (Optional) Permissions to storage. Array of strings.
  - Type: string[]
  - Valid Values: `all`, `get`, `list`, `delete`, `set`,`update`, `regeneratekey`, `recover`, `purge`, `backup`,`restore`, `setsas`, `listsas`, `getsas`, `deletesas`

### key object

- `name`: (Required) The name of the key.
  - Type: string

### secret object

- `name`: (Required) The name of the secret.
  - Type: string

### certificate object

- `name`: (Required) The name of the certificate.
  - Type: string
- `thumbprint`: (Optional) The thumbprint of the certificate.
  - Type: string
- `expirationThresholdInDays`: (Optional) The threshold in days before certificate expiration date.
  - Type: integer
