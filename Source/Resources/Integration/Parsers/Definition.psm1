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
        [PSObject] $Definition
    )

    $resourceAccessChecks = $Definition.integration.resourceAccessChecks
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