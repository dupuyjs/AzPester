function Find-PrivateDnsZones {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition
    )

    $dnsZones = $Definition.network.privateDnsZones

    foreach ($dnsZone in $dnsZones) {
        $properties = @()

        if ($dnsZone.location) {
            $properties += Add-Property -PropertyName 'location' -PropertyValue $dnsZone.location
        }

        if ($dnsZone.virtualNetworkLinks) {
            foreach ($link in $dnsZone.virtualNetworkLinks) {
                $linkProperties = @()

                if ($link.PSObject.BaseObject.Contains("virtualNetwork")) {
                    $linkProperties += Add-Property -PropertyName 'virtualNetwork' -PropertyValue $link.virtualNetwork -DisplayValue $link.virtualNetwork.name 
                }
                if ($link.PSObject.BaseObject.Contains("registrationEnabled")) {
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
        [PSObject] $PropertyValue,
        [Parameter(Mandatory = $false)]
        [PSObject] $DisplayValue
    )

    if (!$DisplayValue) {
        $DisplayValue = $PropertyValue
    }

    return @{propertyName = $PropertyName; propertyValue = $PropertyValue; displayValue = $DisplayValue }
}

Export-ModuleMember -Function Find-PrivateDnsZones