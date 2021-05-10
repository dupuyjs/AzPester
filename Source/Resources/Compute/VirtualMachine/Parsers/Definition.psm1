function Find-VirtualMachines {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition
    )

    $virtualMachines = $Definition.compute.virtualMachines

    foreach ($vm in $virtualMachines) {
        $vm.case_vmSize = @()
        if ($vm.vmSize) {
            $vm.case_vmSize += Add-Property -PropertyName vmSize -PropertyValue $vm.vmSize
        }

        $vm.case_imageReference = @()
        if ($vm.imageReference) {
            $vm.case_imageReference += Add-Property -PropertyName imageReference -PropertyValue $vm.imageReference
        }

        $vm.case_networkProfile = @()
        if ($vm.networkProfile) {
            $vm.case_networkProfile += Add-Property -PropertyName networkProfile -PropertyValue $vm.networkProfile
        }

        $vm.case_autoShutdown = @()
        if ($vm.autoShutdown) {
            $vm.case_autoShutdown += Add-Property -PropertyName autoShutdown -PropertyValue $vm.autoShutdown
        }

        $vm.case_userAssignedIdentity = @()
        if ($vm.userAssignedIdentity) {
            $vm.case_userAssignedIdentity += Add-Property -PropertyName userAssignedIdentity -PropertyValue $vm.userAssignedIdentity
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
        [PSObject] $PropertyValue
    )

    return @{propertyName = $PropertyName; propertyValue = $PropertyValue }
}

Export-ModuleMember -Function Find-VirtualMachines
