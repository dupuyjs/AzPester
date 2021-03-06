# Identity Documentation

## Usage

```json
"definition": {
    "identity": {
        "identities": [
            {
                "name": "UAMI-AZPESTER-CONTRIBUTOR",
                "type": "ManagedIdentity",
                "roleAssignments": [
                    {
                        "scopeRef": "Subscription",
                        "role": "Contributor"
                    }
                ]
            }
        ],
        "scopes": {
            "Subscription": {
                "displayName": "Subscription",
                "scope": "/subscriptions/{parameters.subscriptionId}"
            }
        }
    }
}

```

## Objects and Properties

### identities

(Required) An array of `identity` objects.

### scopes

(Optional) Scope properties definition. Each property must implement a `scope` object.

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
- `roleAssignments` (Optional) An array of `roleAssignment` objects.
  - Type: roleAssignment[]

Note: If there is no role assignments, we are just evaluating if the identity exists.

### roleAssignment object

- `scopeRef`: (Required) The scope reference of the role assignment. Should target a scope you defined in the scopes section.
  - Type: string
- `role`: (Required) The name of the RBAC role that needs to be assigned to the identity.
  - Type: string
  - Example: 'Reader, Contributor'. As you can also use Custom Roles, no validation on these values are done by json schema. If the value does not exit, it will fail during test execution.

### scope object

- `name`: (Required) The scope name. Used only for display in test results.
  - Type: string
- `scope`: (Required) The scope definition of the role assignment. In the format of relative URI.
  - Type: string
  - Example: "/subscriptions/{parameters.subscriptionId}".

Note: In scope property, you can target a subsription different than default one. We will automatically detect the subscription and switch to the appropriate context.

However, th subscription identifier should be listed in `contexts` section. If not, the following warning will be displayed:

```powershell
"Warning: Subscription $scopeSubscriptionId is unknown. This subscription should be referenced in contexts."
```

For more details about contexts, please read the [REAME.md](../../../README.md) file.
