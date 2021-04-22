class IdentityTypes {
    static [string] $ServicePrincipal = 'ServicePrincipal'
    static [string] $ManagedIdentity = 'ManagedIdentity'
    static [string] $Group = 'Group'
}

function Get-IdentityTypes {
    return [IdentityTypes]::new()
}

function Find-ServicePrincipals {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition
    )

    $identities = $Definition.identity.identities | Where-Object { $_.type -eq (Get-IdentityTypes)::ServicePrincipal }

    foreach ($identity in $identities) {
        foreach ($roleAssignment in $identity.roleAssignments) {
            $scopeRef = $roleAssignment.scopeRef
            if (!$scopeRef) {
                Write-Host "Warning: Cannot evaluate scope reference $scopeRef." -ForegroundColor Yellow
            }

            $scope = $Definition.identity.scopes.$scopeRef
            $roleAssignment.scope = $scope
        }
    }

    return $identities
}

function Find-Groups {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition
    )

    $identities = $Definition.identity.identities | Where-Object { $_.type -eq (Get-IdentityTypes)::Group }

    foreach ($identity in $identities) {
        foreach ($roleAssignment in $identity.roleAssignments) {
            $scopeRef = $roleAssignment.scopeRef
            if (!$scopeRef) {
                Write-Host "Warning: Cannot evaluate scope reference $scopeRef." -ForegroundColor Yellow
            }

            $scope = $Definition.identity.scopes.$scopeRef
            $roleAssignment.scope = $scope
        }
    }

    return $identities
}

function Find-ManagedIdentities {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition
    )

    $identities = $Definition.identity.identities | Where-Object { $_.type -eq (Get-IdentityTypes)::ManagedIdentity }

    foreach ($identity in $identities) {
        foreach ($roleAssignment in $identity.roleAssignments) {
            $scopeRef = $roleAssignment.scopeRef
            if (!$scopeRef) {
                Write-Host "Warning: Cannot evaluate scope reference $scopeRef." -ForegroundColor Yellow
            }

            $scope = $Definition.identity.scopes.$scopeRef
            $roleAssignment.scope = $scope
        }
    }

    return $identities
}

Export-ModuleMember -Function Get-IdentityTypes
Export-ModuleMember -Function Find-ServicePrincipals
Export-ModuleMember -Function Find-ManagedIdentities
Export-ModuleMember -Function Find-Groups