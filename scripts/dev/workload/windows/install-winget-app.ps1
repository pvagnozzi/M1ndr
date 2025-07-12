<#
.SYNOPSIS
	Installs an app via winget

.DESCRIPTION
	This PowerShell script installs an app from winget.

.PARAMETER ApplicationId
    The ID of the application to install.

.PARAMETER ApplicationSource
    The source from which to install the application. Default is "winget".

.PARAMETER Upgrade
    Switch to upgrade the application if it is already installed.

.EXAMPLE
	PS> ./install-winget-app.ps1 Docker.DockerDesktop --Source winget --Upgrade

.NOTES
	Author: Piergiorgio Vagnozzi| License: MIT
#>

#Requires -RunAsAdministrator

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$ApplicationId,

    [switch]$Upgrade
)

# Import common utilities
. "$PSScriptRoot\..\..\..\common\core-utils.ps1"
. "$PSScriptRoot\..\..\..\common\dev-utils.ps1"

# Check for --help argument
if ($PSBoundParameters.ContainsKey('Help')) {
    Show-DevScriptHelp -scriptName "install-winget-app.ps1" `
        -usage "./install-winget-app.ps1 <ApplicationId> [--Upgrade]" `
        -description "Installs or upgrades an application using winget." `
        -parameters @(
            @{ Name = "ApplicationId"; Description = "The ID of the application to install (required)." },
            @{ Name = "--Upgrade"; Description = "Switch to upgrade the application if it is already installed." }
        ) `
        -examples @(
            "./install-winget-app.ps1 Docker.DockerDesktop",
            "./install-winget-app.ps1 Microsoft.VisualStudioCode --Upgrade"
        )
    exit 0
}

$action = if ($Upgrade.IsPresent) { "upgrading" } else { "installing" }
$command = if ($Upgrade.IsPresent) { "upgrade" } else { "install" }

Write-InfoMessage "$Global:Install $action application: $ApplicationId"

winget $command --id $ApplicationId --silent --accept-package-agreements --accept-source-agreements

Assert-LastCommandSuccess "Failed to $action $ApplicationId."

Write-SuccessMessage "$ApplicationId $action completed successfully!"
