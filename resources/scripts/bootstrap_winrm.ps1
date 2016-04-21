Write-Host "Disabling WinRM over HTTP..."
Disable-NetFirewallRule -Name "WINRM-HTTP-In-TCP"
Disable-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC"

Start-Process -FilePath winrm `
    -ArgumentList "delete winrm/config/listener?Address=*+Transport=HTTP" `
    -NoNewWindow -Wait

Write-Host "Configuring WinRM for HTTPS..."
Start-Process -FilePath winrm `
    -ArgumentList "set winrm/config @{MaxTimeoutms=`"1800000`"}" `
    -NoNewWindow -Wait

Start-Process -FilePath winrm `
    -ArgumentList "set winrm/config/winrs @{MaxMemoryPerShellMB=`"1024`"}" `
    -NoNewWindow -Wait

Start-Process -FilePath winrm `
    -ArgumentList "set winrm/config/service @{AllowUnencrypted=`"false`"}" `
    -NoNewWindow -Wait

Start-Process -FilePath winrm `
    -ArgumentList "set winrm/config/service/auth @{Basic=`"true`"}" `
    -NoNewWindow -Wait

Start-Process -FilePath winrm `
    -ArgumentList "set winrm/config/service/auth @{CredSSP=`"true`"}" `
    -NoNewWindow -Wait

New-NetFirewallRule -Name "WINRM-HTTPS-In-TCP" `
    -DisplayName "Windows Remote Management (HTTPS-In)" `
    -Description "Inbound rule for Windows Remote Management via WS-Management. [TCP 5986]" `
    -Group "Windows Remote Management" `
    -Program "System" `
    -Protocol TCP `
    -LocalPort "5986" `
    -Action Allow `
    -Profile Domain,Private

New-NetFirewallRule -Name "WINRM-HTTPS-In-TCP-PUBLIC" `
    -DisplayName "Windows Remote Management (HTTPS-In)" `
    -Description "Inbound rule for Windows Remote Management via WS-Management. [TCP 5986]" `
    -Group "Windows Remote Management" `
    -Program "System" `
    -Protocol TCP `
    -LocalPort "5986" `
    -Action Allow `
    -Profile Public

#$certContent = "<insert a base 64 encoded version of your certificate here>"
$certContent = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMxRENDQWJ5Z0F3SUJBZ0lKQVBBeWNiemFTYTVuTUEwR0NTcUdTSWIzRFFFQkN3VUFNQjB4R3pBWkJnTlYKQkFNTUVuQmhZMnRsY2kxM2FXNXliUzB4TlRRd09UQWVGdzB4TmpBek1qa3hOREF6TlRKYUZ3MHlOakF6TWpjeApOREF6TlRKYU1CMHhHekFaQmdOVkJBTU1FbkJoWTJ0bGNpMTNhVzV5YlMweE5UUXdPVENDQVNJd0RRWUpLb1pJCmh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTW0zWHV5QkhGMmg5WnZFK2Jqa3VmTkw2M3JmZ3k0RDNHM3kKMzEvMzZuU1hWbjA4YzRUQU9HN0ROd3FVQnIyRDc4dUZtbkoxNzFGc29lNS91aXhwekdickhmVzdJS0taRitMVQpwL0tueUxNVlZ5M0NwekR0R2M2N3U0ek41NlU5UkV4MkZPQVd2eDU5ZHVVaHlvTjgrMEg0MlJoY1VqODNXT1ErCm1ad3pWVjN4WVgwK09ucHVXSHI3d0pMS2Q4VW1zTFRXR3YwSmx5WEQrbVdXOVg2MVIvSG1LYlJmcm55R0hXQmQKUCtOaEVxRjBVSEVmR2J6L2dCVWk0UkFITmFNWDVROTZicUpHYzVaMTZxTXRrWEVMVVBvUlVrVFpRSkg4Q2pObgpvNGY5Tk1Xdy9IVS9jRXZGNm5TY2cxb3YxT2xFTU5OOHZCY3pHeFZENGZCaUV0OHM1cEVDQXdFQUFhTVhNQlV3CkV3WURWUjBsQkF3d0NnWUlLd1lCQlFVSEF3RXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRXYrdGx6clZ5anoKUnFoNjQ0UWNXb2h6dDdJT0pNRjNyd21DM3RqZFd0bzhtZGIvL08wWTdqUFF4N0lhU1YwUklrZlV2ZHNmeUtpMwpGTXJUSmtJQ3hMWno3SW9kcEgvNUdyWU9sQndtd0ltSWZzUVZadk40V1RvZng4SER5SHpkVUxKaC9oUDhHK1lnCmxSWU5oSFlORmF1R0poQXM3SGFxaTdIUXNNbTA3MHEzeTdaL2ptS1NhczhZMzI0Zi9LQ0NmWmZlMFo2bnl6UGMKUEV2bm0wb1lBK0xLSDRaeDl2RU1OYVQ1eWJDWnVmaVc4UGRhMUUzWkR5ejJRL0h3K2NVVFdGZkZSa3ppeVdGTgpOb0JqS054cUxFMm1ER0sxTTNPTnlNVmYrb2hxaEd3NjZYL21nbUVzUEJ4akpxS3FQQzdDRmg0QnYxaEViUDhBCmZkdFZoTVpXVVBNPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="

$certBytes = [System.Convert]::FromBase64String($certContent)
$pfx = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
$pfx.Import($certBytes, "", "Exportable,PersistKeySet,MachineKeySet")
$certThumbprint = $pfx.Thumbprint
$certSubjectName = $pfx.SubjectName.Name.TrimStart("CN = ").Trim()

$store = new-object System.Security.Cryptography.X509Certificates.X509Store("My", "LocalMachine")
try {
    $store.Open("ReadWrite,MaxAllowed")
    $store.Add($pfx)

} finally {
    $store.Close()
}

Start-Process -FilePath winrm `
    -ArgumentList "create winrm/config/listener?Address=*+Transport=HTTPS @{Hostname=`"$certSubjectName`";CertificateThumbprint=`"$certThumbprint`";Port=`"5986`"}" `
    -NoNewWindow -Wait

# This part is optional
$user = [adsi]"WinNT://localhost/Administrator,user"
$user.SetPassword("C0mpl3xP@ssword")
$user.SetInfo()

Write-Host "Restarting WinRM Service..."
Stop-Service winrm
Set-Service winrm -StartupType "Automatic"
Start-Service winrm
