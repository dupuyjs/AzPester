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
        [String] $Name
    )

    $resourceGroupName = $Contexts.default.resourceGroupName
    if ([string]::IsNullOrWhiteSpace($resourceGroupName)) {
        throw 'The default resourceGroupName input value is Null|Empty or WhiteSpace.'
    }

    if($Type -eq (Get-IdentityTypes)::ServicePrincipal) {
        $identity = Get-AzADServicePrincipal -DisplayName $name
        return $identity.Id
    }
    elseif($Type -eq (Get-IdentityTypes)::ManagedIdentity) {
        $identity = Get-AzUserAssignedIdentity -ResourceGroupName $resourceGroupName -Name $Name
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

function Get-KeyVault {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Contexts,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Name,
        [Parameter(Mandatory = $false)]
        [String] $SubscriptionId,
        [Parameter(Mandatory = $false)]
        [String] $ResourceGroupName
    )

    if(!$ResourceGroupName) {
        $ResourceGroupName = $Contexts.default.resourceGroupName
        if ([string]::IsNullOrWhiteSpace($ResourceGroupName)) {
            throw 'The default resourceGroupName input value is Null|Empty or WhiteSpace.'
        }
    }

    if($SubscriptionId) {
        ForEach ($context in $Contexts.GetEnumerator()) {
            if ($context.Value.SubscriptionId -eq $SubscriptionId) {
                # Get virtual network
                $keyVault = Get-AzKeyVault -ResourceGroupName $ResourceGroupName -VaultName $Name -DefaultProfile $context.Value.Context
                return $keyVault 
            }
        }

        Write-Host "Warning: Subscription $SubscriptionId is unknown. This subscription should be referenced in contexts." -ForegroundColor Yellow
    }
    
    Get-AzKeyVault -ResourceGroupName $ResourceGroupName -VaultName $Name
}

function Get-KeyVaultSecret {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Contexts,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $VaultName,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Name,
        [Parameter(Mandatory = $false)]
        [String] $SubscriptionId
    )

    if($SubscriptionId) {
        ForEach ($context in $Contexts.GetEnumerator()) {
            if ($context.Value.SubscriptionId -eq $SubscriptionId) {
                # Get secret
                $secret = Get-AzKeyVaultSecret -VaultName $VaultName -Name $Name -DefaultProfile $context.Value.Context
                return $secret 
            }
        }

        Write-Host "Warning: Subscription $SubscriptionId is unknown. This subscription should be referenced in contexts." -ForegroundColor Yellow
    }
    
    Get-AzKeyVaultSecret -VaultName $VaultName -Name $Name
}

function Get-KeyVaultKey {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Contexts,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $VaultName,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Name,
        [Parameter(Mandatory = $false)]
        [String] $SubscriptionId
    )

    if($SubscriptionId) {
        ForEach ($context in $Contexts.GetEnumerator()) {
            if ($context.Value.SubscriptionId -eq $SubscriptionId) {
                # Get key
                $key = Get-AzKeyVaultKey -VaultName $VaultName -Name $Name -DefaultProfile $context.Value.Context
                return $key 
            }
        }

        Write-Host "Warning: Subscription $SubscriptionId is unknown. This subscription should be referenced in contexts." -ForegroundColor Yellow
    }
    
    Get-AzKeyVaultKey  -VaultName $VaultName -Name $Name
}

function Get-KeyVaultCertificate {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Contexts,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $VaultName,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Name,
        [Parameter(Mandatory = $false)]
        [String] $SubscriptionId
    )

    if($SubscriptionId) {
        ForEach ($context in $Contexts.GetEnumerator()) {
            if ($context.Value.SubscriptionId -eq $SubscriptionId) {
                # Get certificate
                $certificate = Get-AzKeyVaultCertificate -VaultName $VaultName -Name $Name -DefaultProfile $context.Value.Context
                return $certificate 
            }
        }

        Write-Host "Warning: Subscription $SubscriptionId is unknown. This subscription should be referenced in contexts." -ForegroundColor Yellow
    }
    
    Get-AzKeyVaultCertificate  -VaultName $VaultName -Name $Name
}
