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

Describe 'Virtual Network <name> Acceptance Tests' -ForEach $VirtualNetworks {
    BeforeAll {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
        $virtualNetwork = Get-VirtualNetwork -Definition $Definition -Contexts $Contexts -Name $name
    }

    Context 'Virtual Network <name>'{
        It 'Validate virtual network <name> has been provisioned' {
            $virtualNetwork | Should -Not -BeNullOrEmpty
            $virtualNetwork.ProvisioningState | Should -Be "Succeeded"
        }
        It 'Validate virtual network <propertyName> is <propertyValue>' -ForEach $properties {
            $propertyName | Should -Not -BeNullOrEmpty
            $propertyValue | Should -Not -BeNullOrEmpty
            $virtualNetwork.$propertyName | Should -Be $propertyValue
        }
        It 'Validate virtual network address space contains <addressPrefix>' -ForEach $addressSpace {
            $virtualNetwork.AddressSpace.AddressPrefixes | Should -Contain $addressPrefix
        }
        It 'Validate virtual network subnets contains <name> subnet' -ForEach $subnets {
            $virtualNetwork.Subnets.Name | Should -Contain $name
        }
    }

    Context 'Subnet <name>' -ForEach $subnets {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $subnet = $virtualNetwork.Subnets | Where-Object {$_.Name -eq $name}
        }

        It 'Validate subnet <propertyName> is <displayValue>' -ForEach $properties {
            if($propertyName -eq 'networkSecurityGroup') {
                $nsg = Get-NetworkSecurityGroup -Definition $Definition `
                                                -Contexts $Contexts `
                                                -Name $propertyValue.name `
                                                -SubscriptionId $propertyValue.subscriptionId `
                                                -ResourceGroupName $propertyValue.resourceGroupName

                $nsg | Should -Not -BeNullOrEmpty
                $Subnet.NetworkSecurityGroup.Id | Should -Be $nsg.Id
            }
            elseif($propertyName -eq 'routeTable') {
                $routeTable = Get-RouteTable -Definition $Definition `
                                             -Contexts $Contexts `
                                             -Name $propertyValue.name `
                                             -SubscriptionId $propertyValue.subscriptionId `
                                             -ResourceGroupName $propertyValue.resourceGroupName
                                             
                $routeTable | Should -Not -BeNullOrEmpty
                $Subnet.RouteTable.Id | Should -Be $routeTable.Id
            }
            else {
                $propertyName | Should -Not -BeNullOrEmpty
                $propertyValue | Should -Not -BeNullOrEmpty
                $subnet.$propertyName | Should -Be $propertyValue
            }
        }
    }

    Context 'Virtual Network Peering with <remoteVirtualNetwork.name>' -ForEach $virtualNetworkPeerings {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $peering = $virtualNetwork.VirtualNetworkPeerings | Where-Object { $_.Name -eq $name }
        }

        It 'Validate virtual network peering with <remoteVirtualNetwork.name> is connected' {
            $remoteVirtualNetwork = Get-VirtualNetwork -Definition $Definition `
                                                       -Contexts $Contexts `
                                                       -Name $remoteVirtualNetwork.name `
                                                       -SubscriptionId $remoteVirtualNetwork.subscriptionId `
                                                       -ResourceGroupName $remoteVirtualNetwork.resourceGroupName 
            
            $peering | Should -Not -BeNullOrEmpty
            $peering.RemoteVirtualNetwork.Id | Should -Be $remoteVirtualNetwork.Id
            $peering.PeeringState | Should -Be "Connected"
            $peering.ProvisioningState | Should -Be "Succeeded"
        }
        It 'Validate virtual network peering <propertyName> is <propertyValue>' -ForEach $properties {
            $propertyName | Should -Not -BeNullOrEmpty
            $propertyValue | Should -Not -BeNullOrEmpty
            $peering.$propertyName | Should -Be $propertyValue
        }
    }
}