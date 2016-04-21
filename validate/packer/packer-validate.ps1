$ErrorActionPreference = 'Stop'

function Invoke-ExternalTool {

    Param (
            [string] $context,
            [scriptblock] $actionBlock
           )

    {
        
        & $actionBlock
        if ($LastExitCode -gt 0) { throw "$context : External tool call failed" }

    }

}


try {
  
  Write-Output "Script:            " $MyInvocation.MyCommand.Path
  Write-Output "Pid:               " $pid
  Write-Output "Host.Version:      " $host.version
  Write-Output "Execution policy:  " $(get-executionpolicy)

  Invoke-ExternalTool 'packer validate' { packer validate .\PackerTemplate.json }

}

catch {
  
  Write-Output "$pid : Error caught - $_"
  
  if ($? -and (Test-Path variable:LastExitCode) -and ($LastExitCode -gt 0)) { exit $LastExitCode }
  else { exit 1 }

}