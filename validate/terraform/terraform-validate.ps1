$command = 'terraform validate .\test\terraform\*.tf'

.\resources\scripts\start-command.ps1 -command $command

exit $LASTEXITCODE