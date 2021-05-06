function Find-Runners{
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition
    )

    $runners = $Definition.integration.runners
    return $runners
}

function Find-ResourceAccessChecks{
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition
    )
}

Export-ModuleMember -Function Find-Runners
Export-ModuleMember -Function Find-ResourceAccessChecks