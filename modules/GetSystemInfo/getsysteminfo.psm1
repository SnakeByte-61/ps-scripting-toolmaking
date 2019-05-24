function Get-sbSystemInfo {
    [cmdletbinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$ComputerName,
        [parameter(Mandatory = $false)]
        [validateset('dcom', 'wsman')]
        [string]$Protocol = 'dcom',
        [parameter(Mandatory = $false)]
        [switch]$TryAnotherProtocol = $false
    )

    $sessionoption = New-CimSessionOption -Protocol $Protocol
    $sessionparams = @{
        'ComputerName'  = $ComputerName
        'SessionOption' = $sessionoption
    }

    Write-Verbose "Connecting to $ComputerName on $Protocol"
    $cimsession = New-CimSession  @sessionparams

    Write-Verbose 'Getting BIOS information'
    $cimparams = @{
        'ClassName'  = 'Win32_BIOS'
        'CimSession' = $cimsession
    }
    $bios = Get-CimInstance @cimparams

    Write-Verbose 'Getting OS information'
    $cimparams = @{
        'ClassName'  = 'Win32_OperatingSystem'
        'CimSession' = $cimsession
    }
    $operatingsystem = Get-CimInstance @cimparams

    $bios.SerialNumber
    $operatingsystem.Version

} #function