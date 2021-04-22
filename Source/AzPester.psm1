function Invoke-AzPester {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Parameters
    )

    $definitionWithParameters = $null
    $isValidSchemas = Assert-Schemas -Definition $Definition -Parameters $Parameters

    if ($isValidSchemas) {
        $isValidParameters = Assert-Parameters -Definition $Definition -Parameters $Parameters

        if ($isValidParameters) {
            $definitionWithParameters = Set-Parameters -Definition $Definition -Parameters $Parameters
            $contexts = Get-Contexts -Definition $definitionWithParameters

            # Switching on default subscription
            Set-AzContext -Context $contexts["default"].Context

            $container = New-PesterContainer -Path '*' -Data @{ Definition = $definitionWithParameters.definition; Contexts = $contexts }
            Invoke-Pester -Container $container -Output 'Detailed'
        }
    }
}

function Assert-Schemas {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Parameters
    )

    $parametersJson = Get-Content $Parameters -Raw
    $definitionJson = Get-Content $Definition -Raw

    $parametersSchema = "$PSScriptRoot/Schemas/2021-04/schema.definition.parameters.json"
    $definitionSchema = "$PSScriptRoot/Schemas/2021-04/schema.definition.json"

    $isValidParametersSchema = Test-Json -Json $parametersJson -SchemaFile $parametersSchema
    if (!$isValidParametersSchema) {
        Write-Host "Validation Failed: Please check parameters file, schema is invalid." -ForegroundColor Red
        return $false
    }

    $isValidDefinitionSchema = Test-Json -Json $definitionJson -SchemaFile $definitionSchema
    if (!$isValidDefinitionSchema) {
        Write-Host "Validation Failed: Please check definition file, schema is invalid." -ForegroundColor Red
        return $false
    }

    return $true
}

function Assert-Parameters {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Parameters
    )

    $parametersJson = Get-Content $Parameters -Raw
    $definitionJson = Get-Content $Definition -Raw

    $sourceParameters = ($parametersJson | ConvertFrom-Json -AsHashtable).parameters
    $targetParameters = ($definitionJson | ConvertFrom-Json -AsHashtable).parameters
    
    foreach ($parameter in $targetParameters.GetEnumerator()) {
        if (!$sourceParameters.ContainsKey($parameter.key) -and (!$parameter.value.defaultValue)) {
            Write-Host "Validation Failed: Input parameter $($parameter.key) value is missing." -ForegroundColor Red
            return $false
        }
    }

    return $true
}

function Set-Parameters {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Parameters
    )

    $parametersJson = Get-Content $Parameters -Raw
    $definitionJson = Get-Content $Definition -Raw

    $sourceParameters = ($parametersJson | ConvertFrom-Json -AsHashtable).parameters
    $targetParameters = ($definitionJson | ConvertFrom-Json -AsHashtable).parameters

    # Regular expression used to get all expression placeholders
    $results = $definitionJson | Select-String '\{parameters.[a-zA-Z0-9_.-]+}' -AllMatches

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
        $expression = $null

        # Get the parameter value or default value
        if ($sourceParameters[$name].value) {
            $expression = '$sourceParameters.' + $split[1] + '.value'
        }
        elseif ($targetParameters[$name].defaultValue) {
            $expression = '$targetParameters.' + $split[1] + '.defaultValue'
        }
        else {
            Write-Host "Warning: Cannot evaluate placeholder expression $key." -ForegroundColor Yellow
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
        $definitionJson = $definitionJson -replace $placeHolder.key, $placeHolder.value
    }

    return ($definitionJson | ConvertFrom-Json -AsHashtable)
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
        Write-Host $subscriptionId
        $subscriptionContext = Get-AzSubscription -SubscriptionId $subscriptionId | Set-AzContext
        $contextName = $context.key
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