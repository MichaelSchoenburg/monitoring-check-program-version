<#
.SYNOPSIS
    Monitoring-Skript: Programm-Version prüfen

.DESCRIPTION
    Dieses Skript prüft, ob die Version eines beliebigen Programms höher als die spezifizierte Version ist oder nicht und gibt eine entsprechenden Meldung + Exit Code zurück.

.RELATED LINKS
    GitHub: https://github.com/MichaelSchoenburg/monitoring-check-program-version

.NOTES
    Author: Michael Schönburg
    Version: v1.0
    Last Edit: 10.02.2025
    
    This projects code loosely follows the PowerShell Practice and Style guide, as well as Microsofts PowerShell scripting performance considerations.
    Style guide: https://poshcode.gitbook.io/powershell-practice-and-style/
    Performance Considerations: https://docs.microsoft.com/en-us/powershell/scripting/dev-cross-plat/performance/script-authoring-considerations?view=powershell-7.1
#>

#region INITIALIZATION
<# 
    Libraries, Modules, ...
#>

#endregion INITIALIZATION
#region DECLARATIONS
<#
    Declare local variables and global variables
#>

<#
The following Variables need to be set by your monitoring software:
[string]$AppName
[string]$VersionSoll

Example:
$AppName = "msedge.exe"
$VersionSoll = "128.0.2739.79"
#>

$VersionIsTooLow = $false

#endregion DECLARATIONS
#region FUNCTIONS
<# 
    Declare Functions
#>

function Write-ConsoleLog {
    <#
    .SYNOPSIS
    Logs an event to the console.
    
    .DESCRIPTION
    Writes text to the console with the current date (US format) in front of it.
    
    .PARAMETER Text
    Event/text to be outputted to the console.
    
    .EXAMPLE
    Write-ConsoleLog -Text 'Subscript XYZ called.'
    
    Long form
    .EXAMPLE
    Log 'Subscript XYZ called.
    
    Short form
    #>
    [alias('Log')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
        Position = 0)]
        [string]
        $Text
    )

    # Save current VerbosePreference
    $VerbosePreferenceBefore = $VerbosePreference

    # Enable verbose output
    $VerbosePreference = 'Continue'

    # Write verbose output
    Write-Verbose "$( Get-Date -Format 'MM/dd/yyyy HH:mm:ss' ) - $( $Text )"

    # Restore current VerbosePreference
    $VerbosePreference = $VerbosePreferenceBefore
}



#endregion FUNCTIONS
#region EXECUTION
<# 
    Script entry point
#>

$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\$AppName"
Write-Host "Teste, ob der Pfad $Path existiert..."
if (Test-Path -Path $Path) {
    Write-Host "Der Pfad existiert. Bestimme Version..."
    $versionIst = (Get-Item (Get-ItemProperty $Path).'(Default)').VersionInfo.ProductVersion
    
    if ([System.Version]$versionIst -lt [System.Version]$versionSoll) {
        $VersionIsTooLow = $true
    }
    
    if ($VersionIsTooLow) {
        Write-Host "Fehler: Die Version von $AppName ist $($versionIst), sollte aber mindestens $($versionSoll) sein."
        
    } else {
        Write-Host "Erfolg: Die Version von $AppName ist $($versionIst) und sollte mindestens $($versionSoll) sein."
        
    }    
} else {
    Write-Host "Warnung: Der Pfad existiert nicht, somit kann die Version nicht bestimmt werden."
    
}

#endregion EXECUTION
