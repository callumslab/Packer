$command = 'packer -machine-readable build .\PackerTemplate.json'

.\resources\scripts\start-command.ps1 -command $command

exit $LASTEXITCODE