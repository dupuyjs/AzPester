class IdentityTypes {
    static [string] $ServicePrincipal = 'ServicePrincipal'
    static [string] $ManagedIdentity = 'ManagedIdentity'
    static [string] $Group = 'Group'
}

function Get-IdentityTypes {
    return [IdentityTypes]::new()
}

function Get-Context {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Context
    )

    $defContexts = $Definition.contexts
    $curContext = ${defContexts}?[$Context]

    if ($null -ne $curContext) {
        return $curContext
    }
    else {
        throw "Context $Context is unknown. This context should be referenced in contexts section."
    }
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

function Get-KeyVault {
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

        $keyVault = Get-AzKeyVault `
            -ResourceGroupName $curContext.ResourceGroupName `
            -VaultName $Name `
            -DefaultProfile $curContext.Context
        return $keyVault
    }
    else {
        $resourceGroupName = $Definition.contexts.default.ResourceGroupName
        if ([string]::IsNullOrWhiteSpace($ResourceGroupName)) {
            throw 'The default context resource group name is Null|Empty or WhiteSpace.'
        }

        Get-AzKeyVault -ResourceGroupName $resourceGroupName -VaultName $Name
    }
}

function Get-KeyVaultSecret {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $VaultName,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Name,
        [Parameter(Mandatory = $false)]
        [String] $Context
    )

    if ($Context) {
        $curContext = Get-Context -Definition $Definition -Context $Context

        $secret = Get-AzKeyVaultSecret `
            -VaultName $VaultName `
            -Name $Name `
            -DefaultProfile $curContext.Context
        return $secret
    }
    else {
        $resourceGroupName = $Definition.contexts.default.ResourceGroupName
        if ([string]::IsNullOrWhiteSpace($ResourceGroupName)) {
            throw 'The default context resource group name is Null|Empty or WhiteSpace.'
        }

        Get-AzKeyVaultSecret -VaultName $VaultName -Name $Name
    }
}

function Get-KeyVaultKey {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $VaultName,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Name,
        [Parameter(Mandatory = $false)]
        [String] $Context
    )

    if ($Context) {
        $curContext = Get-Context -Definition $Definition -Context $Context

        $key = Get-AzKeyVaultKey `
            -VaultName $VaultName `
            -Name $Name `
            -DefaultProfile $curContext.Context
        return $key
    }
    else {
        $resourceGroupName = $Definition.contexts.default.ResourceGroupName
        if ([string]::IsNullOrWhiteSpace($ResourceGroupName)) {
            throw 'The default context resource group name is Null|Empty or WhiteSpace.'
        }

        Get-AzKeyVaultKey -VaultName $VaultName -Name $Name
    }
}

function Get-KeyVaultCertificate {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $VaultName,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Name,
        [Parameter(Mandatory = $false)]
        [String] $Context
    )

    if ($Context) {
        $curContext = Get-Context -Definition $Definition -Context $Context

        $certificate = Get-AzKeyVaultCertificate `
            -VaultName $VaultName `
            -Name $Name `
            -DefaultProfile $curContext.Context
        return $certificate
    }
    else {
        $resourceGroupName = $Definition.contexts.default.ResourceGroupName
        if ([string]::IsNullOrWhiteSpace($ResourceGroupName)) {
            throw 'The default context resource group name is Null|Empty or WhiteSpace.'
        }

        Get-AzKeyVaultCertificate -VaultName $VaultName -Name $Name
    }
}
