<#
.SYNOPSIS
    Generates and trusts a development HTTPS certificate for ASP.NET apps.

.DESCRIPTION
    This script creates a .pfx certificate file for ASP.NET development and trusts it on the local machine.

.PARAMETER FilePath
    The path where the .pfx certificate will be saved. Default: '../../../aspnetapp.pfx'

.EXAMPLE
    ./generate-certs.ps1
    Generates and trusts the certificate with the default password and path.

.NOTES
	Author: Piergiorgio Vagnozzi | License: MIT
#>

param(
    [string]$FilePath = (Join-Path $PSScriptRoot "..\..\..\aspnetapp.pfx"),
    [string]$Password = "identity-develop",
    [switch]$Force
)

# Import common utilities
. "$PSScriptRoot\..\..\..\common\core-utils.ps1"
. "$PSScriptRoot\..\..\..\common\dev-utils.ps1"

# Check for --help argument
if ($PSBoundParameters.ContainsKey('Help')) {
    Show-DevScriptHelp -scriptName "generate-certs.ps1" `
        -usage "./generate-certs.ps1 [-FilePath <path>] [-Password <password>] [-Force]" `
        -description "Generates and trusts a development HTTPS certificate for ASP.NET applications." `
        -parameters @(
            @{ Name = "-FilePath"; Description = "Path to save the .pfx file. Default: ../../../aspnetapp.pfx" },
            @{ Name = "-Password"; Description = "Password for the certificate. Default: identity-develop" },
            @{ Name = "-Force"; Description = "Force regeneration of the certificate if it already exists." }
        ) `
        -examples @(
            "./generate-certs.ps1",
            "./generate-certs.ps1 -FilePath './mycert.pfx' -Password 'secret'"
        )
    exit 0
}

Write-InfoMessage "$Global:Cert Starting development certificate generation..."

# Resolve the full path
$fullPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($FilePath)
$directory = Split-Path -Parent $fullPath

# Create directory if it doesn't exist
if (-not (Test-Path $directory)) {
    Write-InfoMessage "Creating directory: $directory"
    New-Item -ItemType Directory -Path $directory -Force | Out-Null
}

# Check if certificate already exists
if ((Test-Path $fullPath) -and -not $Force.IsPresent) {
    Write-WarningMessage "Certificate already exists at: $fullPath. Use -Force to regenerate."
    exit 0
}

Write-InfoMessage "Generating certificate at: $fullPath"

# Generate and trust the certificate
dotnet dev-certs https -ep $fullPath -p $Password --trust

Assert-LastCommandSuccess "Failed to generate or trust the certificate."

Write-SuccessMessage "Certificate generated and trusted successfully! 🎉"
