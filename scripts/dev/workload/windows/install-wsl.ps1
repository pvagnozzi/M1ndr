<#
.SYNOPSIS
	Installs Windows Subsystem for Linux (needs admin rights)
.DESCRIPTION
	This PowerShell script installs Windows Subsystem for Linux. It needs admin rights.
.EXAMPLE
	PS> ./install-wsl.ps1
.NOTES
	Author: Piergiorgio Vagnozzi | License: MIT
#>

#Requires -RunAsAdministrator

# Import common utilities
. "$PSScriptRoot\..\..\..\common\core-utils.ps1"
. "$PSScriptRoot\..\..\..\common\dev-utils.ps1"

# Check for --help argument
if ($PSBoundParameters.ContainsKey('Help')) {
    Show-DevScriptHelp -scriptName "install-wsl.ps1" `
        -usage "./install-wsl.ps1" `
        -description "Installs Windows Subsystem for Linux (WSL) with proper feature enablement." `
        -examples @(
            "./install-wsl.ps1"
        )
    exit 0
}

Write-InfoMessage "$Global:Install Starting WSL installation..."

# Check if WSL is already installed
if (Get-Command wsl.exe -ErrorAction SilentlyContinue) {
    Write-SuccessMessage "Windows Subsystem for Linux (WSL) is already installed."
    exit 0
}

Write-InfoMessage "Step 1/3: Enabling WSL feature..."
& dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
Assert-LastCommandSuccess "Failed to enable WSL feature."

Write-InfoMessage "Step 2/3: Enabling Virtual Machine Platform..."
& dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
Assert-LastCommandSuccess "Failed to enable Virtual Machine Platform."

Write-InfoMessage "Step 3/3: Setting WSL default version to 2..."
# This might fail if the kernel needs an update, but we can proceed.
& wsl --set-default-version 2

Write-SuccessMessage "WSL enabled successfully!"
Write-YellowMessage "A reboot is required to complete the installation." $Global:Warn
Write-InfoMessage "After rebooting, install a Linux distribution from the Microsoft Store (e.g., Ubuntu)."
