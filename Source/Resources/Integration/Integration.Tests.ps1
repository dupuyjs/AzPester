param (
    [Parameter(Mandatory = $true)]
    [PSObject] $Definition,
    [Parameter(Mandatory = $true)]
    [PSObject] $Contexts
)

BeforeDiscovery {
    Import-Module -Force $PSScriptRoot/Parsers/Definition.psm1
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]

    $ResourceAccessChecks = Find-ResourceAccessChecks -Definition $Definition
    $Runners = Find-Runners -Definition $Definition
}

BeforeAll {
    # Create integration test runners
    foreach ($runner in $Runners.GetEnumerator()) {
        Write-Host $runner.key
        Write-Host $runner.value.vnet
    }
}

AfterAll {
    # Delete integration test runners
    foreach ($runner in $Runners.GetEnumerator()) {
        Write-Host $runner.key
        Write-Host $runner.value.vnet
    }
}

Describe 'Resource Access Checks <targetHost>:<targetPort>' -ForEach $ResourceAccessChecks {
    Context 'Runner <_>' -Foreach $_.runners {
        It 'Check resource access from runner <name>' {
            # todo
        }
    }
}

