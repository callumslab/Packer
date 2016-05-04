$ErrorActionPreference = 'Stop'

try {
    
    $outputpath = '.\test\output'

    if (-not (Test-Path $outputpath)) { 
        New-Item -Path $outputpath -ItemType Directory -Force | Out-Null
    }
    
    
    $thisinstance = .\resources\scripts\get-instancedata.ps1    
    
    Set-DefaultAWSRegion -Region $thisinstance.region
    
    
    $tempkeypair = New-EC2KeyPair -KeyName "terraform-$(Get-Random -Minimum 001 -Maximum 999)"
    
    $tempkeypair.keymaterial | Out-File -FilePath "$outputpath\tempkeypair.pem" -Force
    
    $pemfile = get-item -Path "$outputpath\tempkeypair.pem"
    
    
    # A temp sec group should be created on the fly, should match Packer
    $secgroupname = 'IaC-Testing-ZenMgmtSecGroup'
    
    $secgroupid = (Get-EC2SecurityGroup | where groupname -Match $secgroupname).groupid
    
    
    # This section should be replaced by a property that is retreived and matched from the AMI 
    $inputpath = '.\build\output'

    $AMIfile = Get-ChildItem $inputpath | where name -like *ami*                               

    [string]$AMIvalue =  $AMIfile | Get-Content
    
    $env:TF_VAR_packer_ami = $AMIvalue
    # End section - getting AMI
    
    
   
    
    # This could be fed in from GoCD as an environment variable
    $rolename = 'IaC-Testing-GoCDBuildServer'

    [pscustomobject]$rolecreds = .\resources\scripts\get-iamrolecreds.ps1 -rolename $rolename
    if (-not ($rolecreds)) { throw }


    # Setting env variables needed by terraform
    $env:TF_VAR_access_key = $rolecreds.accesskeyid
    $env:TF_VAR_secret_key = $rolecreds.secretaccesskey
    $env:TF_VAR_token = $rolecreds.token
    $env:TF_VAR_region = $thisinstance.region
    $env:TF_VAR_vpc_security_group_ids = $secgroupid
    $env:TF_VAR_subnet_id = $thisinstance.subnetid
    $env:TF_VAR_keypair = $tempkeypair.keyname
    

    $command = "terraform apply -state='$outputpath\terraform.tfstate' -backup=- .\test\terraform"

    .\resources\scripts\start-command.ps1 -command $command

    
    $tfstateobject = Get-Content "$outputpath\terraform.tfstate" | ConvertFrom-Json
    
    $instanceattributes = $tfstateobject.modules.resources.'aws_instance.packerimage'.primary.attributes

    
    # Insert wait or checks to make sure the instance is ready before we get the password
    sleep 300
    
    $instancepassword = Get-EC2PasswordData -InstanceID $instanceattributes.id -Pemfile $pemfile

    $securepass = $instancepassword | ConvertTo-SecureString -AsPlainText -Force
    $creds = [System.Management.Automation.PSCredential]::New("administrator",$securepass)
    
    $session = New-PSSession -ComputerName $instanceattributes.private_ip -Credential $creds
    
    Invoke-Command -Session $session -ScriptBlock { get-process }
    
    
    # Insert terraform destroy command here

    $tempkeypair | Out-File c:\zendata\keypair.txt -Force
    $tempkeypair | Remove-EC2KeyPair -force

}


catch { $_ ; $LASTEXITCODE = 1 }

exit $LASTEXITCODE