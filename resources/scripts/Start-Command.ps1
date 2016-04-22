# Simple script for running strings as commands and catching and returning errors if any are found.
# Useful when running native Windows applications such as .exe's

Param (

    [string]$command,
    
    [switch]$log

)

$ErrorActionPreference = 'Stop'

try {
    
    if ($log) { 
        
        $logfile = "$((Get-PSCallStack).command[1]).log"
        
        New-Item -Path $logfile -ItemType File -Force
            
        $command = "$command | Tee-Object -file .\logs\$logfile"
    
    }
    
    Invoke-Expression -Command $command

    if ($LASTEXITCODE -gt 0) { throw }

    else { exit $LASTEXITCODE }

}

catch {

    Write-Output "*** Error Encountered ***`nLast exit code: $LASTEXITCODE `nCommand: $command `nError message: $_"
    
    if ($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq $null) { $LASTEXITCODE = 1 }
    
    exit $LASTEXITCODE

}