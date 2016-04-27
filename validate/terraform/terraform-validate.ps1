$command = 'terraform validate .\test\terraform\terraform-template.tf'

.\resources\scripts\start-command.ps1 -command $command

exit $LASTEXITCODE