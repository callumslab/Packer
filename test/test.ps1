$packerlogpath = '.\logs'

$packerlogname = Get-ChildItem $packerlogpath | where name -like *packer* | select -ExpandProperty name                                    

$packerami =  .\resources\scripts\read-packerlog.ps1 -packerlogname $packerlogname -packerlogpath $packerlogpath


Write-Output "Packer AMI is $packerami"