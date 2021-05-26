. $PSScriptRoot/../Common/Common.ps1

function Get-VirtualNetwork {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Name,
        [Parameter(Mandatory = $false)]
        [String] $Context
    )

    if ($Context) {
        $curContext = Get-Context -Definition $Definition -Context $Context

        $virtualNetwork = Get-AzVirtualNetwork `
            -ResourceGroupName $curContext.ResourceGroupName `
            -Name $Name `
            -DefaultProfile $curContext.Context
        return $virtualNetwork
    }
    else {
        $resourceGroupName = $Definition.contexts.default.ResourceGroupName
        if ([string]::IsNullOrWhiteSpace($ResourceGroupName)) {
            throw 'The default context resource group name is Null|Empty or WhiteSpace.'
        }

        Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $Name
    }
}

function Get-NetworkSecurityGroup {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Name,
        [Parameter(Mandatory = $false)]
        [String] $Context
    )

    if ($Context) {
        $curContext = Get-Context -Definition $Definition -Context $Context
        $nsg = Get-AzNetworkSecurityGroup `
            -ResourceGroupName $curContext.ResourceGroupName `
            -Name $Name `
            -DefaultProfile $curContext.Context
        return $nsg
    }
    else {
        $resourceGroupName = $Definition.contexts.default.ResourceGroupName
        if ([string]::IsNullOrWhiteSpace($ResourceGroupName)) {
            throw 'The default context resource group name is Null|Empty or WhiteSpace.'
        }

        Get-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Name $Name
    }
}

function Get-RouteTable {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Name,
        [Parameter(Mandatory = $false)]
        [String] $Context
    )

    if ($Context) {
        $curContext = Get-Context -Definition $Definition -Context $Context
        $routeTable = Get-AzRouteTable `
            -ResourceGroupName $curContext.ResourceGroupName `
            -Name $Name `
            -DefaultProfile $curContext.Context
        return $routeTable
    }
    else {
        $resourceGroupName = $Definition.contexts.default.ResourceGroupName
        if ([string]::IsNullOrWhiteSpace($ResourceGroupName)) {
            throw 'The default context resource group name is Null|Empty or WhiteSpace.'
        }

        Get-AzRouteTable -ResourceGroupName $resourceGroupName -Name $Name
    }
}

function Get-PrivateDnsZone {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Name,
        [Parameter(Mandatory = $false)]
        [String] $Context
    )

    if ($Context) {
        $curContext = Get-Context -Definition $Definition -Context $Context
        $zone = Get-AzPrivateDnsZone `
            -ResourceGroupName $curContext.ResourceGroupName `
            -Name $Name `
            -DefaultProfile $curContext.Context
        return $zone
    }
    else {
        $resourceGroupName = $Definition.contexts.default.ResourceGroupName
        if ([string]::IsNullOrWhiteSpace($ResourceGroupName)) {
            throw 'The default context resource group name is Null|Empty or WhiteSpace.'
        }

        Get-AzPrivateDnsZone -ResourceGroupName $resourceGroupName -Name $Name
    }
}

function Get-PrivateDnsVirtualNetworkLink {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $PrivateDnsZoneName,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Name,
        [Parameter(Mandatory = $false)]
        [String] $Context
    )

    if ($Context) {
        $curContext = Get-Context -Definition $Definition -Context $Context
        $link = Get-AzPrivateDnsVirtualNetworkLink `
            -ResourceGroupName $curContext.ResourceGroupName `
            -ZoneName $PrivateDnsZoneName `
            -Name $Name `
            -DefaultProfile $curContext.Context
        return $link
    }
    else {
        $resourceGroupName = $Definition.contexts.default.ResourceGroupName
        if ([string]::IsNullOrWhiteSpace($ResourceGroupName)) {
            throw 'The default context resource group name is Null|Empty or WhiteSpace.'
        }

        Get-AzPrivateDnsVirtualNetworkLink -ResourceGroupName $resourceGroupName -ZoneName $PrivateDnsZoneName -Name $Name
    }
}
