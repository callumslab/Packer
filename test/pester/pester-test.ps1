$ErrorActionPreference = 'Stop'

try {
    
    Import-Module aws*
    Import-Module Pester
    
    $outputpath = '.\test\output'
    
    $globaltimeout = New-TimeSpan -Minutes 10
    
    if (-not (Test-Path $outputpath)) { 
        New-Item -Path $outputpath -ItemType Directory -Force | Out-Null
    }
    
    
    $thisinstance = .\resources\scripts\get-instancedata.ps1    
    
    Set-DefaultAWSRegion -Region $thisinstance.region
    
    
    $tfstateobject = Get-Content "$outputpath\terraform.tfstate" | ConvertFrom-Json
    
    $instanceattributes = $tfstateobject.modules.resources.'aws_instance.packerimage'.primary.attributes
    
    $pemfile = get-item -Path "$outputpath\tempkeypair.pem"

    
    $instancepassword = $null
    $timer = [diagnostics.stopwatch]::StartNew()
    while ($instancepassword -eq $null) {
        
        if ($timer.elapsed -lt $globaltimeout) {
        
            try {    
                $instancepassword = Get-EC2PasswordData -InstanceID $instanceattributes.id -Pemfile $pemfile
            }
            catch { Write-Output "Waiting for instance password to become available..." ; sleep 60 }
        
        }
        
        else { throw "Timed out waiting for the instance password" }

    }
    

    $securepass = $instancepassword | ConvertTo-SecureString -AsPlainText -Force
    $creds = [System.Management.Automation.PSCredential]::New("administrator",$securepass)
    
    
    $session = $null
    $timer = [diagnostics.stopwatch]::StartNew()
    while ($session -eq $null) {
        
        if ($timer.elapsed -lt $globaltimeout) {
    
            try {
                $session = New-PSSession -ComputerName $instanceattributes.private_ip -Credential $creds
            }
            catch { Write-Output "Waiting to establish WinRM remote session..." ; sleep 60 }
        
        }
        
        else { throw "Timed out waiting to establish a WinRM remote session" }
    
    }
    
    $session | Remove-PSSession
   
    
    Invoke-Pester -Script @{Path = '.\test\pester' ; 'Parameters' = @{'ComputerName' = $instanceattributes.private_ip ; 'Credentials' = $creds}} -OutputFile "$outputpath\pester.tests.xml" -OutputFormat NUnitXml
    
}

catch { $_ ; $LASTEXITCODE = 1 }

exit $LASTEXITCODE