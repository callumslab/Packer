$ErrorActionPreference = 'Stop'

try {

    $latestami = .\resources\scripts\get-latestami.ps1 -imagename $env:AWS_Image_Name
    
    # Set env variables needed by packer
    $env:PK_VAR_source_ami = $latestami

}

catch { exit 1 }


$command = 'packer validate .\build\packer\packer-template.json'

.\resources\scripts\start-command.ps1 -command $command

exit $LASTEXITCODE