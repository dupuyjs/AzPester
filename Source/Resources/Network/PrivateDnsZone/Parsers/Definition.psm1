function Find-PrivateDnsZones {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition
    )

    $dnsZones = $Definition.network.privateDnsZones

    foreach ($dnsZone in $dnsZones) {
        $properties = @()

        if ($dnsZone.name) {
            $properties += Add-Property -PropertyName 'name' -PropertyValue $dnsZone.name
        }

        if ($dnsZone.location) {
            $properties += Add-Property -PropertyName 'location' -PropertyValue $dnsZone.location
        }

        if ($dnsZone.virtualNetworkLinks) {
            foreach ($link in $dnsZone.virtualNetworkLinks) {
                $linkProperties = @()

                if ($link.name) {
                    $linkProperties += Add-Property -PropertyName 'name' -PropertyValue $link.name
                }
                if ($link.virtualNetworkName) {
                    $linkProperties += Add-Property -PropertyName 'virtualNetworkName' -PropertyValue $link.virtualNetworkName
                }
                if ($link.registrationEnabled) {
                    $linkProperties += Add-Property -PropertyName 'registrationEnabled' -PropertyValue $link.registrationEnabled
                }

                $link.properties = $linkProperties
            }
        }

        $dnsZone.properties = $properties
    }

    return $dnsZones
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

Export-ModuleMember -Function Find-PrivateDnsZones