function Find-NetworkSecurityGroups {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition
    )

    $networkSecurityGroups = $Definition.network.networkSecurityGroups

    foreach ($networkSecurityGroup in $networkSecurityGroups) {
        $properties = @()

        if ($networkSecurityGroup.location) {
            $properties += Add-Property -PropertyName 'location' -PropertyValue $networkSecurityGroup.location
        }

        if ($networkSecurityGroup.securityRules) {
            foreach ($securityRule in $networkSecurityGroup.securityRules) {
                $ruleProperties = @()

                if ($securityRule.protocol) {
                    $ruleProperties += Add-Property -PropertyName 'protocol' -PropertyValue $securityRule.protocol
                }
                if ($securityRule.sourcePortRange) {
                    $ruleProperties += Add-Property -PropertyName 'sourcePortRange' -PropertyValue $securityRule.sourcePortRange
                }
                if ($securityRule.destinationPortRange) {
                    $ruleProperties += Add-Property -PropertyName 'destinationPortRange' -PropertyValue $securityRule.destinationPortRange
                }
                if ($securityRule.sourceAddressPrefix) {
                    $ruleProperties += Add-Property -PropertyName 'sourceAddressPrefix' -PropertyValue $securityRule.sourceAddressPrefix
                }
                if ($securityRule.destinationAddressPrefix) {
                    $ruleProperties += Add-Property -PropertyName 'destinationAddressPrefix' -PropertyValue $securityRule.destinationAddressPrefix
                }
                if ($securityRule.access) {
                    $ruleProperties += Add-Property -PropertyName 'access' -PropertyValue $securityRule.access
                }
                if ($securityRule.priority) {
                    $ruleProperties += Add-Property -PropertyName 'priority' -PropertyValue $securityRule.priority
                }
                if ($securityRule.direction) {
                    $ruleProperties += Add-Property -PropertyName 'direction' -PropertyValue $securityRule.direction
                }

                $securityRule.properties = $ruleProperties
            }
        }

        if ($networkSecurityGroup.defaultSecurityRules) {
            foreach ($securityRule in $networkSecurityGroup.defaultSecurityRules) {
                $ruleProperties = @()

                if ($securityRule.protocol) {
                    $ruleProperties += Add-Property -PropertyName 'protocol' -PropertyValue $securityRule.protocol
                }
                if ($securityRule.sourcePortRange) {
                    $ruleProperties += Add-Property -PropertyName 'sourcePortRange' -PropertyValue $securityRule.sourcePortRange
                }
                if ($securityRule.destinationPortRange) {
                    $ruleProperties += Add-Property -PropertyName 'destinationPortRange' -PropertyValue $securityRule.destinationPortRange
                }
                if ($securityRule.sourceAddressPrefix) {
                    $ruleProperties += Add-Property -PropertyName 'sourceAddressPrefix' -PropertyValue $securityRule.sourceAddressPrefix
                }
                if ($securityRule.destinationAddressPrefix) {
                    $ruleProperties += Add-Property -PropertyName 'destinationAddressPrefix' -PropertyValue $securityRule.destinationAddressPrefix
                }
                if ($securityRule.access) {
                    $ruleProperties += Add-Property -PropertyName 'access' -PropertyValue $securityRule.access
                }
                if ($securityRule.priority) {
                    $ruleProperties += Add-Property -PropertyName 'priority' -PropertyValue $securityRule.priority
                }
                if ($securityRule.direction) {
                    $ruleProperties += Add-Property -PropertyName 'direction' -PropertyValue $securityRule.direction
                }

                $securityRule.properties = $ruleProperties
            }
        }

        $networkSecurityGroup.properties = $properties
    }

    return $networkSecurityGroups
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

Export-ModuleMember -Function Find-NetworkSecurityGroups