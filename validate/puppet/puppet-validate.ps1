$command = 'puppet parser validate .\build\packer\puppet\*'

.\resources\scripts\start-command.ps1 -command $command

exit $LASTEXITCODE