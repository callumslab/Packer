$ErrorActionPreference = 'Stop'

try {
    
    $inputpath = '.\build\output'

    $AMIfile = Get-ChildItem $inputpath | where name -like *ami*                               

    [string]$AMIvalue =  $AMIfile | Get-Content
    
    $env:TF_VAR_packer_ami = $AMIvalue
    
    
    $outputpath = '.\test\output'

    if (-not (Test-Path $outputpath)) { 
        New-Item -Path $outputpath -ItemType Directory -Force | Out-Null
    }

}

catch { exit 1 }


$command = "terraform apply -state='$outputpath\terraform.tfstate' -backup=- .\test\terraform"

.\resources\scripts\start-command.ps1 -command $command

exit $LASTEXITCODE