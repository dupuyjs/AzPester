function Find-RouteTables {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition
    )

    $routeTables = $Definition.network.routeTables

    foreach ($routeTable in $routeTables) {
        $properties = @()

        if ($routeTable.location) {
            $properties += Add-Property -PropertyName 'location' -PropertyValue $routeTable.location
        }

        if ($routeTable.routes) {
            foreach ($route in $routeTable.routes) {
                $routeProperties = @()

                if ($route.addressPrefix) {
                    $routeProperties += Add-Property -PropertyName 'addressPrefix' -PropertyValue $route.addressPrefix
                }
                if ($route.nextHopType) {
                    $routeProperties += Add-Property -PropertyName 'nextHopType' -PropertyValue $route.nextHopType
                }
                if ($route.nextHopIpAddress) {
                    $routeProperties += Add-Property -PropertyName 'nextHopIpAddress' -PropertyValue $route.nextHopIpAddress
                }

                $route.properties = $routeProperties
            }
        }

        $routeTable.properties = $properties
    }

    return $routeTables
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