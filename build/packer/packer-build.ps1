$command = 'packer -machine-readable build .\PackerTemplate.json'

.\resources\scripts\start-command.ps1 -command $command -log

exit $LASTEXITCODE