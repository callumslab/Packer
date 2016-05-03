<powershell>

Set-ExecutionPolicy -ExecutionPolicy Unrestricted

Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value true
Set-Item WSMan:\localhost\Service\Auth\Basic -Value true

Restart-Service WinRM

</powershell>