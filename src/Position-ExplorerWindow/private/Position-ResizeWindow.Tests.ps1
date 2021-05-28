$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Position-ResizeWindow" -Tag 'Unit' {

    Context 'Behavior' {

        $params = @{
            ProcessId = 123
            Left = 0
            Top = 0
            Width = 999
            Height = 333
            DebugLevel = 0
        }

        It 'Errors without required assemblies' {
            Mock Add-Type { $false }

            { Position-ResizeWindow @params -ErrorAction Stop } | Should -Throw 'Failed to load assemblies: System; System.Runtime.InteropServices'
        }

        It "Keep searching for a process" {
            Mock Add-Type { $true }
            Mock Get-Process {}
            Mock Start-Sleep {}

            Position-ResizeWindow @params

            Assert-MockCalled Start-Sleep -Times 100
        }

    }

}
