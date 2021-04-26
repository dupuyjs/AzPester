function Get-VirtualNetwork {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Contexts,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Name,
        [Parameter(Mandatory = $false)]
        [String] $SubscriptionId,
        [Parameter(Mandatory = $false)]
        [String] $ResourceGroupName
    )

    if(!$ResourceGroupName) {
        $ResourceGroupName = $Contexts.default.resourceGroupName
        if ([string]::IsNullOrWhiteSpace($ResourceGroupName)) {
            throw 'The default resourceGroupName input value is Null|Empty or WhiteSpace.'
        }
    }

    if($SubscriptionId) {
        ForEach ($context in $Contexts.GetEnumerator()) {
            if ($context.Value.SubscriptionId -eq $SubscriptionId) {
                # Get virtual network
                $virtualNetwork = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Name $Name -DefaultProfile $context.Value.Context
                return $virtualNetwork 
            }
        }

        Write-Host "Warning: Subscription $SubscriptionId is unknown. This subscription should be referenced in contexts." -ForegroundColor Yellow
    }
    
    Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Name $Name
}

function Get-NetworkSecurityGroup {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Contexts,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Name,
        [Parameter(Mandatory = $false)]
        [String] $SubscriptionId,
        [Parameter(Mandatory = $false)]
        [String] $ResourceGroupName
    )

    if(!$ResourceGroupName) {
        $ResourceGroupName = $Contexts.default.resourceGroupName
        if ([string]::IsNullOrWhiteSpace($ResourceGroupName)) {
            throw 'The default resourceGroupName input value is Null|Empty or WhiteSpace.'
        }
    }

    if($SubscriptionId) {
        ForEach ($context in $Contexts.GetEnumerator()) {
            if ($context.Value.SubscriptionId -eq $SubscriptionId) {
                # Get network security group
                $nsg = Get-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Name $Name -DefaultProfile $context.Value.Context
                return $nsg 
            }
        }

        Write-Host "Warning: Subscription $SubscriptionId is unknown. This subscription should be referenced in contexts." -ForegroundColor Yellow
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
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Name,
        [Parameter(Mandatory = $false)]
        [String] $SubscriptionId,
        [Parameter(Mandatory = $false)]
        [String] $ResourceGroupName
    )

    if(!$ResourceGroupName) {
        $ResourceGroupName = $Contexts.default.resourceGroupName
        if ([string]::IsNullOrWhiteSpace($ResourceGroupName)) {
            throw 'The default resourceGroupName input value is Null|Empty or WhiteSpace.'
        }
    }

    if($SubscriptionId) {
        ForEach ($context in $Contexts.GetEnumerator()) {
            if ($context.Value.SubscriptionId -eq $SubscriptionId) {
                # Get route table
                $routeTable = Get-AzRouteTable -ResourceGroupName $ResourceGroupName -Name $Name -DefaultProfile $context.Value.Context
                return $routeTable 
            }
        }

        Write-Host "Warning: Subscription $SubscriptionId is unknown. This subscription should be referenced in contexts." -ForegroundColor Yellow
    }

    Get-AzRouteTable -ResourceGroupName $resourceGroupName -Name $Name
}