﻿<#
.SYNOPSIS
    Test utility functions for .NET projects with Playwright and certificate support.
.DESCRIPTION
    Provides helper functions for running tests, installing Playwright dependencies, and managing certificates for test automation.
.NOTES
    Author: Piergiorgio Vagnozzi | License: MIT
#>

# Import common utilities
. "$PSScriptRoot\core-utils.ps1"
. "$PSScriptRoot\build-utils.ps1"

<#
.SYNOPSIS
    Installs Playwright dependencies for a test project.
.PARAMETER projectPath
    Path to the test project folder.
.PARAMETER projectName
    Name of the test project.
#>
function Install-PlaywrightDependencies {
    param(
        [Parameter(Mandatory = $true)]
        [string]$projectPath,
        [Parameter(Mandatory = $true)]
        [string]$projectName
    )

    Write-InfoMessage "$Global:Install Installing Playwright dependencies for $projectName"

    $playwrightScript = Join-Path $projectPath "bin\Debug\net9.0\playwright.ps1"

    if (-not (Test-Path $playwrightScript)) {
        Write-ErrorMessage "Playwright script not found at $playwrightScript. Make sure the project is built first."
        exit 1
    }

    pwsh $playwrightScript install --with-deps --only-shell
    Assert-LastCommandSuccess "Error installing Playwright dependencies for $projectName"

    Write-SuccessMessage "Playwright dependencies installed successfully for $projectName"
}

<#
.SYNOPSIS
    Installs and trusts HTTPS development certificates for Linux environments.
#>
function Install-AndTrustCertificate {
    Write-InfoMessage "$Global:Cert Installing and trusting development certificate"

    # Documentation: https://github.com/dotnet/AspNetCore.Docs/issues/22019

    # Clean any existing certificates
    sudo dotnet dev-certs https --clean

    # Create certificate directory
    sudo mkdir -p /usr/local/share/ca-certificates/aspnet

    # Export certificate in PEM format
    sudo dotnet dev-certs https -ep /usr/local/share/ca-certificates/aspnet/https.crt --format PEM
    Assert-LastCommandSuccess "Failed to export development certificate"

    # Trust certificate for Ubuntu system-wide
    sudo update-ca-certificates
    Assert-LastCommandSuccess "Failed to update CA certificates"

    # Install NSS tools for browser certificate management
    if (-not (Get-Command certutil -ErrorAction SilentlyContinue)) {
        Write-InfoMessage "Installing NSS tools (libnss3-tools)..."
        sudo apt-get update && sudo apt-get install -y libnss3-tools
        Assert-LastCommandSuccess "Failed to install libnss3-tools."
    }

    # Trust certificate for Edge/Chrome (requires libnss3-tools)
    mkdir -p "$env:HOME/.pki/nssdb"
    sudo certutil -d "sql:$env:HOME/.pki/nssdb" -A -t "P,," -n localhost -i /usr/local/share/ca-certificates/aspnet/https.crt
    sudo certutil -d "sql:$env:HOME/.pki/nssdb" -A -t "C,," -n localhost -i /usr/local/share/ca-certificates/aspnet/https.crt
    Write-SuccessMessage "Certificate trusted for Chrome/Edge"

    # Verify certificate installation
    sudo dotnet dev-certs https --check --trust

    Write-SuccessMessage "Development certificate installed and trusted successfully"
}

<#
.SYNOPSIS
    Runs tests for a .NET project with optional Playwright support.
.PARAMETER projectPath
    Path to the test project folder.
.PARAMETER projectName
    Name of the test project.
.PARAMETER requiresPlaywright
    Whether the project requires Playwright dependencies. Default is false.
.PARAMETER configuration
    Build configuration. Default is Debug.
.PARAMETER noBuild
    Skip building the project before running tests. Default is false.
#>
function Invoke-DotNetTest {
    param(
        [Parameter(Mandatory = $true)]
        [string]$projectPath,
        [Parameter(Mandatory = $true)]
        [string]$projectName,
        [bool]$requiresPlaywright = $false,
        [string]$configuration = "Debug",
        [bool]$noBuild = $false
    )

    Write-InfoMessage "$Global:Test Running tests for $projectName"

    $projectFile = Join-Path $projectPath "$projectName.csproj"

    # Build project if required
    if (-not $noBuild) {
        Invoke-DotNetBuild -projectPath $projectFile -configuration $configuration
    }

    # Install Playwright dependencies if required
    if ($requiresPlaywright) {
        if ($isLinux) {
            Install-AndTrustCertificate
        } else {
            Write-WarningMessage "Certificate installation is only supported on Linux. Windows/macOS require manual setup."
        }
        Install-PlaywrightDependencies -projectPath $projectPath -projectName $projectName
    }

    # Ensure test results directory exists
    $testResultsDir = "tests\testsresults"
    if (-not (Test-Path $testResultsDir)) {
        New-Item -ItemType Directory -Path $testResultsDir -Force | Out-Null
    }

    # Run tests
    $buildFlag = if ($noBuild) { "--no-build" } else { "" }
    dotnet test $projectFile --nologo --logger "trx;LogFileName=${projectName}.trx" --results-directory $testResultsDir $buildFlag

    $testResult = $LASTEXITCODE
    if ($testResult -ne 0) {
        Write-ErrorMessage "Tests failed for $projectName (Exit code: $testResult)"
        return $testResult
    }

    Write-SuccessMessage "Tests passed for $projectName"
    return 0
}

