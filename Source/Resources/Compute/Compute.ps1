. $PSScriptRoot/../Common/Common.ps1
. $PSScriptRoot/../Identity/Identity.ps1

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

function Get-NetworkInterface {
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

    Get-AzNetworkInterface -ResourceGroupName $ResourceGroupName -Name $Name -DefaultProfile $contextObject.Value.Context
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