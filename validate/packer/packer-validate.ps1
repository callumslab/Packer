$ErrorActionPreference = 'Stop'

# This could be a variable from GoCD depeding on what image we want to use
$imagename = 'WINDOWS_2012R2_BASE'

try {
    
    Import-Module -Name aws*
    Set-DefaultAWSRegion -Region $env:AWS_region
    
    $latestami = (Get-EC2ImageByName -Name $imagename).ImageId
    
    $env:PK_VAR_source_ami = $latestami
    
}

catch {}


$command = 'packer validate .\build\packer\packer-template.json'

.\resources\scripts\start-command.ps1 -command $command

exit $LASTEXITCODE