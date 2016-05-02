$ErrorActionPreference = 'Stop'

# This could be a variable from GoCD depeding on what image we want to use
$imagename = 'WINDOWS_2012R2_BASE'


try {
    
    Import-Module -Name aws*
    Set-DefaultAWSRegion -Region $env:AWS_region
    
    $latestami = (Get-EC2ImageByName -Name $imagename).ImageId
    
    $thisinstanceid = (Invoke-WebRequest -Uri 'http://169.254.169.254/latest/meta-data/instance-id').content
    $thisinstance = (Get-EC2Instance -Instance $thisinstanceid).runninginstance
    
    $env:PK_VAR_source_ami = $latestami
    $env:PK_VAR_vpc_id = $thisinstance.vpcid
    $env:PK_VAR_subnet_id = $thisinstance.subnetid
    
}
    
catch {}

$command = 'packer -machine-readable build .\build\packer\packer-template.json'
$logpath = '.\build\output'

#$env:PACKER_LOG=1
#$env:PACKER_LOG_PATH="$logpath\packerlog.txt"

.\resources\scripts\start-command.ps1 -command $command -enablelog -logpath $logpath


if ($LASTEXITCODE -eq 0) {
    
    try {
        
        $packerlogname = Get-ChildItem $logpath | where name -like *packer-build* | select -ExpandProperty name                                  

        [string]$AMIvalue =  .\resources\scripts\Get-PackerAMI.ps1 -packerlogname $packerlogname -packerlogpath $logpath
        
        $AMIfile = New-Item -Path $logpath -Name 'PackerAMI.txt' -ItemType File -Force
        
        Set-Content -Path $AMIfile -Value $AMIvalue
    
    }
    
    catch {
        
        Write-Output "Error with the PackerAMI file: $_"
        
        $LASTEXITCODE = 1
    
    }
    
}

exit $LASTEXITCODE

