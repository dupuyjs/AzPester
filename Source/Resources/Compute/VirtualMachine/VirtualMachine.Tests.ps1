param (
    [Parameter(Mandatory = $true)]
    [PSObject] $Definition
)

BeforeDiscovery {
    Import-Module -Force $PSScriptRoot/Parsers/Definition.psm1
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    $VirtualMachines = Find-VirtualMachines -Definition $Definition
}

BeforeAll { 
    . $PSScriptRoot/VirtualMachine.ps1
}

Describe 'Virtual Machine <name> Acceptance Tests' -Tag 'Compute' -ForEach $VirtualMachines {
    BeforeAll {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
        $vm = Get-VirtualMachine -Definition $Definition -Name $_.name
    }

    Context 'Virtual Machine <name>' {
        It 'Validate virtual machine <name> has been provisioned' {
            $vm | Should -Not -BeNullOrEmpty
        }

        It 'Validate virtual machine <name> has the expected size' -TestCases $case_vmSize {
            $vm.HardwareProfile.VmSize | Should -Be $vmSize
        }

        It 'Validate virtual machine <name> has the expected image reference' -TestCases $case_imageReference {
            if ($imageReference.gallery) {
                $image = Get-GalleryImage -Definition $Definition -GalleryName $imageReference.gallery -ImageName $imageReference.name -ImageVersion $imageReference.version -Context $imageReference.context
                $image | Should -Not -BeNullOrEmpty
                $vm.StorageProfile.ImageReference.Id | Should -Be $image.Id
            } elseif ($imageReference.publisher) {
                # TODO
            } else {
                throw 'imageReference settings are invalid'
            }
        }

        It 'Validate virtual machine <name> has the expected network profile' -TestCases $case_networkProfile {
            $vmSubnets = Get-VirtualMachineSubnets -Definition $Definition -Name $vm.name

            $vnet = $vmSubnets | Where-Object {$vnet -eq $virtualNetwork}
            $vnet | Should -Not -BeNullOrEmpty

            $subnet = $vnet | Where-Object {$subnet -eq $subnet}
            $subnet | Should -Not -BeNullOrEmpty
        }

        It 'Validate virtual machine <name> has the expected auto shutdown settings' -TestCases $case_autoShutdown {
            $scheduleProperties = Get-ScheduleProperties -Definition $Definition -TargetResourceId $vm.Id
            $shutdownDailyRecurrence = $autoShutdown.dailyRecurrence

            $scheduleProperties.taskType | Should -Be 'ComputeVmShutdownTask'
            $scheduleProperties.status | Should -Be 'Enabled'
            $scheduleProperties.dailyRecurrence | Should -Be "@{time=$shutdownDailyRecurrence}"
            $scheduleProperties.timeZoneId | Should -Be $autoShutdown.timeZone
        }

        It 'Validate virtual machine <name> has the expected User Assigned Managed Identity' -TestCases $case_userAssignedIdentity {
            $identity = Get-UserAssignedIdentity -Definition $Definition -IdentityName $userAssignedIdentity

            $identity | Should -Not -BeNullOrEmpty
            $vm.Identity.UserAssignedIdentities.Keys | Should -Contain $identity.Id
        }        
    }
}
