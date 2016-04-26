$ErrorActionPreference = 'Stop'

$command = 'packer -machine-readable build .\PackerTemplate.json'

$logpath = '.\build\output'

.\resources\scripts\start-command.ps1 -command $command -enablelog -logpath $logpath


if ($LASTEXITCODE -eq 0) {

    $packerlogname = Get-ChildItem $logpath | where name -like *packer-build* | select -ExpandProperty name                                  

    [string]$AMIvalue =  .\resources\scripts\Get-PackerAMI.ps1 -packerlogname $packerlogname -packerlogpath $logpath
    
    
    try {
        $AMIfile = New-Item -Path $logpath -Name 'PackerAMI.txt' -ItemType File -Force
        Set-Content -Path $AMIfile -Value $AMIvalue
    }
    
    catch {
        Write-Output "Error creating and setting the content of the AMIfile: $_"
        $LASTEXITCODE = 1
    }
    

}


exit $LASTEXITCODE

