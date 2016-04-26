$command = 'packer -machine-readable build .\PackerTemplate.jsonx'

try {
    .\resources\scripts\start-command.ps1 -command $command -enablelog -logpath '.\logs'
}

catch {
    Write-Output "powershell found the error"
}


#Write-Output ("result is: $commandresult`n" * 10)


exit $LASTEXITCODE

