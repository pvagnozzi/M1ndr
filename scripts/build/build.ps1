<#
.SYNOPSIS
    Runs the main build process for the solution.
.DESCRIPTION
    This script acts as a wrapper for the C#-based build project (build/build.csproj).
    It uses a sophisticated build system managed by Nuke, invoked via `dotnet run`.
    All build logic (Clean, Restore, Build, Test, Pack) is defined in the C# project.
.PARAMETER args
    Arguments to pass to the underlying build project.
.EXAMPLE
    ./build.ps1 --target Clean,Restore,Build
.EXAMPLE
    ./build.ps1 --help
.NOTES
    Author: Piergiorgio Vagnozzi | License: MIT
#>

# Import core utilities
. "$PSScriptRoot\..\common\core-utils.ps1"

# Set working directory to the solution root to ensure build project is found
Set-WorkingDirectoryFromScript -relativePath "..\.." -scriptPath $MyInvocation.MyCommand.Path

# The build project is located in the 'build' directory
$buildProjectFolder = "build"

if (-not (Test-Path -Path $buildProjectFolder)) {
    Write-ErrorMessage "Build project folder not found at '$(Get-Location)\$buildProjectFolder'"
    exit 1
}

$ErrorActionPreference = "Stop";

Write-InfoMessage "$Global:Build Running build via C# project..."
Write-InfoMessage "Arguments: $args"

# Execute the C# build project, passing all arguments
dotnet run --project $buildProjectFolder -- $args

# Check the result and provide feedback
Assert-LastCommandSuccess "Build failed. See output for details."

Write-SuccessMessage "Build process completed successfully! 🎉"
