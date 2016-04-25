# Script to read a packer machine readable log file and look for the Amazon AMI id that was outputted as part of the build process.
# The script also coverts the packer machine readable log file into a PowerShell object which can be used for further analysis.
# Reference: https://www.packer.io/docs/command-line/machine-readable.html

param (
    
    [string]$packerlogname,
    
    [string]$packerlogpath
    
)


$objectarray = @()

foreach ($line in (Get-Content "$packerlogpath\$packerlogname")) {

    $objectdata = $line.Split(',',4)

    $object = [pscustomobject] @{'timestamp' = $objectdata[0]
                                 'target' = $objectdata[1]
                                 'type' = $objectdata[2]
                                 'data' = $objectdata[3]}

    $objectarray += $object

}

$objectarray | select data | where data -Match "AMI: (?<ami>ami-[0-9,a-f]+)" | Out-Null

return $Matches['ami']