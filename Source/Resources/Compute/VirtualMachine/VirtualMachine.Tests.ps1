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
    . $PSScriptRoot/../Compute.ps1
}

Describe 'Virtual Machine <name> Acceptance Tests' -Tag 'Compute' -ForEach $VirtualMachines {
    BeforeAll {
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
        $vm = Get-VirtualMachine -Definition $Definition -Name $_.name
    }

    Context 'Virtual Machine <name>' {
        It 'Validate virtual machine <name> has been provisioned' {
            $vm | Should -Not -BeNullOrEmpty
            $vm.ProvisioningState | Should -Be 'Succeeded'
        }

        It 'Validate virtual machine location is <propertyValue>' -TestCases $case_location {
            $propertyValue | Should -Not -BeNullOrEmpty
            $vm.Location | Should -Be $propertyValue
        }
    }

    Context 'Virtual Machine <name> Hardware Profile' {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $vmHardwareProfile = $vm.HardwareProfile
        }

        It 'Validate virtual machine size is <propertyValue>' -TestCases $case_vmSize {
            $propertyValue | Should -Not -BeNullOrEmpty
            $vmHardwareProfile.VmSize | Should -Be $propertyValue
        }
    }

    Context 'Virtual Machine <name> Storage Profile' {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $vmImageReference = $vm.StorageProfile.ImageReference
        }

        It 'Validate image reference is <displayValue>' -TestCases $case_imageReference {
            $propertyValue | Should -Not -BeNullOrEmpty

            if ($propertyValue.publisher) {
                $vmImageReference.Publisher | Should -Be $propertyValue.publisher
                $vmImageReference.Offer | Should -Be $propertyValue.offer
                $vmImageReference.Sku | Should -Be $propertyValue.sku
                $vmImageReference.Version | Should -Be $propertyValue.version
            }

            if ($propertyValue.gallery) {
                $image = Get-GalleryImage `
                    -Definition $Definition `
                    -GalleryName $propertyValue.gallery `
                    -ImageName $propertyValue.name `
                    -ImageVersion $propertyValue.version `
                    -Context $propertyValue.context
    
                $image | Should -Not -BeNullOrEmpty
                $vmImageReference.Id | Should -Be $image.Id
            }
        }
    }

    Context 'Virtual Machine <name> Network Profile' {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $vmNetworkInterfaces = $vm.NetworkProfile.NetworkInterfaces
        }

        It 'Validate network interfaces contains <name>' -ForEach $networkProfile.networkInterfaces {
            $nic = Get-NetworkInterface -Definition $Definition -Name $name -Context $context
            $nic | Should -Not -BeNullOrEmpty
            $vmNetworkInterfaces.Id | Should -Contain $nic.Id
        }
    }

    Context 'Virtual Machine <name> Identity' {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $vmIdentity = $vm.Identity
        }

        It 'Validate identity type is <propertyValue>' -ForEach $case_identityType {
            $propertyValue | Should -Not -BeNullOrEmpty

            if ($propertyValue -eq 'None') {
                $vmIdentity | Should -BeNullOrEmpty
            }
            elseif ($propertyValue -eq 'SystemAssigned, UserAssigned') {
                $type = 'SystemAssignedUserAssigned'
                $vmIdentity.Type | Should -Be $type
            }
            else {
                $vmIdentity.Type | Should -Be $propertyValue
            }
        }

        It 'Validate user assigned identities contains <name>' -ForEach $identity.userAssignedIdentities {
            $identity = Get-UserAssignedIdentity -Definition $Definition -IdentityName $name -Context $context

            $identity | Should -Not -BeNullOrEmpty
            $vmIdentity.UserAssignedIdentities.Keys | Should -Contain $identity.Id
        }
    }
    
    Context 'Virtual Machine <name> Auto-shutdown' {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $vmScheduleProperties = Get-ScheduleProperties -Definition $Definition -TargetResourceId $vm.Id
        }

        It 'Validate auto shutdown <propertyName> is <propertyValue>' -TestCases $case_autoShutdown {
            $vmScheduleProperties.taskType | Should -Be 'ComputeVmShutdownTask'
            $vmScheduleProperties.$propertyName | Should -Be $propertyValue
        }
    }
}

