param (
    [Parameter(Mandatory = $true)]
    [PSObject] $Definition,
    [Parameter(Mandatory = $true)]
    [PSObject] $Contexts
)

BeforeDiscovery {
    Import-Module -Force $PSScriptRoot/Parsers/Definition.psm1
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    $KeyVaults = Find-KeyVaults -Definition $Definition
}

BeforeAll { 
    . $PSScriptRoot/keyVault.ps1
}

Describe 'Key Vault <name> Acceptance Tests' -ForEach $KeyVaults {
    BeforeAll {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
        $keyVault = Get-KeyVault -Definition $Definition -Contexts $Contexts -Name $name
    }

    Context 'Key Vault <name>'{
        It 'Validate key vault <name> has been provisioned' {
            $keyVault | Should -Not -BeNullOrEmpty
        }
        It 'Validate key vault <propertyName> is <propertyValue>' -ForEach $properties {
            $propertyName | Should -Not -BeNullOrEmpty
            $propertyValue | Should -Not -BeNullOrEmpty
            $keyVault.$propertyName | Should -Be $propertyValue
        }
    }

    Context 'Access Policies for <identity.name>' -ForEach $accessPolicies {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $objectId = Get-IdentityObjectId -Definition $Definition -Type $identity.type -Name $identity.name
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $policy = $keyVault.AccessPolicies | Where-Object {$_.ObjectId -eq $objectId}
        }

        It 'Validate access policies for <identity.name> have been provisioned'{
            $objectId | Should -Not -BeNullOrEmpty
            $policy | Should -Not -BeNullOrEmpty
        }
        It 'Validate access policies <propertyName> is <propertyValue>' -ForEach $properties {
            $propertyName | Should -Not -BeNullOrEmpty
            $propertyValue | Should -Not -BeNullOrEmpty
            ($policy.$propertyName | Sort-Object) | Should -Be ($propertyValue| Sort-Object)
        }
    }

    Context 'Key <name>' -ForEach $keys {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $key = Get-KeyVaultKey -Definition $Definition -Contexts $Contexts -VaultName $keyVault.VaultName -Name $name
        }

        It 'Validate key is Enabled' {
            $key | Should -Not -BeNullOrEmpty
            $key.Name | Should -Be $name
            $key.Enabled | Should -BeTrue
        }
    }

    Context 'Secret <name>' -ForEach $secrets {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $secret = Get-KeyVaultSecret -Definition $Definition -Contexts $Contexts -VaultName $keyVault.VaultName -Name $name
        }

        It 'Validate secret is Enabled'  {
            $secret | Should -Not -BeNullOrEmpty
            $secret.Name | Should -Be $name
            $secret.Enabled | Should -BeTrue
        }
    }

    Context 'Certificate <name>' -ForEach $certificates {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $certificate = Get-KeyVaultCertificate -Definition $Definition -Contexts $Contexts -VaultName $keyVault.VaultName -Name $name
        }

        It 'Validate certificate is Enabled'  {
            $certificate | Should -Not -BeNullOrEmpty
            $certificate.Name | Should -Be $name
            $certificate.Enabled | Should -BeTrue
        }
        It 'Validate certificate <propertyName> is <displayValue>' -ForEach $properties {
            if($propertyName -eq 'expiration') {
                $certificate.Expires | Should -BeGreaterThan (Get-Date).AddDays($propertyValue)
            }
            else {
                $propertyName | Should -Not -BeNullOrEmpty
                $propertyValue | Should -Not -BeNullOrEmpty
                $certificate.$propertyName | Should -Be $propertyValue
            }
        }
    }
}

