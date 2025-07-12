<#
.SYNOPSIS
    Runs a single test project and prints the result with color and emoji.
.DESCRIPTION
    This script runs a single test project, optionally installing Playwright dependencies, and prints the result with colored output and emoji.
.PARAMETER pathFolder
    The folder path of the test project.
.PARAMETER project
    The name of the test project.
.PARAMETER requiresPlaywright
    If 1, installs Playwright dependencies before running the test.
.EXAMPLE
    ./run-single-test.ps1 -pathFolder "tests\myproj" -project "MyProj.Tests" -requiresPlaywright 0
#>

# Colors & Emoji
$Green = "`e[32m"
$Red = "`e[31m"
$Cyan = "`e[36m"
$Reset = "`e[0m"
$Check = "✅"
$Cross = "❌"
$Test = "🧪"

param(
    [string]$pathFolder,
    [string]$project,
    [int]$requiresPlaywright = 0
)

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$scriptPath\utils.ps1"
Set-Location "$scriptPath\..\.."

Write-Host "${Cyan}${Test} Running test for project: $project...${Reset}"

runtest -pathFolder $pathFolder -project $project -requiresPlaywright $requiresPlaywright

if ($LASTEXITCODE -eq 0) {
    Write-Host "${Green}${Check} Test finished successfully for project: $project${Reset}"
} else {
    Write-Host "${Red}${Cross} Test failed for project: $project${Reset}"
}

exit $LASTEXITCODE
