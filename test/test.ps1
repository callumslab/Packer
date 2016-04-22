$packerlog = Get-ChildItem .\logs | where name -like *packer* | select -ExpandProperty name                                    

.\resources\scripts\read-packerlog.ps1 -packerlog $packerlog

