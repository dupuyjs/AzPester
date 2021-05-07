function Get-UserAssignedIdentity {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Name
    )

    $resourceGroupName = $Definition.contexts.default.resourceGroupName
    if ([string]::IsNullOrWhiteSpace($resourceGroupName)) {
        throw 'The default resourceGroupName input value is Null|Empty or WhiteSpace.'
    }

    Get-AzUserAssignedIdentity -ResourceGroupName $resourceGroupName -Name $Name
}

function Get-RoleAssignment {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $ObjectId,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Scope
    )

    # Check if the scope is part of a known context
    $scopeSubscriptionId = $Scope.Split('/')[2]
    ForEach ($context in $Definition.contexts.GetEnumerator()) {
        if ($context.Value.SubscriptionId -eq $scopeSubscriptionId) {
            # Get role assignments
            $allRoleAssignment = Get-AzRoleAssignment -ObjectId $ObjectId -DefaultProfile $context.Value.Context
            $roleAssignment = $allRoleAssignment | Where-Object { $_.Scope -eq $Scope }
            return $roleAssignment 
        }
    }

    Write-Host "Warning: Subscription $scopeSubscriptionId is unknown. This subscription should be referenced in contexts." -ForegroundColor Yellow
}