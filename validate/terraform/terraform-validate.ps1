$command = 'terraform validate .\test\terraform'

.\resources\scripts\start-command.ps1 -command $command

exit $LASTEXITCODE