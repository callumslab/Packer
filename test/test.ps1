$logpath = '.\build\output'

$AMIfile = Get-ChildItem $logpath | where name -like *ami* | select -ExpandProperty name                                    

$AMIvalue =  Get-Content $AMIfile


Write-Output "Packer AMI is $AMIvalue"
Write-Output "Packer AMI is $AMIvalue"
Write-Output "Packer AMI is $AMIvalue"