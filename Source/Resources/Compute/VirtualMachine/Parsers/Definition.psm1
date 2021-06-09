function Find-VirtualMachines {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition
    )

    $virtualMachines = $Definition.compute.virtualMachines

    foreach ($vm in $virtualMachines) {
        
        $vm.case_location = @()
        if ($vm.location) {
            $vm.case_location += Add-Property -PropertyName 'location' -PropertyValue $vm.location
        }

        $vm.case_vmSize = @()
        if ($vm.hardwareProfile) {
            if ($vm.hardwareProfile.vmSize) {
                $vm.case_vmSize += Add-Property -PropertyName 'vmSize' -PropertyValue $vm.hardwareProfile.vmSize
            }
        }

        $vm.case_imageReference = @()
        if ($vm.storageProfile) {
            if ($vm.storageProfile.imageReference) {
                if ($vm.storageProfile.imageReference.publisher) {
                    $vm.case_imageReference += Add-Property -PropertyName 'imageReference' -PropertyValue $vm.storageProfile.imageReference -DisplayValue $vm.storageProfile.imageReference.publisher
                }
                elseif ($vm.storageProfile.imageReference.gallery) {
                    $vm.case_imageReference += Add-Property -PropertyName 'imageReference' -PropertyValue $vm.storageProfile.imageReference -DisplayValue $vm.storageProfile.imageReference.name
                }
            }
        }

        $vm.case_autoShutdown = @()
        if ($vm.autoShutdown) {
            if ($vm.autoShutdown.status) {
                $vm.case_autoShutdown += Add-Property -PropertyName 'status' -PropertyValue $vm.autoShutdown.status
            }
            if ($vm.autoShutdown.dailyRecurrence) {
                $vm.case_autoShutdown += Add-Property -PropertyName 'dailyRecurrence' -PropertyValue $vm.autoShutdown.dailyRecurrence
            }
            if ($vm.autoShutdown.timeZoneId) {
                $vm.case_autoShutdown += Add-Property -PropertyName 'timeZoneId' -PropertyValue $vm.autoShutdown.timeZoneId
            }
        }

        $vm.case_identityType = @()
        if ($vm.identity) {
            if ($vm.identity.type) {
                $vm.case_identityType += Add-Property -PropertyName 'type' -PropertyValue $vm.identity.type
            }
        }
    }

    return $virtualMachines
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

Export-ModuleMember -Function Find-VirtualMachines
