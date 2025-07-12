<#
.SYNOPSIS
	Creates a new Entity Framework Core migration.

.DESCRIPTION
	This PowerShell script creates a new migration for a specified DbContext and project using Entity Framework Core.

.PARAMETER Project
    The path to the project containing the DbContext.

.PARAMETER Database
    The name of the DbContext to use.

.PARAMETER MigrationName
    The name to assign to the new migration.

.PARAMETER OutputFolder
    (Optional) The output folder for the migration files. Default: Common\Data\Persistence\Migrations.

.PARAMETER Configuration
    (Optional) The build configuration to use. Default: Debug.

.EXAMPLE
	PS> .\add-migration.ps1 -Project src\Application.csproj -Database ApplicationDbContext -MigrationName AddUserTable

.NOTES
	Author: Piergiorgio Vagnozzi | License: MIT
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Project,

    [Parameter(Mandatory = $true)]
    [string]$Database,

    [Parameter(Mandatory = $true)]
    [string]$MigrationName,

    [string]$OutputFolder = "Common\Data\Persistence\Migrations",
    [string]$Configuration = "Debug"
)

# Import common utilities
. "$PSScriptRoot\..\..\common\core-utils.ps1"
. "$PSScriptRoot\..\..\common\build-utils.ps1"
. "$PSScriptRoot\..\..\common\dev-utils.ps1"

# Set working directory to solution root
Set-WorkingDirectoryFromScript -relativePath "..\..\.." -scriptPath $MyInvocation.MyCommand.Path

# Check for --help argument
if ($PSBoundParameters.ContainsKey('Help')) {
    Show-DevScriptHelp -scriptName "add-migration.ps1" `
        -usage "./add-migration.ps1 -Project <path> -Database <context> -MigrationName <name> [-OutputFolder <folder>]" `
        -description "Creates a new Entity Framework Core migration." `
        -parameters @(
            @{ Name = "-Project"; Description = "The path to the project containing the DbContext." },
            @{ Name = "-Database"; Description = "The name of the DbContext to use." },
            @{ Name = "-MigrationName"; Description = "The name to assign to the new migration." },
            @{ Name = "-OutputFolder"; Description = "(Optional) The output folder for the migration files. Default: Common\Data\Persistence\Migrations." },
            @{ Name = "-Configuration"; Description = "(Optional) The build configuration to use. Default: Debug." }
        ) `
        -examples @(
            "./add-migration.ps1 -Project src\Application.csproj -Database ApplicationDbContext -MigrationName AddUserTable"
        )
    exit 0
}

Write-InfoMessage "🔄 Starting Entity Framework Core migration creation..."

# Validate project exists
if (-not (Test-Path -Path $Project)) {
    Write-ErrorMessage "Project file not found at '$Project'"
    exit 1
}

# Build the project before creating the migration
Invoke-DotNetBuild -projectPath $Project -configuration $Configuration

# Run the migration command
Write-InfoMessage "Creating migration '$MigrationName' for context '$Database'..."
dotnet ef migrations add $MigrationName --project $Project --context $Database --output-dir $OutputFolder --configuration $Configuration

Assert-LastCommandSuccess "Failed to create migration '$MigrationName'."

Write-SuccessMessage "Migration '$MigrationName' created successfully! 🎉"
