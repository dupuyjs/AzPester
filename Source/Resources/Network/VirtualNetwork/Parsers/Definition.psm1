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
            $properties += Add-Property -PropertyName 'location' -PropertyValue $virtualNetwork.location
        }
        if ($null -ne $virtualNetwork.enableDdosProtection) {
            $properties += Add-Property -PropertyName 'enableDdosProtection' -PropertyValue $virtualNetwork.enableDdosProtection
        }

        if ($virtualNetwork.subnets) {
            foreach ($subnet in $virtualNetwork.subnets) {
                $subnetProperties = @()

                if ($subnet.addressPrefix) {
                    $subnetProperties += Add-Property -PropertyName 'addressPrefix' -PropertyValue $subnet.addressPrefix
                }
                if ($subnet.privateEndpointNetworkPolicies) {
                    $subnetProperties += Add-Property -PropertyName 'privateEndpointNetworkPolicies' -PropertyValue $subnet.privateEndpointNetworkPolicies
                }
                if ($subnet.privateLinkServiceNetworkPolicies) {
                    $subnetProperties += Add-Property -PropertyName 'privateLinkServiceNetworkPolicies' -PropertyValue $subnet.privateLinkServiceNetworkPolicies
                }
                if ($subnet.networkSecurityGroup) {
                    $subnetProperties += Add-Property -PropertyName 'networkSecurityGroup' -PropertyValue $subnet.networkSecurityGroup -DisplayValue $subnet.networkSecurityGroup.name 
                }
                if ($subnet.routeTable) {
                    $subnetProperties += Add-Property -PropertyName 'routeTable' -PropertyValue $subnet.routeTable -DisplayValue $subnet.routeTable.name
                }

                $subnet.properties = $subnetProperties
            }
        }

        if ($virtualNetwork.virtualNetworkPeerings) {
            foreach ($peering in $virtualNetwork.virtualNetworkPeerings) {
                $peeringProperties = @()

                if ($null -ne $peering.allowVirtualNetworkAccess) {
                    $peeringProperties += Add-Property -PropertyName 'allowVirtualNetworkAccess' -PropertyValue $peering.allowVirtualNetworkAccess
                }
                if ($null -ne $peering.allowForwardedTraffic) {
                    $peeringProperties += Add-Property -PropertyName 'allowForwardedTraffic' -PropertyValue $peering.allowForwardedTraffic
                }
                if ($null -ne $peering.allowGatewayTransit) {
                    $peeringProperties += Add-Property -PropertyName 'allowGatewayTransit' -PropertyValue $peering.allowGatewayTransit
                }
                if ($null -ne $peering.useRemoteGateways) {
                    $peeringProperties += Add-Property -PropertyName 'useRemoteGateways' -PropertyValue $peering.useRemoteGateways
                }

                $peering.properties = $peeringProperties
            }
        }

        $virtualNetwork.properties = $properties
    }

    return $virtualNetworks
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

Export-ModuleMember -Function Find-VirtualNetworks