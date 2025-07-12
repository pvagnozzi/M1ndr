﻿<#
.SYNOPSIS
    Core utility functions for PowerShell scripts.
.DESCRIPTION
    Provides essential helper functions for colored output, error handling, and common operations across all PowerShell scripts.
.NOTES
    Author: Piergiorgio Vagnozzi | License: MIT
#>

# Colors & Emoji Constants
$Global:Green = "`e[32m"
$Global:Blue = "`e[34m"
$Global:Red = "`e[31m"
$Global:Cyan = "`e[36m"
$Global:Yellow = "`e[33m"
$Global:Magenta = "`e[35m"
$Global:Reset = "`e[0m"
$Global:Check = "✅"
$Global:Warn = "⚠️"
$Global:Info = "ℹ️"
$Global:Error = "❌"
$Global:Build = "🔨"
$Global:Test = "🧪"
$Global:Install = "📦"
$Global:Cert = "🔏"
$Global:Clean = "🧹"

<#
.SYNOPSIS
    Displays a red error message with an error emoji.
.PARAMETER message
    The message to display in red with an error emoji.
#>
function Write-ErrorMessage {
    param([string]$message)
    Write-Host "$Global:Red$Global:Error $message$Global:Reset"
}

<#
.SYNOPSIS
    Displays a red warning message with a warning emoji.
.PARAMETER message
    The message to display in red with a warning emoji.
#>
function Write-WarningMessage {
    param([string]$message)
    Write-Host "$Global:Red$Global:Warn $message$Global:Reset"
}

<#
.SYNOPSIS
    Displays a blue informational message with an info emoji.
.PARAMETER message
    The message to display in blue with an info emoji.
#>
function Write-InfoMessage {
    param([string]$message)
    Write-Host "$Global:Blue$Global:Info $message$Global:Reset"
}

<#
.SYNOPSIS
    Displays a green success message with a check emoji.
.PARAMETER message
    The message to display in green with a check emoji.
#>
function Write-SuccessMessage {
    param([string]$message)
    Write-Host "$Global:Green$Global:Check $message$Global:Reset"
}

<#
.SYNOPSIS
    Displays a cyan informational message with a custom emoji.
.PARAMETER message
    The message to display in cyan.
.PARAMETER emoji
    Optional emoji to display before the message.
#>
function Write-CyanMessage {
    param(
        [string]$message,
        [string]$emoji = $Global:Info
    )
    Write-Host "$Global:Cyan$emoji $message$Global:Reset"
}

<#
.SYNOPSIS
    Displays a yellow warning message with a custom emoji.
.PARAMETER message
    The message to display in yellow.
.PARAMETER emoji
    Optional emoji to display before the message.
#>
function Write-YellowMessage {
    param(
        [string]$message,
        [string]$emoji = $Global:Warn
    )
    Write-Host "$Global:Yellow$emoji $message$Global:Reset"
}

<#
.SYNOPSIS
    Checks if the last command executed successfully and exits with an error if not.
.PARAMETER errorMessage
    Custom error message to display if the command failed.
.PARAMETER exitCode
    Optional exit code to use instead of the last exit code.
#>
function Assert-LastCommandSuccess {
    param(
        [string]$errorMessage = "Command failed",
        [int]$exitCode = $LASTEXITCODE
    )
    if ($exitCode -ne 0) {
        Write-ErrorMessage $errorMessage
        exit $exitCode
    }
}

<#
.SYNOPSIS
    Gets the script directory path.
.PARAMETER scriptPath
    The script path from $MyInvocation.MyCommand.Path.
#>
function Get-ScriptDirectory {
    param([string]$scriptPath = $MyInvocation.MyCommand.Path)
    return Split-Path -Parent $scriptPath
}

<#
.SYNOPSIS
    Sets the working directory relative to the script location.
.PARAMETER relativePath
    The relative path from the script directory.
.PARAMETER scriptPath
    The script path from $MyInvocation.MyCommand.Path.
#>
function Set-WorkingDirectoryFromScript {
    param(
        [string]$relativePath = "..\..\..",
        [string]$scriptPath = $MyInvocation.MyCommand.Path
    )
    $scriptDir = Get-ScriptDirectory -scriptPath $scriptPath
    $targetPath = Join-Path $scriptDir $relativePath
    Set-Location -Path (Resolve-Path $targetPath)
    Write-InfoMessage "Working directory set to: $(Get-Location)"
}

<#
.SYNOPSIS
    Displays a help message and exits.
.PARAMETER helpText
    The help text to display.
#>
function Show-Help {
    param([string]$helpText)
    Write-Host $helpText
    exit 0
}

