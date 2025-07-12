<#
.SYNOPSIS
	Sets up the developer environment.

.DESCRIPTION
	This PowerShell script installs all components for a complete developer environment on Windows, including editors, CLI tools, and container engines.

.PARAMETER Rider
    If specified, installs JetBrains Rider. Otherwise, installs Visual Studio Community 2022.

.PARAMETER Podman
    If specified, installs Podman and Podman Desktop. Otherwise, installs Docker Desktop.

.EXAMPLE
	PS> ./install-devenv.ps1 --Rider --Podman

.EXAMPLE
    PS> ./install-devenv.ps1

.NOTES
	Author: Piergiorgio Vagnozzi | License: MIT
#>

#Requires -RunAsAdministrator

param(
    [switch]$Rider,
    [switch]$Podman
)

# Import common utilities
. "$PSScriptRoot\..\..\..\common\core-utils.ps1"
. "$PSScriptRoot\..\..\..\common\dev-utils.ps1"

# Check for --help argument
if ($PSBoundParameters.ContainsKey('Help')) {
    Show-DevScriptHelp -scriptName "install-devenv.ps1" `
        -usage "./install-devenv.ps1 [-Rider] [-Podman]" `
        -description "Installs all components for a complete developer environment on Windows." `
        -parameters @(
            @{ Name = "-Rider"; Description = "Installs JetBrains Rider instead of Visual Studio Community 2022." },
            @{ Name = "-Podman"; Description = "Installs Podman and Podman Desktop instead of Docker Desktop." }
        ) `
        -examples @(
            "./install-devenv.ps1 --Rider --Podman",
            "./install-devenv.ps1"
        )
    exit 0
}

Write-InfoMessage "$Global:Install Starting developer environment setup..."

# Run prerequisite scripts
Write-InfoMessage "Installing WSL..."
& "$PSScriptRoot\install-wsl.ps1"
Assert-LastCommandSuccess "WSL installation failed."

# Define packages to be installed with winget
$wingetPackages = @(
    "Microsoft.WindowsTerminal",
    "Git.Git",
    "GitExtensionsTeam.GitExtensions",
    "Microsoft.VisualStudioCode",
    "Microsoft.AzureCLI",
    "Microsoft.PowerShell",
    "Microsoft.Azure.FunctionsCoreTools",
    "Microsoft.DotNet.SDK.9"
)

if ($Rider.IsPresent) {
    $wingetPackages += "JetBrains.Rider"
} else {
    $wingetPackages += "Microsoft.VisualStudio.2022.Community"
}

if ($Podman.IsPresent) {
    $wingetPackages += "RedHat.Podman", "RedHat.Podman-Desktop"
} else {
    $wingetPackages += "Docker.DockerDesktop"
}

# Install all winget packages
foreach ($package in $wingetPackages) {
    Write-InfoMessage "Installing $package via winget..."
    & "$PSScriptRoot\install-winget-app.ps1" -ApplicationId $package
    Assert-LastCommandSuccess "Failed to install $package."
}

# Install VS Code extensions
if (Get-Command code -ErrorAction SilentlyContinue) {
    Write-InfoMessage "Installing VS Code extensions..."
    $vsCodeExtensions = @(
        "ms-dotnettools.csharp", "ms-dotnettools.csdevkit", "ms-dotnettools.vscode-dotnet-pack",
        "ms-azuretools.vscode-azurefunctions", "ms-azuretools.vscode-azurecli", "ms-vscode.azure-account",
        "ms-vscode.powershell", "ms-vscode-remote.remote-wsl", "ms-vscode.remote-containers",
        "ms-vscode.docker", "eamodio.gitlens", "github.vscode-pull-request-github",
        "ms-vsliveshare.vsliveshare", "ms-vscode.test-adapter-converter", "jmrog.vscode-nuget-package-manager",
        "ms-python.python", "ms-toolsai.jupyter"
    )

    foreach ($extension in $vsCodeExtensions) {
        Write-InfoMessage "Installing extension: $extension"
        code --install-extension $extension --force
    }
} else {
    Write-WarningMessage "Visual Studio Code command 'code' not found. Skipping extension installation."
}

Write-SuccessMessage "Developer environment setup completed successfully! 🎉"
