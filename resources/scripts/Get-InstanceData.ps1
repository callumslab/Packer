try {
    
    Import-Module -Name aws*

    
    $thisinstanceregion = (Invoke-WebRequest -Uri 'http://169.254.169.254/latest/dynamic/instance-identity/document').content | ConvertFrom-Json | select -ExpandProperty region

    $thisinstanceid = (Invoke-WebRequest -Uri 'http://169.254.169.254/latest/meta-data/instance-id').content

    $thisinstanceproperties = (Get-EC2Instance -Instance $thisinstanceid -Region $thisinstanceregion).runninginstance

    # Tagging on the region as a NoteProperty to this object
    $thisinstanceproperties | Add-Member -MemberType NoteProperty -Name Region -Value $thisinstanceregion
    
}
    
catch { exit 1 }


return $thisinstanceproperties