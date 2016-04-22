# Simple script for running strings as commands and catching and returning errors if any are found.
# Useful when running native Windows applications such as .exe's

Param (

    [string]$command

)

$ErrorActionPreference = 'Stop'

try {

    Invoke-Expression -Command $command

    if ($LASTEXITCODE -gt 0) { throw }

    else { exit $LASTEXITCODE }

}

catch {

    Write-Output "*** Error Encountered ***`nLast exit code: $LASTEXITCODE `nCommand: $command `nError message: $_"

    exit $LASTEXITCODE

}