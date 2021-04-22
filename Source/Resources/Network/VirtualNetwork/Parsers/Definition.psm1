function Find-VirtualNetworks {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition
    )

    $Definition.network.virtualNetworks
}