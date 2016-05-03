param (
    
    [string]$imagename
    
)


try {

    Import-Module -Name aws*

    $thisinstanceregion = (Invoke-WebRequest -Uri 'http://169.254.169.254/latest/dynamic/instance-identity/document').content | ConvertFrom-Json | select -ExpandProperty region

    $latestami = (Get-EC2ImageByName -Name $imagename -Region $thisinstanceregion).ImageId
    
}
    
catch { exit 1 }


return $latestami