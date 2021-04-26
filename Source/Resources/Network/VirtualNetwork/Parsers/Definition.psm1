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
            $properties += @{propertyName = 'location'; propertyValue = $virtualNetwork.location }
        }
        if ($null -ne $virtualNetwork.enableDdosProtection) {
            $properties += @{propertyName = 'enableDdosProtection'; propertyValue = $virtualNetwork.enableDdosProtection }
        }

        if ($virtualNetwork.subnets) {
            foreach ($subnet in $virtualNetwork.subnets) {
                $subnetProperties = @()

                if($subnet.addressPrefix) {
                    $subnetProperties += @{propertyName = 'addressPrefix'; propertyValue = $subnet.addressPrefix }
                }
                if($subnet.networkSecurityGroup) {
                    $subnetProperties += @{propertyName = 'networkSecurityGroup'; propertyValue = $subnet.networkSecurityGroup.name }
                }
                if($subnet.routeTable) {
                    $subnetProperties += @{propertyName = 'routeTable'; propertyValue = $subnet.routeTable.name }
                }

                $subnet.properties = $subnetProperties
            }
        }

        $virtualNetwork.properties = $properties
    }

    return $virtualNetworks
}