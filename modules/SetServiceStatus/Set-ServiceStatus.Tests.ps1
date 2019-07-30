$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Set-ServiceStatus" {
    It "starts BITS" {
        Stop-Service BITS
        $result = Set-ServiceStatus BITS
        $result.status | Should Be 'Running'
    }

    It "starts BITS, skips FAKE" {
        Stop-Service BITS
        $result = Set-ServiceStatus BITS, FAKE
        $result.status | Should Be 'Running'
    }

    it "starts 2 services" {
        Stop-Service BITS, TimeBrokerSvc
        $result = Set-ServiceStatus BITS, TimeBrokerSvc
        $result | Select-Object -First 1 -ExpandProperty Status | Should Be 'Running'
        $result | Select-Object -Last 1 -ExpandProperty Status | Should Be 'Running'
    }

    it "does nothing with already running service" {
        Start-Service BITS
        $result = Set-ServiceStatus BITS
        $result.status | Should Be 'Running'
    }

}
