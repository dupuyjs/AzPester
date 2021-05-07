. $PSScriptRoot/../Common/Common.ps1

class IdentityTypes {
    static [string] $ServicePrincipal = 'ServicePrincipal'
    static [string] $ManagedIdentity = 'ManagedIdentity'
    static [string] $Group = 'Group'
}

function Get-IdentityTypes {
    return [IdentityTypes]::new()
}

function Get-IdentityObjectId {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Type,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Name,
        [Parameter(Mandatory = $false)]
        [String] $Context
    )

    if($Type -eq (Get-IdentityTypes)::ServicePrincipal) {
        $identity = Get-AzADServicePrincipal -DisplayName $name
        return $identity.Id
    }
    elseif($Type -eq (Get-IdentityTypes)::ManagedIdentity) {
        $identity = Get-UserAssignedIdentity -Definition $Definition -Name $Name -Context $Context
        return $identity.PrincipalId
    }
    elseif($Type -eq (Get-IdentityTypes)::Group) {
        $identity = Get-AzADGroup -DisplayName $name
        return $identity.Id
    }
    else {
        Write-Host "Issue: Type $Type used by Get-IdentityObjectId is not supported." -ForegroundColor Red
    }
}

function Get-UserAssignedIdentity {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Name,
        [Parameter(Mandatory = $false)]
        [String] $Context
    )

    if ($Context) {
        $curContext = Get-Context -Definition $Definition -Context $Context

        $uami = Get-AzUserAssignedIdentity `
            -ResourceGroupName $curContext.ResourceGroupName `
            -Name $Name `
            -DefaultProfile $curContext.Context
        return $uami
    }
    else {
        $resourceGroupName = $Definition.contexts.default.ResourceGroupName
        if ([string]::IsNullOrWhiteSpace($ResourceGroupName)) {
            throw 'The default context resource group name is Null|Empty or WhiteSpace.'
        }

        Get-AzUserAssignedIdentity -ResourceGroupName $resourceGroupName -Name $Name
    }
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