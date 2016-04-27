$ErrorActionPreference = 'Stop'

try {
    
    $filepath = '.\build\output'

    $AMIfile = Get-ChildItem $filepath | where name -like *ami*                               

    $AMIvalue =  $AMIfile | Get-Content
    
    Write-Output "Packer AMI is $AMIvalue"

}

catch {
    
    exit 1
    
}