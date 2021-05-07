function Get-Context {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [PSObject] $Definition,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Context
    )

    $defContexts = $Definition.contexts
    $curContext = ${defContexts}?[$Context]

    if ($null -ne $curContext) {
        return $curContext
    }
    else {
        throw "Context $Context is unknown. This context should be referenced in contexts section."
    }
}