function Get-Context {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Context
    )

    $defContexts = $Definition.contexts
    $curContext = ${defContexts}?[$Context]

    if ($null -ne $curContext) {
        return $curContext
    }
    else {
        throw "Context $Context is unknown. This context should be referenced in contexts section."
    }
}

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