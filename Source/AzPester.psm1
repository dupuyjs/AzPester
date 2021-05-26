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

    if ($Definition -NotMatch '\.yaml$' -and $Definition -NotMatch '\.yml$' -and $Definition -NotMatch '\.json$') {
        Write-Error 'The file type is not supported'
        Exit
    }

    [String] $definitionJson = $null

    if ($Definition -match '\.yaml$' -or $Definition -match '\.yml$') {
        $rawYaml = Get-Content $Definition -Raw
        # Convert YAML to PowerShell Object
        $psYaml = (ConvertFrom-Yaml -Yaml $rawYaml)
        # Convert the Object to JSON
        $definitionJson = @($psYaml | ConvertTo-Json -Depth 9)
    }
    else {
        $definitionJson = Get-Content $Definition -Raw
    }

    # Parameters file is optional
    if ($Parameters) {
        [String] $parametersJson = $null

        if ($Parameters -match '\.yaml$' -or $Parameters -match '\.yml$') {
            $rawYaml = Get-Content $Parameters -Raw
            # Convert YAML to PowerShell Object
            $psYaml = (ConvertFrom-Yaml -Yaml $rawYaml)
            # Convert the Object to JSON
            $parametersJson = @($psYaml | ConvertTo-Json)
        }
        else {
            $parametersJson = Get-Content $Parameters -Raw
        }
    }

    $isValidSchemas = Assert-Schemas -DefinitionJson $definitionJson -ParametersJson $parametersJson

    if ($isValidSchemas) {
        $isValidParameters = Assert-Parameters -DefinitionJson $definitionJson -ParametersJson $parametersJson

        if ($isValidParameters) {
            $definitionWithParameters = Set-Parameters -DefinitionJson $definitionJson -ParametersJson $parametersJson
            # Getting contexts and assigning them to the definition
            $contexts = Get-Contexts -Definition $definitionWithParameters
            $definitionWithParameters.definition.contexts = $contexts

            # Switching on default subscription
            Set-AzContext -Context $contexts["default"].Context

            $container = New-PesterContainer -Path '*' -Data @{ Definition = $definitionWithParameters.definition }
            
            Invoke-Pester -Container $container -TagFilter $Tags -ExcludeTagFilter $ExcludeTags -Output 'Detailed'
        }
    }
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
        [String] $DefinitionJson,
        [Parameter(Mandatory = $false)]
        [String] $ParametersJson
    )

    $targetParameters = ($DefinitionJson | ConvertFrom-Json -AsHashtable).parameters

    # Parameters file is optional
    if ($ParametersJson) {
        $sourceParameters = ($ParametersJson | ConvertFrom-Json -AsHashtable).parameters

        if ($targetParameters) {
            foreach ($parameter in $targetParameters.GetEnumerator()) {
                if (!$sourceParameters.ContainsKey($parameter.key) -and (!$parameter.value.defaultValue)) {
                    Write-Host "Validation Failed: Input parameter $($parameter.key) value is missing." -ForegroundColor Red
                    return $false
                }
            }
        }
    }
    else {
        if ($targetParameters) {
            foreach ($parameter in $targetParameters.GetEnumerator()) {
                if (!$parameter.value.defaultValue) {
                    Write-Host "Validation Failed: Input parameter $($parameter.key) value is missing." -ForegroundColor Red
                    return $false
                }
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
        [Parameter(Mandatory = $false)]
        [String] $ParametersJson
    )

    $targetParameters = ($DefinitionJson | ConvertFrom-Json -AsHashtable).parameters
    
    # Parameters file is optional
    if ($ParametersJson) {
        $sourceParameters = ($ParametersJson | ConvertFrom-Json -AsHashtable).parameters
    }
    
    # Regular expression used to get all expression placeholders
    $results = $DefinitionJson | Select-String '\{parameters.[a-zA-Z0-9_.-]+}' -AllMatches

    # Create an hashtable with placeholders and associated values
    $placeHolders = @{}
    foreach ($match in $results.Matches) {
        $key = $match.Value

        if ($placeHolders.ContainsKey($key)) {
            continue
        }

        $trim = $key.Trim('{', '}')
        $split = $trim.Split('.')
        $name = $split[1]

        # Get the parameter value or default value
        if (${targetParameters}?[$name].defaultValue) {
            $expression = '$targetParameters.' + $split[1] + '.defaultValue'
        }
        elseif (${sourceParameters}?[$name].value) {   
            $expression = '$sourceParameters.' + $split[1] + '.value'
        }
        else {
            Write-Host "Warning: Cannot evaluate placeholder expression $key. This parameter name seems invalid." -ForegroundColor Yellow
            continue
        }

        # Build the expression if type is complex
        if ($split.Length -gt 2) {
            for (($i = 2); ($i -lt $split.Length); $i++) {
                $property = $split[$i]
                $expression += ".$property" 
            }
        }

        # Invoke expression
        $value = Invoke-Expression $expression
        $placeHolders.Add($key, $value)

        if (!$value) {
            Write-Host "Warning: Cannot evaluate placeholder expression $key. Value is null." -ForegroundColor Yellow
        }
    }

    # Update json file with placeholder values
    foreach ($placeHolder in $placeHolders.GetEnumerator()) {
        $DefinitionJson = $DefinitionJson -replace $placeHolder.key, $placeHolder.value
    }

    return ($DefinitionJson | ConvertFrom-Json -AsHashtable)
}

function Get-Contexts {
    param (
        [Parameter(Mandatory = $true)]
        [PSObject] $Definition
    )

    $contexts = @{}
    Write-Host 'Getting all subscription contexts.' -ForegroundColor Magenta

    ForEach ($context in $Definition.contexts.GetEnumerator()) {
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