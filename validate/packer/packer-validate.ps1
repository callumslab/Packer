$command = 'packer version' #validate .\PackerTemplate.json'

.\validate\scripts\start-command.ps1 -command $command

exit $LASTEXITCODE