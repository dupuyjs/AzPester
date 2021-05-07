. $PSScriptRoot/../Common/Common.ps1
. $PSScriptRoot/../Identity/Identity.ps1

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
