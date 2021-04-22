param (
    [Parameter(Mandatory = $true)]
    [PSObject] $Definition,
    [Parameter(Mandatory = $true)]
    [PSObject] $Contexts
)

BeforeDiscovery {
    Import-Module -Force $PSScriptRoot/Parsers/Definition.psm1
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    $VirtualNetworks = Find-VirtualNetworks -Definition $Definition
}

BeforeAll { 
    . $PSScriptRoot/VirtualNetwork.ps1
}

Describe 'Virtual Network Acceptance Tests' {
    Context 'Virtual Network <name>' -ForEach $VirtualNetworks {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $virtualNetwork = Get-VirtualNetwork -Definition $Definition -Contexts $Contexts -Name $name
        }
        It 'Validate virtual network <name> has been provisioned' {
            $virtualNetwork | Should -Not -BeNullOrEmpty
            $VirtualNetwork.ProvisioningState | Should -Be "Succeeded"   
        }
        It 'Validate virtual network location is <location>' -Skip:(!$location) {
            $VirtualNetwork.Location | Should -Be $location  
        }
        It 'Validate virtual network contains <addressPrefix> address prefix' -ForEach $addressSpace {
            $virtualNetwork.AddressSpace.AddressPrefixes | Should -Contain $addressPrefix
        }
        It 'Validate virtual network contains <name> subnet' -ForEach $subnets {
            $virtualNetwork.Subnets.Name | Should -Contain $name
        }
        It 'Validate virtual network peering state with <remoteVirtualNetwork.name> is connected' -ForEach $virtualNetworkPeerings {
            $peering = $virtualNetwork.VirtualNetworkPeerings | Where-Object { $_.Name -eq $name }
            $remoteVirtualNetwork = Get-VirtualNetwork -Definition $Definition -Contexts $Contexts -Name $remoteVirtualNetwork.name
            
            $peering | Should -Not -BeNullOrEmpty
            $peering.RemoteVirtualNetwork.Id | Should -Be $remoteVirtualNetwork.Id
            $peering.PeeringState | Should -Be "Connected"
            $peering.ProvisioningState | Should -Be "Succeeded"
        }
    }
}