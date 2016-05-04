param (

    [string]$computername,
    
    [pscredential]$credentials

)


try {
    
    $session = New-PSSession -ComputerName $computername -Credential $credentials -ErrorAction Stop

}

catch { exit 1 }


Describe "SoftwareInstallations" {
    
    Context "PowerShell" {

        It "Major version is greater than 3" {

            $powershellversion = Invoke-Command -Session $session -ScriptBlock { $PSVersionTable.PSVersion.Major }

            $powershellversion | should be greater than 3

        }

    }

}

$session | Remove-PSSession