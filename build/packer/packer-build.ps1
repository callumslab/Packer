$ErrorActionPreference = 'Stop'


try {
    
    $thisinstance = .\resources\scripts\get-instancedata.ps1
    
    $latestami = .\resources\scripts\get-latestami.ps1 -imagename $env:AWS_Image_Name
    
    
    # Set env variables needed by packer
    $env:PK_VAR_source_ami = $latestami
    $env:PK_VAR_region = $thisinstance.region
    $env:PK_VAR_vpc_id = $thisinstance.vpcid
    $env:PK_VAR_subnet_id = $thisinstance.subnetid
    
}
    
catch { exit 1 }

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

