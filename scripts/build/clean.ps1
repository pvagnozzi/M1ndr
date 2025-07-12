<#
.SYNOPSIS
    Cleans all bin and obj folders in the solution.

.DESCRIPTION
    Recursively deletes all bin and obj directories from the current directory down.

.EXAMPLE
    ./clean.ps1


#>

# Colors & Emoji
$Green = "`e[32m"
$Red = "`e[31m"
$Cyan = "`e[36m"
$Reset = "`e[0m"
$Check = "✅"
$Broom = "🧹"
$Warn = "⚠️"

if ($args -contains '-Help' -or $args -contains '--help') {
    Write-Host "${Cyan}${Broom}  CLEAN SCRIPT  ${Reset}\n"
    Write-Host "USAGE:"
    Write-Host "    ./clean.ps1 [--help]"
    Write-Host "\nDESCRIPTION:"
    Write-Host "    Cleans all bin and obj folders in the solution recursively."
    Write-Host "\nEXAMPLES:"
    Write-Host "    ./clean.ps1"
    Write-Host "    ./clean.ps1 --help"
    exit 0
}

Write-Host "${Cyan}${Broom} Cleaning bin and obj folders...${Reset}"
Get-ChildItem -Path . -Include bin,obj -Recurse -Directory | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
if ($?) {
    Write-Host "${Green}${Check} Clean completed successfully!${Reset}"
} else {
    Write-Host "${Red}${Warn} Clean failed.${Reset}"
}
