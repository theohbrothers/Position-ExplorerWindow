$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Position-ExplorerWindow" -Tag 'Unit' {

    Context 'Powershell versions' {

        It 'Runs only on Powershell <= v5' {
            $paths = @(
                'foo'
                'bar'
            )
            $errorAction = 'Stop'

            if ($PSVersionTable.PSVersion.Major -gt 5) {
                { Position-ExplorerWindow -Paths $paths 3>$null 6>$null -ErrorAction $errorAction } | Should -Throw
            }else {
                { Position-ExplorerWindow -Paths $paths 3>$null 6>$null -ErrorAction $errorAction } | Should -Not -Throw
            }
        }

    }

    Context 'Parameters' {

        function Get-PowershellVersion { 5 }
        function Get-WindowPositions {}
        function Add-Type { $true }

        It 'Ignores non-existing paths with a warning' {
            $params = @{
                ModeEasy = $true
                Paths = @(
                    'c:/foo'
                )
            }
            Mock Test-Path { $false }
            Mock Add-Type {}

            $warnings = Position-ExplorerWindow @params 3>&1 2>$null
            $warnings | Should -Match "Path .* does not exist. Ignoring path."
        }

        It 'Validate that number of windows <= of rows * columns' {
            $params = @{
                Paths = 'c:/foo', 'c:/bar'
                Rows = 1
                Cols = 1
            }
            Mock Test-Path { $false }

            { Position-ExplorerWindow @params 3>&1 -ErrorAction Stop } | Should -Throw 'Increase the number of rows and columns.'
        }

    }

    Context 'Behavior' {

        function Get-PowershellVersion { 5 }
        function Get-WindowPositions {}
        function Get-AllScreens {
            # [pscustomobject]@{
            #     Primary = @{
            #         WorkingArea = @{
            #             Width = 1920
            #             Height = 1080
            #         }
            #     }
            # }
        }
        function Position-ResizeWindow {}

        It 'Errors without required assemblies' {
            $params = @{
                ModeEasy = $true
                Paths = @(
                    'c:/foo'
                )
            }
            Mock Test-Path { $true }
            Mock Add-Type { $false }

            { Position-ExplorerWindow @params -ErrorAction Stop } | Should -Throw 'Failed to load assembly: System.Windows.Forms'

        }

        It 'Warns if main monitor resolution is not detected' {
            $params = @{
                ModeEasy = $true
                Paths = @(
                    'c:/foo'
                )
            }
            Mock Add-Type { $true }
            Mock Get-AllScreens {}

            $warnings = Position-ExplorerWindow @params -ErrorAction Stop 2>$null 3>&1 6>$null
            $warnings | Should -Match "Unable to auto-detect main monitor's resolution."
        }

        It "Detects the main monitor's resolution" {
            $params = @{
                ModeEasy = $true
                Paths = @(
                    'c:/foo'
                )
            }
            Mock Add-Type { $true }
            Mock Get-AllScreens {}

            Position-ExplorerWindow @params -ErrorAction Stop 2>$null 3>$null 6>$null

            Assert-MockCalled Get-AllScreens -Times 1
        }

        It 'Determine window positions' {
            $params = @{
                ModeEasy = $true
                Paths = @(
                    'c:/foo'
                )
            }
            Mock Add-Type { $true }
            Mock Get-AllScreens {}
            Mock Get-WindowPositions {}

            Position-ExplorerWindow @params -ErrorAction Stop 2>$null 3>$null 6>$null

            Assert-MockCalled Get-WindowPositions -Times 1
        }

        It 'Starts explorer process' {
            $params = @{
                ModeEasy = $true
                Paths = @(
                    'c:/foo'
                )
            }
            Mock Add-Type { $true }
            Mock Get-AllScreens {}
            Mock Get-WindowPositions {
                $windowPosition = @{
                    Path = 'c:/foo'
                    Width = 1920
                    Height = 1080
                    Top = 0
                    Left = 0
                }
                $windowPosition
            }
            Mock Start-Process {
                # Parent process
                [pscustomobject]@{
                    Id = 123
                }
            }
            Mock Get-Process {}

            Position-ExplorerWindow @params -ErrorAction Stop 2>$null 3>$null 6>$null

            Assert-MockCalled Start-Process -Times 1
        }

        It 'Waits for child explorer process' {
            $params = @{
                ModeEasy = $true
                Paths = @(
                    'c:/foo'
                )
            }
            Mock Add-Type { $true }
            Mock Get-AllScreens {}
            Mock Get-WindowPositions {
                $windowPosition = @{
                    Path = 'c:/foo'
                    Width = 1920
                    Height = 1080
                    Top = 0
                    Left = 0
                }
                $windowPosition
            }
            Mock Start-Process {
                # Parent process
                [pscustomobject]@{
                    Id = 123
                }
            }
            Mock Get-Process {
                [pscustomobject]@{
                    Id = 123
                }
            }
            Mock Compare-Object {}
            Mock Start-Sleep {}

            Position-ExplorerWindow @params -ErrorAction Stop 2>$null 3>$null 6>$null

            Assert-MockCalled Get-Process -Times 100
            Assert-MockCalled Compare-Object -Times 100
            Assert-MockCalled Start-Sleep -Times 100
        }

        It 'Finds child explorer process and resizes window' {
            $params = @{
                ModeEasy = $true
                Paths = @(
                    'c:/foo'
                )
            }
            Mock Add-Type { $true }
            Mock Get-AllScreens {}
            Mock Get-WindowPositions {
                $windowPosition = @{
                    Path = 'c:/foo'
                    Width = 1920
                    Height = 1080
                    Top = 0
                    Left = 0
                }
                $windowPosition
            }
            Mock Start-Process {
                # Parent process
                [pscustomobject]@{
                    Id = 123
                }
            }
            Mock Get-Process {
                [pscustomobject]@{
                    Id = 123
                }
            }
            Mock Compare-Object {
                [pscustomobject]@{
                    Id = 123
                    SideIndicator = '=>'
                }
            }
            Mock Start-Sleep {}
            Mock Position-ResizeWindow {}

            Position-ExplorerWindow @params -ErrorAction Stop 2>$null 3>$null 6>$null

            Assert-MockCalled Compare-Object -Times 1
            Assert-MockCalled Start-Sleep -Times 1
            Assert-MockCalled Position-ResizeWindow -Times 1
        }

    }

}
