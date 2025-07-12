﻿<#
.SYNOPSIS
    Development environment utility functions.
.DESCRIPTION
    Provides helper functions for setting up development environments, installing tools, and managing development configurations.
.NOTES
    Author: Piergiorgio Vagnozzi | License: MIT
#>

# Import core utilities
. "$PSScriptRoot\core-utils.ps1"

<#
.SYNOPSIS
    Shows a standardized help message for development scripts.
.PARAMETER scriptName
    Name of the script to show help for.
.PARAMETER usage
    Usage string for the script.
.PARAMETER description
    Description of what the script does.
.PARAMETER parameters
    Array of hashtables, each describing a parameter.
.PARAMETER examples
    Array of usage examples.
#>
function Show-DevScriptHelp {
    param(
        [Parameter(Mandatory = $true)]
        [string]$scriptName,
        [Parameter(Mandatory = $true)]
        [string]$usage,
        [Parameter(Mandatory = $true)]
        [string]$description,
        [hashtable[]]$parameters = @(),
        [string[]]$examples = @()
    )

    $helpText = @"
$($Global:Cyan)$scriptName$($Global:Reset)

$($Global:Info) USAGE:$($Global:Reset)
    $usage

$($Global:Info) DESCRIPTION:$($Global:Reset)
    $description

"@

    if ($parameters.Count -gt 0) {
        $helpText += "$($Global:Info) PARAMETERS:$($Global:Reset)`n"
        foreach ($param in $parameters) {
            $helpText += "    $($param.Name)    $($param.Description)`n"
        }
        $helpText += "`n"
    }

    if ($examples.Count -gt 0) {
        $helpText += "$($Global:Info) EXAMPLES:$($Global:Reset)`n"
        foreach ($example in $examples) {
            $helpText += "    $example`n"
        }
        $helpText += "`n"
    }

    Show-Help -helpText $helpText
}

