param (
    [Parameter(Mandatory = $true)]
    [PSObject] $Definition
)

BeforeDiscovery {
    Import-Module -Force $PSScriptRoot/Parsers/Definition.psm1
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    $RouteTables = Find-RouteTables -Definition $Definition
}

BeforeAll { 
    . $PSScriptRoot/../Network.ps1
}

Describe 'Route Table <name> Acceptance Tests' -ForEach $RouteTables {
    BeforeAll {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
        $routeTable = Get-RouteTable -Definition $Definition -Name $name -Context $context
    }

    Context 'Route Table <name>' {
        It 'Validate route table <name> has been provisioned' {
            $routeTable | Should -Not -BeNullOrEmpty
            $routeTable.ProvisioningState | Should -Be "Succeeded"
        }
        It 'Validate route table <propertyName> is <propertyValue>' -ForEach $properties {
            $propertyName | Should -Not -BeNullOrEmpty
            $propertyValue | Should -Not -BeNullOrEmpty
            $routeTable.$propertyName | Should -Be $propertyValue
        }
    }

    Context 'Route <name>' -Foreach $routes {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $route = $routeTable.routes | Where-Object { $_.Name -eq $name }
        }

        It 'Validate route <name> has been provisioned' {
            $route | Should -Not -BeNullOrEmpty
            $route.ProvisioningState | Should -Be "Succeeded"
        }
        It 'Validate route <propertyName> is <propertyValue>' -ForEach $properties {
            $propertyName | Should -Not -BeNullOrEmpty
            $propertyValue | Should -Not -BeNullOrEmpty
            $route.$propertyName | Should -Be $propertyValue
        }
    }
}
