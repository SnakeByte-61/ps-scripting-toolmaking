function Get-DiskCheck {

    [cmdletbinding(DefaultParameterSetName = "name")]

    Param(
        [Parameter(Position = 0, Mandatory,
            HelpMessage = "Enter a computer name to check",
            ParameterSetName = "name",
            ValueFromPipeline)]
        [Alias("cn")]
        [ValidateNotNullorEmpty()]
        [string[]]$Computername,

        [Parameter(Mandatory,
            HelpMessage = "Enter the path to a text file of computer names",
            ParameterSetName = "file"
        )]
        # You can just use [ValidateScript({if (Test-Path $_)})], but that throw a less friendly error than
        # the below
        [ValidateScript( {
                if (Test-Path $_) {
                    $True
                } else {
                    Throw "Cannot validate path $_"
                }
            })]
        [ValidatePattern("\.txt$")]
        [string]$Path,

        [ValidateRange(10, 50)]
        [int]$Threshhold = 25,

        [ValidateSet("C:", "D:", "E:", "F:")]
        [string]$Drive = "C:",

        [switch]$Test
    )

} #function