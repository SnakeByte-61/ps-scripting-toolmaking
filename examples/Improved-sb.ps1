function Get-Disk {
    [CmdletBinding(SupportsShouldProcess = $True)]
    Param(
        [Parameter(Mandatory = $true)]
        [string[]]$ComputerName
    )
    foreach ($comp in $computername) {
        if ($PSCmdlet.ShouldProcess("[$comp]", "Getting Disk Info")) {
            $logfile = "errors.txt"
            Write-Verbose "Trying $comp"
            try {
                Get-CimInstance win32_logicaldisk -comp $comp -ea stop
            } catch {
                $comp | Out-File $logfile -Append
                Write-Verbose "Errors have been logged to $logfile"
            } #trycatch
        } #shouldprocess
    } #foreach
} #function