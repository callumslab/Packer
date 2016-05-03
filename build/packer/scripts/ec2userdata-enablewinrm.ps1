<powershell>

Set-ExecutionPolicy -ExecutionPolicy Unrestricted

New-Item -Path c:\ -Name ZenData -ItemType Directory | Out-Null

Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value true
Set-Item WSMan:\localhost\Service\Auth\Basic -Value true

Restart-Service WinRM

</powershell>