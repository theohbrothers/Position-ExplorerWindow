$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Position-ExplorerWindow" {

    Context 'Powershell versions' {

        It "Runs on Powershell <= v5" {
            $paths = @(
                'foo'
                'bar'
            )
            $errorAction = 'Stop'

            if ($PSVersionTable.PSVersion.Major -gt 5) {
                { Position-ExplorerWindow -Paths $paths 3>$null 6>$null -ErrorAction $errorAction } | Should -Throw
            }else {
                { Position-ExplorerWindow -Paths $paths 3>$null 6>$null } | Should -Not -Throw
            }
        }

    }

}
