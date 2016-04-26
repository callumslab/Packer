$command = 'packer -machine-readable build .\PackerTemplate.json'

.\resources\scripts\start-command.ps1 -command $command -enablelog -logpath '.\logs'

if ($LASTEXITCODE -eq 0) {
    
    $packerlogpath = '.\logs'

    $packerlogname = Get-ChildItem $packerlogpath | where name -like *packer* | select -ExpandProperty name                                    

    [string]$packerami =  .\resources\scripts\Get-PackerAMI.ps1 -packerlogname $packerlogname -packerlogpath $packerlogpath
    
    Remove-Item Env:\PackerAMI -ErrorAction SilentlyContinue
    
    $Env:PackerAMI = $packerami

}

$Env:PackerAMI
$Env:PackerAMI
$Env:PackerAMI

exit $LASTEXITCODE

