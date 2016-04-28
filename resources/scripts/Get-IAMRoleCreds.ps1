param (

    [string]$RoleName

)

$baseuri = 'http://169.254.169.254/latest/meta-data/iam/security-credentials'

$roles = (Invoke-WebRequest -Uri $baseuri).content

$rolematch = $roles | ForEach-Object {
    
    if ($RoleName -match $_) {
        
        return $_
        
    }
    
    else {
        
        return $null
        
    }

}


if ($rolematch) {
    
    $rolecredsjson = (Invoke-WebRequest -Uri "$baseuri/$rolematch").content
    
    $rolecredsobject = $rolecredsjson | ConvertFrom-Json
    
}

else {
    
    $rolecredsobject = $null
}

return $rolecredsobject