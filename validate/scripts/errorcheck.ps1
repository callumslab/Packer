param (

    [string] $message,
    [scriptblock] $command

)

$ErrorActionPreference = 'Stop'

function Invoke-ExternalTool
    (

    [string] $message,
    [scriptblock] $command

    )
    { 
        & $command
        if ($LastExitCode -gt 0) { throw "$message : External tool call failed" }
    }


try {
  
  Write-Output "Script: $($MyInvocation.MyCommand.Path)"
  #Write-Output "Pid: $pid"
  #Write-Output "Host.Version: $($host.version)"
  Write-Output "Execution policy: $(get-executionpolicy)"
    

    Invoke-ExternalTool $message $command
    

}

catch {
  
  Write-Output "$pid : Error caught : $_"
  
  if ($? -and (Test-Path variable:LastExitCode) -and ($LastExitCode -gt 0)) { exit $LastExitCode }
  else { exit 1 }

}