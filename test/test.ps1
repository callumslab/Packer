$filepath = '.\build\output'

$AMIfile = Get-ChildItem $filepath | where name -like *ami*                                    

$AMIvalue =  Get-Content $AMIfile


Write-Output "Packer AMI is $AMIvalue"
Write-Output "Packer AMI is $AMIvalue"
Write-Output "Packer AMI is $AMIvalue"