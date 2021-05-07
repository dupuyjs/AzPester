function Find-Runners{
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Contexts
    )

    $runners = $Definition.integration.runners

    # Set default context for runners that don't have explicit context in definition
    foreach ($runner in $runners.GetEnumerator()) {
        if ($null -eq $runner.Value.context) {
            $runner.Value.context = $Contexts.default
        }
    }

    return $runners
}

function Find-ResourceAccessChecks{
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Contexts
    )

    $resourceAccessChecks = $Definition.integration.resourceAccessChecks

    # resolve runner reference for each resource access check
    foreach ($resourceAccessCheck in $resourceAccessChecks) {
        [System.Collections.Hashtable]$allRunners = Find-Runners -Definition $Definition -Contexts $Contexts
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