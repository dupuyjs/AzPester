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
- `type`: (Required) The identity type.
  - Valid Values: `ServicePrincipal`, `ManagedIdentity` and `Group`.
- `roleAssignments` (Optional) An array of `roleAssignment` objects.

Note: If there is no role assignments, we are just evaluating if the identity exists.

### roleAssignment object

- `scopeRef`: (Required) The scope reference of the role assignment. Should target a scope you defined in the scopes section.
- `role`: (Required) The name of the RBAC role that needs to be assigned to the identity.
  - Example: 'Reader, Contributor'. As you can also use Custom Roles, no validation on these values are done by json schema. If the value does not exit, it will fail during test execution.

### scope object

- `name`: (Required) The scope name. Used only for display in test results.
- `scope`: (Required) The scope definition of the role assignment. In the format of relative URI.
  - Example: "/subscriptions/{parameters.subscriptionId}".

Note: In scope property, you can target a subsription different than default one. We will automatically detect the subscription and switch to the appropriate context.

Anyway, you have to reference this subscription identifier in the `contexts` section. If not, the following warning will be displayed:

```powershell
"Warning: Subscription $scopeSubscriptionId is unknown. This subscription should be referenced in contexts."
```

For more details about contexts, please read the [REAME.md](../../../README.md) file.
