$command = 'packer validate .\PackerTemplate.json'

.\resources\scripts\start-command.ps1 -command $command

exit $LASTEXITCODE