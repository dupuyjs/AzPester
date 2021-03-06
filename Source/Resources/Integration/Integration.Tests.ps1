param (
    [Parameter(Mandatory = $true)]
    [PSObject] $Definition
)

BeforeDiscovery {
    Import-Module -Force $PSScriptRoot/Parsers/Definition.psm1
    Import-Module -Force $PSScriptRoot/Integration.Infrastructure.psm1
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    $ResourceAccessChecks = Find-ResourceAccessChecks -Definition $Definition
}

Describe 'Integration Tests' -Tag 'Integration' {
    BeforeAll {
        # Deploy testing infrastructure according to integration tests definition file.
        $TestDeploymentInfo = Find-TestDeploymentInfo -Definition $Definition
        $Runners = Find-Runners -Definition $Definition
        New-TestInfrastructure -TestDeploymentInfo $TestDeploymentInfo -Runners $Runners -Contexts $Definition.contexts
    }

    AfterAll {
        $TestDeploymentInfo = Find-TestDeploymentInfo -Definition $Definition
        if ($TestDeploymentInfo.cleanup) {
            Remove-TestInfrastructure -TestDeploymentInfo $TestDeploymentInfo
        } else {
            Write-Information "[##] Skipping clean up of test infrastructure."
        }
    }

    Context 'Resource Access Check - Target Host: <targetHost>:<targetPort>' -Foreach $ResourceAccessChecks {
        It '<targetHost>:<targetPort> is reachable from <_.Source>' -ForEach $runnerRefs {
            $runner = $Runners[$_.Key]
            Write-Information "    [#] Test will be executed from virtual machine $($runner.vm.Id)."

            $result = Invoke-CheckResourceAccessCommand -RunnerVmId $runner.vm.Id `
                -RunnerContext $runner.contextRef `
                -Hostname $targetHost `
                -Port $targetPort `
            
            $result.Status | Should -Be 'Succeeded'
            $result.ExitCode | Should -Be 0
        }
    }
}

