function Invoke-Downtime{
<# 
 .Synopsis
  Function to scedule downtime for host in Nagios

 .Description
  Recursive function that will display all dependencies of any service or all services
  
 .Parameter Verbose
  Provides Verbose output which is useful for troubleshooting

 .Parameter user
  The username left to Nagios invoke the downtime request

 .Parameter comment
  Comment left to Nagios for the reason of downtime
 
 .Example
  Invoke-Downtime -user Powershell -comment "Downtime for restarting vsswriters"
  This example will scedule 30 minutes downtime of the host from user powershell with comment

 .Example
  Invoke-Downtime -user Puppet -comment "Scheduled host downtime for patching" -custom patch=1
  This example will scedule 120 minutes downtime of the host from user Puppet with comment

  .Notes
   VERSION:   1.0
   NAME:      Get-VssWriters
   AUTHOR:    Rudi Steffensen

#>
    [CmdLetBinding()]
    Param(
    $user='',
    $comment='',
    $custom=''
  )
    try{
        $wc = New-Object system.Net.WebClient;
        $string = "http://80.72.15.140:88/downtime.php?user=$user&comment=$comment&$custom"
        $request = $wc.downloadString("$string")
        Write-Verbose $string
        If ($request -like '*OK - Scheduled*') {Write-Verbose "Site is OK! Schedule downtime succeeded"}
        else{Write-Error "Schedule downtime failed"}
      }
      catch{
          $Error | Out-File "C:\dcsto\scripts\Invoke-Downtime.log" -Append
      }
}