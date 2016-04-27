$ErrorActionPreference = 'Stop'

try {
    
    $filepath = '.\build\output'

    $AMIfile = Get-ChildItem $filepath | where name -like *ami*                               

    [string]$AMIvalue =  $AMIfile | Get-Content
    
    $env:TF_VAR_packer_ami = $AMIvalue

}

catch { exit 1 }


$command = 'terraform apply .\test\terraform'

.\resources\scripts\start-command.ps1 -command $command

exit $LASTEXITCODE