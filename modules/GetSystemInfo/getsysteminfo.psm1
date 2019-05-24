function Get-sbSystemInfo {
    [cmdletbinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$ComputerName,

        [parameter(Mandatory = $false)]
        [validateset('dcom', 'wsman')]
        [string]$Protocol = 'dcom',

        [parameter(Mandatory = $false)]
        [switch]$TryAnotherProtocol = $false
    )

    BEGIN {}

    PROCESS {

        foreach ($computer in $ComputerName) {
            $sessionoption = New-CimSessionOption -Protocol $Protocol
            $sessionparams = @{
                'ComputerName'  = $computer
                'SessionOption' = $sessionoption
                'ErrorAction'   = 'Stop'
            }

            try {
                Write-Verbose "[PROCESS] Attempting connection to [$computer] on [$Protocol]"
                $cimsession = New-CimSession  @sessionparams

                Write-Verbose "[PROCESS] Getting BIOS information for [$computer]"
                $cimparams = @{
                    'ClassName'  = 'Win32_BIOS'
                    'CimSession' = $cimsession
                }
                $bios = Get-CimInstance @cimparams

                Write-Verbose "[PROCESS] Getting OS information for [$computer]"
                $cimparams = @{
                    'ClassName'  = 'Win32_OperatingSystem'
                    'CimSession' = $cimsession
                }
                $operatingsystem = Get-CimInstance @cimparams

                # Output here in the Try block rather than at the end of Process Block as we don't want spurious
                # ComputerNames appearing if connection fails

                Write-Verbose "[PROCESS] Outputting for [$computer]"
                [PSCustomObject]@{
                    'ComputerName' = $computer
                    'BIOSSerial'   = $bios.SerialNumber
                    'OSVersion'    = $operatingsystem.Version
                }

            } catch {
                Write-Verbose "[PROCESS] Failed to connect to [$computer] on [$Protocol]"
                if ($TryAnotherProtocol) {
                    if ($Protocol -eq 'dcom') {
                        # Specifying "$newprotocol" here because if we re-run with fallback, we don't want to
                        # change "$protocol" itself, as the remaining computers will just run with the fallback
                        # protocol each time, which will invalidate the original protocol selection and possibly
                        # enrage the user.
                        $newprotocol = 'wsman'
                    } else {
                        $newprotocol = 'dcom'
                    } #if protocol
                    $params = @{
                        'ComputerName'       = $computer
                        'Protocol'           = $newprotocol
                        'TryAnotherProtocol' = $false
                    }

                    Get-sbSystemInfo @params
                } #if tryanotherprotocol
            } #trycatch

        } #foreach

    } #process

    END {}

} #function