. $PSScriptRoot/../../Common/Common.ps1
function Find-Runners{
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition
    )

    $runners = $Definition.integration.runners

    # Set default context for runners that don't have explicit context in definition
    foreach ($runner in $runners.GetEnumerator()) {
        if ($null -eq $runner.Value.context) {
            $runner.Value.context = "default"
        }
        
        $runner.Value.contextRef = Get-Context -Definition $Definition -Context $runner.Value.context
    }

    return $runners
}

function Find-ResourceAccessChecks{
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition
    )

    $resourceAccessChecks = $Definition.integration.resourceAccessChecks

    # resolve runner reference for each resource access check
    foreach ($resourceAccessCheck in $resourceAccessChecks) {
        [System.Collections.Hashtable]$allRunners = Find-Runners -Definition $Definition
        [System.Collections.ArrayList]$runnerRefs = @()

        foreach ($runnerKey in $resourceAccessCheck.runFrom) {
            if(-not $allRunners.ContainsKey($runnerKey)) {
                throw "No runner with key $($runnerKey) was found in the runners definition."
            }

            $runner = $allRunners[$runnerKey]
            $runnerRef = @{Key=$runnerKey; Source="$($runner.vnet)/$($runner.subnet)"}
            
            $runnerRefs.Add($runnerRef)
        }

        $resourceAccessCheck.runnerRefs = $runnerRefs
    }
    return $resourceAccessChecks
}

function Find-TestDeploymentInfo{
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition
    )

    $testDeploymentInfo = $Definition.integration.testDeploymentInfo
    return $testDeploymentInfo
}

Export-ModuleMember -Function Find-Runners
Export-ModuleMember -Function Find-ResourceAccessChecks
Export-ModuleMember -Function Find-TestDeploymentInfo