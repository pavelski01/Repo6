<#
    .SYNOPSIS
    Check data consistency.
    .PARAMETER ScannedDirectoryPath
    Path to scanned directory.
    .PARAMETER ScannedLogPath
    Log with entries.
    .PARAMETER DirectorySeparator
    Directory separator.
    .PARAMETER DirectorySeparator
    Entry separator.
    .PARAMETER PathCutLevel
    Cut path from beginning to level (root is zero level).
    .PARAMETER LineDistinction
    Line distinction added when match is found.
#>
Param(
    [string]$ScannedDirectoryPath  = "./dir", 
    [string]$ScannedLogPath = "log.txt", 
    [string]$DirectorySeparator="\\", 
    [string]$EntrySeparator=";", 
    [int]$PathCutLevel=0
)

function DataConsistencyCheck {
    $files = Get-ChildItem -Path $ScannedDirectoryPath -Recurse -File | Sort-Object FullName
    foreach ($file in $files) {
        $countLevel = ($file.FullName -Split $DirectorySeparator).Length
        if ($countLevel -lt (2 + $PathCutLevel)) {
            throw [System.IO.InvalidDataException]::new("Data not consistent: $($file.FullName)")
        }
    }
}

function MakeEntries {
    [string[]]$entries = @()
    $files = Get-ChildItem -Path $ScannedDirectoryPath -Recurse -File | Sort-Object FullName
    foreach ($file in $files) {
        $hash = (Get-FileHash -Path $file.FullName -Algorithm MD5).Hash.ToLower()
        $fileSubPath = ($file.FullName -Split $DirectorySeparator, (2 + $PathCutLevel))[1 +  $PathCutLevel]
        $entry = "$($fileSubPath);$($hash)"
        $entries += $entry
    }
    return $entries
}

function ScanLogFile {
    Param([string[]]$Entries)

    $fileContent = Get-Content -Path $ScannedLogPath
    $modifiedContent = $fileContent | ForEach-Object {
        foreach ($entry in $Entries) {
            if ($_ -match [regex]::Escape($entry)) {
                return $null 
            }
        }
    }
    $modifiedContent | Set-Content -Path $ScannedLogPath
}

DataConsistencyCheck
$entries = MakeEntries
ScanLogFile -Entries $entries