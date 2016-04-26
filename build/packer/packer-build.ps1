$command = 'packer -machine-readable build .\PackerTemplate.jsonx'

$commandresult = .\resources\scripts\start-command.ps1 -command $command -enablelog -logpath '.\logs'

$commandresult | gm

#Write-Output ("result is: $commandresult`n" * 10)


exit $LASTEXITCODE

