function Query-Disks {
    [CmdletBinding(SupportsShouldProcess=$True)]
    Param(
        [Parameter(Mandatory=$true)]
        [string[]]$ComputerName = 'localhost'
    )
    foreach ($comp in $computername) {
        $logfile = "errors.txt"
          write-host "Trying $comp"
       try {
            gwmi win32_logicaldisk -comp $comp -ea stop
      } catch {

        }}
}