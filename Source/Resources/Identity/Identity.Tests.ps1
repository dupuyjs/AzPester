param (
    [Parameter(Mandatory = $true)]
    [PSObject] $Definition
)

BeforeDiscovery {
    Import-Module -Force $PSScriptRoot/Parsers/Definition.psm1
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    $ServicePrincipals = Find-ServicePrincipals -Definition $Definition
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    $ManagedIdentities = Find-ManagedIdentities -Definition $Definition
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    $Groups = Find-Groups -Definition $Definition
}

BeforeAll { 
    . $PSScriptRoot/Identity.ps1
}

Describe 'Identity Acceptance Tests' {
    Context 'Service Principal <name>' -ForEach $ServicePrincipals {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $identity = Get-AzADServicePrincipal -DisplayName $name
        }
        
        It 'Validate <name> has been created' {
            $identity | Should -Not -BeNullOrEmpty
        }
        It 'Validate <name> has <role> role on <scope.displayName> resource' -ForEach $roleAssignments {
            $roleAssignment = Get-RoleAssignment -Definition $Definition -ObjectId $identity.Id -Scope $scope.scope
            $roleAssignment.RoleDefinitionName | Should -Be $role
        }
    }

    Context 'Managed Identity <name>' -ForEach $ManagedIdentities {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $identity = Get-UserAssignedIdentity -Definition $Definition -Name $name -Context $context
        }

        It 'Validate <name> has been created' {
            $identity | Should -Not -BeNullOrEmpty
        }
        It 'Validate <name> has <role> role on <scope.displayName> resource' -ForEach $roleAssignments {
            $roleAssignment = Get-RoleAssignment -Definition $Definition -ObjectId $identity.PrincipalId -Scope $scope.scope
            $roleAssignment.RoleDefinitionName | Should -Be $role
        }
    }
    
    Context 'Group <name>' -ForEach $Groups {
        BeforeAll {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
            $identity = Get-AzADGroup -DisplayName $name
        }
        
        It 'Validate <name> has been created' {
            $identity | Should -Not -BeNullOrEmpty
        }
        It 'Validate <name> has <role> role on <scope.displayName> resource' -ForEach $roleAssignments {
            $roleAssignment = Get-RoleAssignment -Definition $Definition -ObjectId $identity.Id -Scope $scope.scope
            $roleAssignment.RoleDefinitionName | Should -Be $role
        }
    }
}