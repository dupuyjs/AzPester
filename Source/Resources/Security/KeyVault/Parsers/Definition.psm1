function Find-KeyVaults {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition
    )

    $keyVaults = $Definition.security.keyVaults

    foreach ($keyVault in $keyVaults) {
        $properties = @()

        if ($null -ne $keyVault.location) {
            $properties += Add-Property -PropertyName 'location' -PropertyValue $keyVault.location
        }
        if ($null -ne $keyVault.sku) {
            $properties += Add-Property -PropertyName 'sku' -PropertyValue $keyVault.sku
        }
        if ($null -ne $keyVault.enabledForDeployment) {
            $properties += Add-Property -PropertyName 'enabledForDeployment' -PropertyValue $keyVault.enabledForDeployment
        }
        if ($null -ne $keyVault.enabledForTemplateDeployment) {
            $properties += Add-Property -PropertyName 'enabledForTemplateDeployment' -PropertyValue $keyVault.enabledForTemplateDeployment
        }
        if ($null -ne $keyVault.enabledForDiskEncryption) {
            $properties += Add-Property -PropertyName 'enabledForDiskEncryption' -PropertyValue $keyVault.enabledForDiskEncryption
        }
        if ($null -ne $keyVault.enablePurgeProtection) {
            $properties += Add-Property -PropertyName 'enablePurgeProtection' -PropertyValue $keyVault.enablePurgeProtection
        }
        if ($null -ne $keyVault.enableRbacAuthorization) {
            $properties += Add-Property -PropertyName 'enableRbacAuthorization' -PropertyValue $keyVault.enableRbacAuthorization
        }
        if ($null -ne $keyVault.enableSoftDelete) {
            $properties += Add-Property -PropertyName 'enableSoftDelete' -PropertyValue $keyVault.enableSoftDelete
        }
        if ($null -ne $keyVault.softDeleteRetentionInDays) {
            $properties += Add-Property -PropertyName 'softDeleteRetentionInDays' -PropertyValue $keyVault.softDeleteRetentionInDays
        }

        if ($keyVault.accessPolicies) {
            foreach ($policy in $keyVault.accessPolicies) {
                $policyProperties = @()

                if ($null -ne ${policy}?.permissions['keys']) {
                    $policyProperties += Add-Property -PropertyName 'permissionsToKeys' -PropertyValue $policy.permissions['keys']
                }
                if ($null -ne ${policy}?.permissions['secrets']) {
                    $policyProperties += Add-Property -PropertyName 'permissionsToSecrets' -PropertyValue $policy.permissions['secrets']
                }
                if ($null -ne ${policy}?.permissions['certificates']) {
                    $policyProperties += Add-Property -PropertyName 'permissionsToCertificates' -PropertyValue $policy.permissions['certificates']
                }
                if ($null -ne ${policy}?.permissions['storage']) {
                    $policyProperties += Add-Property -PropertyName 'permissionsToStorage' -PropertyValue $policy.permissions['storage']
                }

                $policy.properties = $policyProperties
            }
        }

        if ($keyVault.certificates) {
            foreach ($certificate in $keyVault.certificates) {
                $certificateProperties = @()

                if ($null -ne $certificate.thumbprint) {
                    $certificateProperties += Add-Property -PropertyName 'thumbprint' -PropertyValue $certificate.thumbprint
                }
                if ($null -ne $certificate.expirationThresholdInDays) {
                    $certificateProperties += Add-Property -PropertyName 'expiration' -PropertyValue $certificate.expirationThresholdInDays -DisplayValue "greater than $($certificate.expirationThresholdInDays) days"
                }

                $certificate.properties = $certificateProperties
            }
        }

        $keyVault.properties = $properties
    }

    return $keyVaults
}

function Add-Property {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [string] $PropertyName,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $PropertyValue,
        [Parameter(Mandatory = $false)]
        [PSObject] $DisplayValue
    )

    if (!$DisplayValue) {
        $DisplayValue = $PropertyValue
    }

    return @{propertyName = $PropertyName; propertyValue = $PropertyValue; displayValue = $DisplayValue }
}

Export-ModuleMember -Function Find-KeyVaults