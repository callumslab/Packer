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


# This could be fed in from GoCD as an environment variable
$rolename = 'IaC-Testing-GoCDBuildServer'

[pscustomobject]$rolecreds = .\resources\scripts\get-iamrolecreds.ps1 -rolename $rolename

if (-not ($rolecreds)) { exit 1 }


$env:TF_VAR_access_key = $rolecreds.accesskeyid
$env:TF_VAR_secret_key = $rolecreds.secretaccesskey
$env:TF_VAR_token = $rolecreds.token


$command = "terraform apply -state='$outputpath\terraform.tfstate' -backup=- .\test\terraform"

.\resources\scripts\start-command.ps1 -command $command

exit $LASTEXITCODE