function Find-VirtualNetworks {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition
    )

    $virtualNetworks = $Definition.network.virtualNetworks

    foreach ($virtualNetwork in $virtualNetworks) {
        $properties = @()
        if ($virtualNetwork.location) {
            $properties += @{name = 'location'; value = $virtualNetwork.location }
        }
        $virtualNetwork.properties = $properties
    }

    return $virtualNetworks
}