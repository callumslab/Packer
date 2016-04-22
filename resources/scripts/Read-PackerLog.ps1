param (
    
    [string]$packerlog
    
)


$objectarray = @()

foreach ($line in (Get-Content $packerlog)) {

    $objectdata = $line.Split(',',4)

    $object = [pscustomobject] @{'timestamp' = $objectdata[0]
                                 'target' = $objectdata[1]
                                 'type' = $objectdata[2]
                                 'data' = $objectdata[3]}

    $objectarray += $object

}

return $objectarray