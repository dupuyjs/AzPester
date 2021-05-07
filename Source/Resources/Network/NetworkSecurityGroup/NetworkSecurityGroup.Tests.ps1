param (
    [Parameter(Mandatory = $true)]
    [PSObject] $Definition
)

BeforeDiscovery {
    Import-Module -Force $PSScriptRoot/Parsers/Definition.psm1
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    $NetworkSecurityGroups = Find-NetworkSecurityGroups -Definition $Definition
}

BeforeAll { 
    . $PSScriptRoot/../Network.ps1
}

Describe 'Network Security Group <name> Acceptance Tests' -ForEach $NetworkSecurityGroups {
    BeforeAll {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
        $networkSecurityGroup = Get-NetworkSecurityGroup -Definition $Definition -Name $name -Context $context
    }

    Context 'Network Security Group <name>' {
        It 'Validate network security group <name> has been provisioned' {
            $networkSecurityGroup | Should -Not -BeNullOrEmpty
            $networkSecurityGroup.ProvisioningState | Should -Be "Succeeded"
        }

        It 'Validate network security group <propertyName> is <propertyValue>' -ForEach $properties {
            $propertyName | Should -Not -BeNullOrEmpty
            $propertyValue | Should -Not -BeNullOrEmpty
            $networkSecurityGroup.$propertyName | Should -Be $propertyValue
        }
    }

    Context 'Security Rule <name>' -ForEach $securityRules {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $securityRule = $networkSecurityGroup.SecurityRules | Where-Object { $_.Name -eq $name }
        }

        It 'Validate security rule <name> has been provisioned' {
            $securityRule | Should -Not -BeNullOrEmpty
            $securityRule.ProvisioningState | Should -Be "Succeeded"
        }

        It 'Validate security rule <propertyName> is <propertyValue>' -ForEach $properties {
            $propertyName | Should -Not -BeNullOrEmpty
            $propertyValue | Should -Not -BeNullOrEmpty
            $securityRule.$propertyName | Should -Be $propertyValue
        }
    }

    Context 'Default Security Rule <name>' -ForEach $defaultSecurityRules {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $securityRule = $networkSecurityGroup.DefaultSecurityRules | Where-Object { $_.Name -eq $name }
        }

        It 'Validate security rule <name> has been provisioned' {
            $securityRule | Should -Not -BeNullOrEmpty
            $securityRule.ProvisioningState | Should -Be "Succeeded"
        }

        It 'Validate security rule <propertyName> is <propertyValue>' -ForEach $properties {
            $propertyName | Should -Not -BeNullOrEmpty
            $propertyValue | Should -Not -BeNullOrEmpty
            $securityRule.$propertyName | Should -Be $propertyValue
        }
    }
}