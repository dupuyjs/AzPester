param (
    [Parameter(Mandatory = $true)]
    [PSObject] $Definition,
    [Parameter(Mandatory = $true)]
    [PSObject] $Contexts
)

BeforeDiscovery {
    Import-Module -Force $PSScriptRoot/Parsers/Definition.psm1
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    $VirtualMachines = $Definition.compute.virtualMachines
}

BeforeAll { 
    . $PSScriptRoot/VirtualMachine.ps1
}

Describe 'Virtual Machine <name> Acceptance Tests' -ForEach $VirtualMachines {
    BeforeAll {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
        $vm = Get-VirtualMachine -Definition $Definition -Contexts $Contexts -Name $_.name
    }

    Context 'Virtual Machine <name>' {
        It 'Validate virtual machine <name> has been provisioned' {
            $vm | Should -Not -BeNullOrEmpty
        }

        if ($_.vmSize) {
            It 'Validate virtual machine <name> has the expected size' {
                $vm.HardwareProfile.VmSize | Should -Be $_.vmSize
            }
        }

        if ($_.imageReference) {
            It 'Validate virtual machine <name> has the expected image reference' {
                if ($_.imageReference.gallery) {
                    $image = Get-GalleryImage -Definition $Definition -Contexts $Contexts -GalleryName $_.imageReference.gallery -ImageName $_.imageReference.name -ImageVersion $_.imageReference.version -Context $_.imageReference.context
                    $image | Should -Not -BeNullOrEmpty
                    $vm.StorageProfile.ImageReference.Id | Should -Be $image.Id
                } elseif ($_.imageReference.publisher) {
                    # TODO
                } else {
                    throw 'imageReference settings are invalid'
                }
            }
        }

        if ($_.networkProfile) {
            It 'Validate virtual machine <name> has the expected network profile' {
                $vmSubnets = Get-VirtualMachineSubnets -Definition $Definition -Contexts $Contexts -Name $_.name

                $expectedVnet = $_.networkProfile.virtualNetwork
                $expectedSubnet = $_.networkProfile.subnet

                $vnet = $vmSubnets | Where-Object {$_.vnet -eq $expectedVnet}
                $vnet | Should -Not -BeNullOrEmpty

                $subnet = $vnet | Where-Object {$_.subnet -eq $expectedSubnet}
                $subnet | Should -Not -BeNullOrEmpty
            }
        }

        if ($_.autoShutdownDailyRecurrence -and $_.autoShutdownTimeZone) {
            It 'Validate virtual machine <name> has the expected auto shutdown settings' {
                $scheduleProperties = Get-ScheduleProperties -Definition $Definition -Contexts $Contexts -TargetResourceId $vm.Id
                $shutdownDailyRecurrence = $_.autoShutdownDailyRecurrence

                $scheduleProperties.taskType | Should -Be 'ComputeVmShutdownTask'
                $scheduleProperties.status | Should -Be 'Enabled'
                $scheduleProperties.dailyRecurrence | Should -Be "@{time=$shutdownDailyRecurrence}"
                $scheduleProperties.timeZoneId | Should -Be $_.autoShutdownTimeZone
            }
        }

        if ($_.userAssignedIdentity) {
            It 'Validate virtual machine <name> has the expected User Assigned Managed Identity' {
                $identity = Get-UserAssignedIdentity -Definition $Definition -Contexts $Contexts -IdentityName $_.userAssignedIdentity

                $identity | Should -Not -BeNullOrEmpty
                $vm.Identity.UserAssignedIdentities.Keys | Should -Contain $identity.Id
            }
        }
    }
}
