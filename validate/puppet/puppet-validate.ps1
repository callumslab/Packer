$command = 'puppet parser validate .\build\packer\puppet\site.pp'

.\resources\scripts\start-command.ps1 -command $command

exit $LASTEXITCODE