function Find-VirtualMachines {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition
    )

    $virtualMachines = $Definition.compute.$virtualMachines

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

Export-ModuleMember -Function Find-RouteTables