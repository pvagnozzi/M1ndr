﻿<#
.SYNOPSIS
    Build and clean utility functions for .NET projects.
.DESCRIPTION
    Provides helper functions for building, cleaning, and managing .NET projects and solutions.
.NOTES
    Author: Piergiorgio Vagnozzi | License: MIT
#>

# Import core utilities
. "$PSScriptRoot\core-utils.ps1"

<#
.SYNOPSIS
    Builds a .NET project or solution.
.PARAMETER projectPath
    Path to the project file (.csproj) or solution file (.sln).
.PARAMETER configuration
    Build configuration (Debug, Release). Default is Release.
.PARAMETER verbosity
    MSBuild verbosity level. Default is minimal.
#>
function Invoke-DotNetBuild {
    param(
        [Parameter(Mandatory = $true)]
        [string]$projectPath,
        [string]$configuration = "Release",
        [string]$verbosity = "minimal"
    )

    Write-InfoMessage "$Global:Build Building $projectPath ($configuration)"

    dotnet build $projectPath --configuration $configuration --verbosity $verbosity --nologo
    Assert-LastCommandSuccess "Failed to build $projectPath"

    Write-SuccessMessage "Build completed successfully for $projectPath"
}

<#
.SYNOPSIS
    Cleans a .NET project or solution.
.PARAMETER projectPath
    Path to the project file (.csproj) or solution file (.sln).
.PARAMETER configuration
    Build configuration (Debug, Release). Default is Release.
#>
function Invoke-DotNetClean {
    param(
        [Parameter(Mandatory = $true)]
        [string]$projectPath,
        [string]$configuration = "Release"
    )

    Write-InfoMessage "$Global:Clean Cleaning $projectPath ($configuration)"

    dotnet clean $projectPath --configuration $configuration --nologo
    Assert-LastCommandSuccess "Failed to clean $projectPath"

    Write-SuccessMessage "Clean completed successfully for $projectPath"
}

<#
.SYNOPSIS
    Restores NuGet packages for a .NET project or solution.
.PARAMETER projectPath
    Path to the project file (.csproj) or solution file (.sln).
#>
function Invoke-DotNetRestore {
    param(
        [Parameter(Mandatory = $true)]
        [string]$projectPath
    )

    Write-InfoMessage "$Global:Install Restoring packages for $projectPath"

    dotnet restore $projectPath --nologo
    Assert-LastCommandSuccess "Failed to restore packages for $projectPath"

    Write-SuccessMessage "Package restore completed successfully for $projectPath"
}

<#
.SYNOPSIS
    Finds the solution file (.sln) in the specified directory or its parent directories.
.PARAMETER path
    The starting path to search from. Defaults to the current directory.
#>
function Get-SolutionFile {
    param([string]$path = (Get-Location).Path)

    $currentPath = $path
    while ($currentPath -ne $null -and $currentPath -ne "") {
        $solution = Get-ChildItem -Path $currentPath -Filter *.sln -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($solution) {
            return $solution.FullName
        }
        $currentPath = Split-Path $currentPath -Parent
    }
    return $null
}

