$command = 'puppet-lint .\resources\puppet\*'

.\validate\scripts\start-command.ps1 -command $command

exit $LASTEXITCODE