# Temporary fix until chocolatey-chocolatey version 1.2.2 is released.
$fix = "if ((versioncmp(`$::clientversion, '3.4.0') >= 0) and (!defined(`$::serverversion') or versioncmp(`::serverversion, '3.4.0') >= 0)) {"

$content = Get-Content C:/ProgramData/PuppetLabs/code/environments/production/modules/chocolatey/manifests/init.pp
$content |
  ForEach-Object {
    if ($_.ReadCount -eq 80) {
      $_ -replace'\w+', $fix
    } else {
      $_
    }
  } |
  Set-Content C:/ProgramData/PuppetLabs/code/environments/production/modules/chocolatey/manifests/init.pp
