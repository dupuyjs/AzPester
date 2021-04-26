function Get-VirtualNetwork {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Contexts,
        [ValidateNotNullOrEmpty()]
        [String] $Name
    )

    $resourceGroupName = $Contexts.default.resourceGroupName
    if ([string]::IsNullOrWhiteSpace($resourceGroupName)) {
        throw 'The default resourceGroupName input value is Null|Empty or WhiteSpace.'
    }

    Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $Name
}

function Get-NetworkSecurityGroup {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Contexts,
        [ValidateNotNullOrEmpty()]
        [String] $Name
    )

    $resourceGroupName = $Contexts.default.resourceGroupName
    if ([string]::IsNullOrWhiteSpace($resourceGroupName)) {
        throw 'The default resourceGroupName input value is Null|Empty or WhiteSpace.'
    }

    Get-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Name $Name
}

function Get-RouteTable {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Contexts,
        [ValidateNotNullOrEmpty()]
        [String] $Name
    )

    $resourceGroupName = $Contexts.default.resourceGroupName
    if ([string]::IsNullOrWhiteSpace($resourceGroupName)) {
        throw 'The default resourceGroupName input value is Null|Empty or WhiteSpace.'
    }

    Get-AzRouteTable -ResourceGroupName $resourceGroupName -Name $Name
}