param (
    [Parameter(Mandatory = $true)]
    [PSObject] $Definition
)

BeforeDiscovery {
    Import-Module -Force $PSScriptRoot/Parsers/Definition.psm1
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    $PrivateDnsZones = Find-PrivateDnsZones -Definition $Definition
}

BeforeAll { 
    . $PSScriptRoot/../Network.ps1
}

Describe 'Private DNS Zone <name> Acceptance Tests' -Tag 'Network' -ForEach $PrivateDnsZones {
    BeforeAll {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
        $dnsZone = Get-PrivateDnsZone -Definition $Definition -Name $name -Context $context
    }

    Context 'Private DNS Zone <name>' {
        It 'Validate private DNS zone <name> has been provisioned' {
            $dnsZone | Should -Not -BeNullOrEmpty
        }
        It 'Validate private DNS zone <propertyName> is <propertyValue>' -ForEach $properties {
            $propertyName | Should -Not -BeNullOrEmpty
            $propertyValue | Should -Not -BeNullOrEmpty
            $dnsZone.$propertyName | Should -Be $propertyValue
        }
    }

    Context 'Virtual Network Link <name>' -Foreach $virtualNetworkLinks {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $link = Get-PrivateDnsVirtualNetworkLink -Definition $Definition -PrivateDnsZoneName $dnsZone.Name -Name $name -Context $context
        }

        It 'Validate link <name> has been provisioned' {
            $link | Should -Not -BeNullOrEmpty
            $link.ProvisioningState | Should -Be "Succeeded"
        }
        It 'Validate link <propertyName> is <displayValue>' -ForEach $properties {
            if ($propertyName -eq "virtualNetwork") {
                $virtualNetwork = Get-VirtualNetwork -Definition $Definition `
                    -Name $propertyValue.name `
                    -Context $propertyValue.context
                
                $virtualNetwork | Should -Not -BeNullOrEmpty
                $link.VirtualNetworkId | Should -Be $virtualNetwork.Id
                $link.VirtualNetworkLinkState | Should -Be "Completed"
            }
            else {
                $propertyName | Should -Not -BeNullOrEmpty
                $propertyValue | Should -Not -BeNullOrEmpty
                $link.$propertyName | Should -Be $propertyValue
            }
        }
    }
}
