function Invoke-AzPester {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Definition,
        [Parameter(Mandatory = $false)]
        [String] $Parameters,
        [Parameter(Mandatory = $false)]
        [String[]] $Tags,
        [Parameter(Mandatory = $false)]
        [String[]] $ExcludeTags
    )

    $definitionJson = Get-Json $Definition
    # Parameters file is optional
    if ($Parameters) {
        $parametersJson = Get-Json $Parameters
    }

    # Validate schemas from definition and parameters json files
    $isValidSchemas = Assert-Schemas -DefinitionJson $definitionJson -ParametersJson $parametersJson
    if ($isValidSchemas) {

        $definitionHash = $DefinitionJson | ConvertFrom-Json -AsHashtable
        # Parameters file is optional
        if ($Parameters) {
            $parametersHash = $parametersJson | ConvertFrom-Json -AsHashtable
            $deployment = $ParametersHash.deployment
            
            if ($deployment) {
                # Check if we need to retrieve additional parameters from deployment
                $parametersDepl = Get-DeploymentParameters -DeploymentInfo $deployment
            }
        }
        
        $isValidParameters = Assert-Parameters `
            -DefinitionHash $definitionHash `
            -ParametersHash $parametersHash `
            -ParametersDepl $parametersDepl

        if ($isValidParameters) {
            $definitionWithParameters = Set-Parameters `
                -DefinitionJson $definitionJson `
                -DefinitionHash $definitionHash `
                -ParametersHash $parametersHash `
                -ParametersDepl $parametersDepl

            # Getting contexts and assigning them to the definition
            $contexts = Get-Contexts -DefinitionHash $definitionWithParameters
            $definitionWithParameters.definition.contexts = $contexts

            # Switching on default subscription
            Set-AzContext -Context $contexts["default"].Context

            $path = "$PSScriptRoot/Resources/*"
            $container = New-PesterContainer -Path $path -Data @{ Definition = $definitionWithParameters.definition }
            
            Invoke-Pester -Container $container -TagFilter $Tags -ExcludeTagFilter $ExcludeTags -Output 'Detailed' -CI
        }
    }
}

function Get-Json {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $FilePath
    )

    if ($FilePath -match '\.yaml$' -or $FilePath -match '\.yml$') {
        $yaml = Get-Content $FilePath -Raw
        $json = (ConvertFrom-Yaml -Yaml $yaml) | ConvertTo-Json -Depth 100
    }
    else {
        $json = Get-Content $FilePath -Raw
    }

    return $json
}

function Get-DeploymentParameters {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSObject] $DeploymentInfo
    )

    Write-Host "Getting $($DeploymentInfo.name) deployment parameters." -ForegroundColor Magenta
    $context = Get-AzSubscription -SubscriptionId $deployment.subscriptionId | Set-AzContext
    $deployment = Get-AzResourceGroupDeployment -ResourceGroupName $deployment.resourceGroupName -Name $deployment.name -DefaultProfile $context

    return $deployment.Parameters
}

function Assert-Schemas {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $DefinitionJson,
        [Parameter(Mandatory = $false)]
        [String] $ParametersJson
    )

    $parametersSchema = "$PSScriptRoot/Schemas/2021-04/schema.definition.parameters.json"
    $definitionSchema = "$PSScriptRoot/Schemas/2021-04/schema.definition.json"

    $isValidDefinitionSchema = Test-Json -Json $DefinitionJson -SchemaFile $definitionSchema
    if (!$isValidDefinitionSchema) {
        Write-Host "Validation Failed: Please check definition file, schema is invalid." -ForegroundColor Red
        return $false
    }

    # Parameters file is optional
    if ($ParametersJson) {
        $isValidParametersSchema = Test-Json -Json $ParametersJson -SchemaFile $parametersSchema
        if (!$isValidParametersSchema) {
            Write-Host "Validation Failed: Please check parameters file, schema is invalid." -ForegroundColor Red
            return $false
        }
    }

    return $true
}

function Assert-Parameters {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSObject] $DefinitionHash,
        [Parameter(Mandatory = $false)]
        [PSObject] $ParametersHash,
        [Parameter(Mandatory = $false)]
        [PSObject] $ParametersDepl
    )

    $targetParameters = $DefinitionHash.parameters
    if ($null -eq $targetParameters) {
        # Definition file contains no parameter, nothing to assert
        return $true
    }

    # Parameters file is optional
    if ($ParametersHash) {
        $sourceParameters = $ParametersHash.parameters
        if ($ParametersDepl) {
            foreach ($parameter in $targetParameters.GetEnumerator()) {
                if (!$sourceParameters.ContainsKey($parameter.key) -and !$ParametersDepl.ContainsKey($parameter.key) -and ($null -eq $parameter.value.defaultValue)) {
                    Write-Host "Validation Failed: Input parameter $($parameter.key) value is missing." -ForegroundColor Red
                    return $false
                }
            }
        }
        else {
            foreach ($parameter in $targetParameters.GetEnumerator()) {
                if (!$sourceParameters.ContainsKey($parameter.key) -and ($null -eq $parameter.value.defaultValue)) {
                    Write-Host "Validation Failed: Input parameter $($parameter.key) value is missing." -ForegroundColor Red
                    return $false
                }
            }
        }
    }
    else {
        foreach ($parameter in $targetParameters.GetEnumerator()) {
            if ($null -eq $parameter.value.defaultValue) {
                Write-Host "Validation Failed: Input parameter $($parameter.key) value is missing." -ForegroundColor Red
                return $false
            }
        }
    }
    
    return $true
}

function Set-Parameters {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $DefinitionJson,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSObject] $DefinitionHash,
        [Parameter(Mandatory = $false)]
        [PSObject] $ParametersHash,
        [Parameter(Mandatory = $false)]
        [PSObject] $ParametersDepl
    )

    $placeholders = Get-ExpressionPlaceholders `
        -DefinitionJson $definitionJson `
        -DefinitionHash $definitionHash `
        -ParametersHash $parametersHash `
        -ParametersDepl $parametersDepl

    # Regular expression used to get all expression placeholders "{parameters.x}" (including double quote)
    # Used to fill parameters, even for complex types
    $results = $DefinitionJson | Select-String '"{parameters[a-zA-Z0-9_.\-\[\]]+}"' -AllMatches
    $parameters = @{}

    foreach ($match in $results.Matches) {
        $key = $match.Value

        if ($parameters.ContainsKey($key)) {
            continue
        }

        $trim = $key.Trim('"', '"')
        $value = ($placeholders[$trim] | ConvertTo-Json)
        $parameters.Add($key, $value)
    }

    # Update json file with parameters values
    foreach ($parameters in $parameters.GetEnumerator()) {
        $DefinitionJson = $DefinitionJson -replace [regex]::Escape($parameters.key), $parameters.value
    }

    # Regular expression used to get all expression placeholders {parameters.x} (without double quote)
    # Used for string concatenation
    $results = $DefinitionJson | Select-String '{parameters[a-zA-Z0-9_.\-\[\]]+}' -AllMatches
    $parameters = @{}

    foreach ($match in $results.Matches) {
        $key = $match.Value

        if ($parameters.ContainsKey($key)) {
            continue
        }

        $value = $placeholders[$key]
        $parameters.Add($key, $value)
    }

    # Update json file with parameters values
    foreach ($parameters in $parameters.GetEnumerator()) {
        $DefinitionJson = $DefinitionJson -replace [regex]::Escape($parameters.key), $parameters.value
    }

    return ($DefinitionJson | ConvertFrom-Json -AsHashtable)
}

function Get-ExpressionPlaceholders {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $DefinitionJson,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSObject] $DefinitionHash,
        [Parameter(Mandatory = $false)]
        [PSObject] $ParametersHash,
        [Parameter(Mandatory = $false)]
        [PSObject] $ParametersDepl
    )

    $targetParameters = $DefinitionHash.parameters
    
    # Parameters file is optional
    if ($ParametersHash) {
        $sourceParameters = $ParametersHash.parameters
    }
    
    # Regular expression used to get all expression placeholders {parameters.x}
    $results = $DefinitionJson | Select-String '{parameters[a-zA-Z0-9_.\-\[\]]+}' -AllMatches

    # Create an hashtable with expressions and associated values
    $placeholders = @{}
    foreach ($match in $results.Matches) {
        $key = $match.Value

        if ($placeholders.ContainsKey($key)) {
            continue
        }

        $trim = $key.Trim('{', '}')
        $split = $trim.Split('.')

        # Identify if our expression is an array {parameters.x[1]}
        $searchIndex = $split[1] | Select-String '\[[0-9]+\]'
        if ($null -ne $searchIndex.Matches) {
            $arrayIndex = $searchIndex.Matches[0].Value
            $propertyName = $split[1] -replace [regex]::Escape($arrayIndex), ''
        }
        else {
            $arrayIndex = $null
            $propertyName = $split[1]
        }

        # Build expression to get property value
        # Priority: 
        # 1. Parameter defined in parameters file
        # 2. Parameter defined in deployment inputs
        # 3. Default value defined in definition file
        if ($null -ne ${sourceParameters}?[$propertyName].value) { 
            $expression = '$sourceParameters.' + $propertyName + '.value' + $arrayIndex
        }
        elseif ($null -ne ${ParametersDepl}?[$propertyName].value) { 
            $expression = '$ParametersDepl.' + $propertyName + '.value' + $arrayIndex
        }
        elseif ($null -ne ${targetParameters}?[$propertyName].defaultValue) {   
            $expression = '$targetParameters.' + $propertyName + '.defaultValue' + $arrayIndex
        }
        else {
            Write-Host "Warning: Cannot evaluate placeholder expression $key. This parameter name seems invalid." -ForegroundColor Yellow
            continue
        }

        # Build expression if type is complex
        if ($split.Length -gt 2) {
            for (($i = 2); ($i -lt $split.Length); $i++) {
                $property = $split[$i]
                $expression += ".$property" 
            }
        }

        # Invoke expression
        $value = Invoke-Expression $expression
        $placeholders.Add($key, $value)

        if ($null -eq $value) {
            Write-Host "Warning: Cannot evaluate placeholder expression $key. Value is null." -ForegroundColor Yellow
        }
    }

    return $placeholders
}

function Get-Contexts {
    param (
        [Parameter(Mandatory = $true)]
        [PSObject] $DefinitionHash
    )

    $contexts = @{}
    Write-Host 'Getting all subscription contexts.' -ForegroundColor Magenta

    ForEach ($context in $DefinitionHash.contexts.GetEnumerator()) {
        $subscriptionId = $context.value.subscriptionId
        $contextName = $context.key

        Write-Host "$subscriptionId ($contextName)" 
        $subscriptionContext = Get-AzSubscription -SubscriptionId $subscriptionId | Set-AzContext
        $resourceGroupName = $context.value.resourceGroupName
        $contexts.Add($contextName, @{
                Name              = $contextName
                Context           = $subscriptionContext
                SubscriptionId    = $subscriptionId
                ResourceGroupName = $resourceGroupName
            })
    }

    return $contexts
}