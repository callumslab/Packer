﻿$command = 'packer validate .\build\packer\packer-template.json'

.\resources\scripts\start-command.ps1 -command $command

exit $LASTEXITCODE