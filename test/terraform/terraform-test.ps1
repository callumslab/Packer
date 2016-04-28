$ErrorActionPreference = 'Stop'

try {
    
    Import-Module -Name aws*
    
    Set-DefaultAWSRegion -Region $env:AWS_region
    
    $thisinstanceid = (Invoke-WebRequest -Uri 'http://169.254.169.254/latest/meta-data/instance-id').content
    
    $thisinstance = (Get-EC2Instance -Instance $thisinstanceid).runninginstance
    
    $tempkeypair = New-EC2KeyPair -KeyName "terraform-$(Get-Random -Minimum 001 -Maximum 999)"
    
    # A temp sec group should be created on the fly
    $secgroupname = 'IaC-Testing-ZenMgmtSecGroup'
    
    $secgroupid = (Get-EC2SecurityGroup | where groupname -Match $secgroupname).groupid
    
    
    $inputpath = '.\build\output'

    $AMIfile = Get-ChildItem $inputpath | where name -like *ami*                               

    [string]$AMIvalue =  $AMIfile | Get-Content
    
    $env:TF_VAR_packer_ami = $AMIvalue
    
    
    $outputpath = '.\test\output'

    if (-not (Test-Path $outputpath)) { 
        New-Item -Path $outputpath -ItemType Directory -Force | Out-Null
    }
    
    

    # This could be fed in from GoCD as an environment variable
    $rolename = 'IaC-Testing-GoCDBuildServer'

    [pscustomobject]$rolecreds = .\resources\scripts\get-iamrolecreds.ps1 -rolename $rolename

    if (-not ($rolecreds)) { throw }


    $env:TF_VAR_access_key = $rolecreds.accesskeyid
    $env:TF_VAR_secret_key = $rolecreds.secretaccesskey
    $env:TF_VAR_token = $rolecreds.token
    $env:TF_VAR_region = $env:AWS_region
    $env:TF_VAR_keypair = $tempkeypair.keyname
    $env:TF_VAR_subnet_id = $thisinstance.subnetid
    $env:TF_VAR_vpc_security_group_ids = $secgroupid


    $command = "terraform apply -state='$outputpath\terraform.tfstate' -backup=- .\test\terraform"

    .\resources\scripts\start-command.ps1 -command $command

    # Insert terraform destroy command here


    $tempkeypair | Remove-EC2KeyPair -force

}


catch { $LASTEXITCODE = 1 }

exit $LASTEXITCODE