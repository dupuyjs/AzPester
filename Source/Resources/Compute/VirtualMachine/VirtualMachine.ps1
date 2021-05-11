. $PSScriptRoot/../../Common/Common.ps1

function Get-VirtualMachine {
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

    $contextObject = $Definition.contexts.default
    $ResourceGroupName = $contextObject.ResourceGroupName

    if ($Context) {
        $contextObject = Get-Context -Definition $Definition -Context $Context
        $resourceGroupName = $contextObject.ResourceGroupName
    }

    Get-AzVM -ResourceGroupName $ResourceGroupName -Name $Name -DefaultProfile $contextObject.Value.Context
}

function Get-VirtualMachineSubnets {
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

    $subnets = @()

    $contextObject = $Definition.contexts.default
    $ResourceGroupName = $contextObject.ResourceGroupName

    if ($Context) {
        $contextObject = Get-Context -Definition $Definition -Context $Context
        $resourceGroupName = $contextObject.ResourceGroupName
    }

    $vm = Get-VirtualMachine -Definition $Definition -Name $Name

    ForEach ($nicReference in $vm.NetworkProfile.NetworkInterfaces) {
        $nicName = $nicReference.Id.Split('/')[-1]
        $nic = Get-AzNetworkInterface -ResourceGroupName $ResourceGroupName -Name $nicName -DefaultProfile $contextObject.Value.Context

        ForEach ($ipconfig in $nic.IpConfigurations) {
            $subnetName = $ipconfig.Subnet.Id.Split('/')[-1]
            $vNetName = $ipconfig.Subnet.Id.Split('/')[-3]
            $subnets += @{vnet=$vNetName; subnet=$subnetName}
        }
    }

    $subnets
}

function Get-GalleryImage {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $GalleryName,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $ImageName,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $ImageVersion,
        [Parameter(Mandatory = $false)]
        [String] $Context
    )

    $contextObject = $Definition.contexts.default
    $ResourceGroupName = $contextObject.ResourceGroupName

    if ($Context) {
        $contextObject = Get-Context -Definition $Definition -Context $Context
        $resourceGroupName = $contextObject.ResourceGroupName
    }

    Get-AzGalleryImageVersion -ResourceGroupName $resourceGroupName `
        -GalleryName $GalleryName `
        -GalleryImageDefinitionName $ImageName `
        -GalleryImageVersionName $ImageVersion `
        -DefaultProfile $contextObject.Value.Context
}

function Get-UserAssignedIdentity {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $IdentityName,
        [Parameter(Mandatory = $false)]
        [String] $Context
    )

    $contextObject = $Definition.contexts.default
    $ResourceGroupName = $contextObject.ResourceGroupName
    
    if ($Context) {
        $contextObject = Get-Context -Definition $Definition -Context $Context
        $resourceGroupName = $contextObject.ResourceGroupName
    }

    Get-AzUserAssignedIdentity -ResourceGroupName $resourceGroupName -Name $IdentityName -DefaultProfile $contextObject.Value.Context
}

function Get-ScheduleProperties {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $TargetResourceId,
        [Parameter(Mandatory = $false)]
        [String] $Context
    )

    $contextObject = $Definition.contexts.default
    $ResourceGroupName = $contextObject.ResourceGroupName

    if ($Context) {
        $contextObject = Get-Context -Definition $Definition -Context $Context
        $resourceGroupName = $contextObject.ResourceGroupName
    }

    $schedules = (Get-AzResource -ResourceGroupName $resourceGroupName -DefaultProfile $contextObject.Value.Context -ResourceType Microsoft.DevTestLab/schedules -ExpandProperties).Properties
    $schedules | Where-Object targetResourceId -eq $TargetResourceId 
}
