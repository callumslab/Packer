param (

    [string]$computername,
    
    [pscredential]$credentials

)


try {
    
    $session = New-PSSession -ComputerName $computername -Credential $credentials -ErrorAction Stop

}

catch { exit 1 }


Describe "SoftwareInstallations" {
    
    Context "Windows Management Framework" {

        It "PowerShell major version is greater than 3" {

            $powershellversion = Invoke-Command -Session $session -ScriptBlock { $PSVersionTable.PSVersion }

            $powershellversion.major | should begreaterthan 3

        }

    }
    
    Context "Puppet Agent" {

        It "Puppet agent major version is 4" {

            [version]$puppetagentversion = Invoke-Command -Session $session -ScriptBlock { puppet agent --version }

            $puppetagentversion.major | should be 4

        }
        
        It "puppetlabs-windows Puppet module is installed" {

            $puppetmodulelist = Invoke-Command -Session $session -ScriptBlock { puppet module list }

            $puppetmodulelist | should match 'puppetlabs-windows'

        }
        
        It "Puppet agent service is running" {

            $puppetagentservice = Invoke-Command -Session $session -ScriptBlock { get-service -name puppet }

            $puppetagentservice.status | should be 'running'

        }
        
    }

    Context "Monitoring Agent" {
        
        It "NSClient++ agent service is running" {
            
            $nsclientagentservice = Invoke-Command -Session $session -ScriptBlock { get-service -name nscp }
            
            $nsclientagentservice.status | should be 'running'
            
        }
        
    }        

}

$session | Remove-PSSession