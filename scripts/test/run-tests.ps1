<#
.SYNOPSIS
    Runs all configured test projects and prints results with color and emoji.
.DESCRIPTION
    This script runs all test projects defined in the configuration array, printing colored output and emoji for each result.
.EXAMPLE
    ./run-tests.ps1
.NOTES
    Author: Piergiorgio Vagnozzi | License: MIT
#>

# Import test utilities from common modules
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$scriptPath\..\common\test-utils.ps1"

# Set working directory to solution root
Set-WorkingDirectoryFromScript -relativePath "..\..\.." -scriptPath $MyInvocation.MyCommand.Path

Write-CyanMessage "Starting all tests..." $Global:Test

# Array of test projects with their configurations
$testProjects = @(
    # @{
    #     pathFolder = "tests\identity\Identity.Mail\Identity.Mail.Infrastructure.UnitTest"
    #     nameProj = "Identity.Mail.Infrastructure.UnitTest"
    #     requiresPlaywright = $false
    # },
    # @{
    #     pathFolder = "tests\identity\Identity.Mail\Identity.Mail.Infrastructure.IntegrationTest"
    #     nameProj = "Identity.Mail.Infrastructure.IntegrationTest"
    #     requiresPlaywright = $false
    # },
    # @{
    #     pathFolder = "tests\identity\Identity.Mail\Identity.Mail.Sender.UnitTest"
    #     nameProj = "Identity.Mail.Sender.UnitTest"
    #     requiresPlaywright = $false
    # },
    @{
        pathFolder = "tests\e2e\Daikin.Identity.E2e.Tests"
        nameProj = "Daikin.Identity.E2e.Tests"
        requiresPlaywright = $true
    }
)

# Auto-discover test projects if the array is empty
if ($testProjects.Count -eq 0) {
    Write-InfoMessage "No test projects configured. Auto-discovering test projects..."
    $testProjects = Get-TestProjects -rootPath "tests"

    if ($testProjects.Count -eq 0) {
        Write-WarningMessage "No test projects found in the solution"
        exit 0
    }

    Write-InfoMessage "Found $($testProjects.Count) test project(s)"
}

# Run all tests using the new modular approach
Invoke-AllTests -testProjects $testProjects
