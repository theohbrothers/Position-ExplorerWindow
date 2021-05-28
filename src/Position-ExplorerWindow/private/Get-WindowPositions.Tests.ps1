$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-WindowPositions" -Tag 'Unit' {

    Context 'Behavior' {

        It "Determines windows positioned on the 'M' monitor in 'X' flow" {
            $params = @{
                Paths = @(
                    'c:/foo/1',
                    'c:/foo/2',
                    'c:/foo/3',
                    'c:/foo/4',
                    'c:/foo/5',
                    'c:/foo/6',
                    'c:/foo/7',
                    'c:/foo/8'
                )
                NumMonitors = 1
                Rows = 4
                Cols = 2
                DestinationScreenWidth = 1920
                DestinationScreenHeight = 1080
                OffsetLeft = 0
                OffsetTop = 0
                Flow = 'X'
            }

            $windowPositions = Get-WindowPositions @params 6>$null

            # Expect same number of WindowPosition objects as the number of given paths
            $windowPositions.Count | Should -Be $params['paths'].Count

            # Expect WindowPosition values to be correct
            $expectedWidth = [Math]::Floor($params['DestinationScreenWidth'] / $params['Cols'])
            $expectedHeight = [Math]::Floor($params['DestinationScreenHeight'] / $params['Rows'])
            for ($i = 0; $i -lt $windowPositions.Count; $i++) {
                $windowPositions[$i]['path'] | Should -Be $params['paths'][$i]
                $windowPositions[$i]['width'] | Should -Be $expectedWidth
                $windowPositions[$i]['height'] | Should -Be $expectedHeight
                $windowPositions[$i]['left'] | Should -Be (0 + $params['OffsetLeft'] + ($expectedWidth * ($i % $params['Cols'])))
                $windowPositions[$i]['top'] | Should -Be (0 + $params['OffsetHeight'] + ($expectedHeight * [Math]::Floor(($i / $params['Cols']))))
            }
        }

        It "Determines windows positioned on the 'M' monitor in 'Y' flow" {
            $params = @{
                Paths = @(
                    'c:/foo/1',
                    'c:/foo/2',
                    'c:/foo/3',
                    'c:/foo/4',
                    'c:/foo/5',
                    'c:/foo/6',
                    'c:/foo/7',
                    'c:/foo/8'
                )
                NumMonitors = 1
                Rows = 4
                Cols = 2
                DestinationScreenWidth = 1920
                DestinationScreenHeight = 1080
                OffsetLeft = 0
                OffsetTop = 0
                Flow = 'Y'
            }

            $windowPositions = Get-WindowPositions @params 6>$null

            # Expect same number of WindowPosition objects as the number of given paths
            $windowPositions.Count | Should -Be $params['paths'].Count

            # Expect WindowPosition values to be correct
            $expectedWidth = [Math]::Floor($params['DestinationScreenWidth'] / $params['Cols'])
            $expectedHeight = [Math]::Floor($params['DestinationScreenHeight'] / $params['Rows'])
            for ($i = 0; $i -lt $windowPositions.Count; $i++) {
                $windowPositions[$i]['path'] | Should -Be $params['paths'][$i]
                $windowPositions[$i]['width'] | Should -Be $expectedWidth
                $windowPositions[$i]['height'] | Should -Be $expectedHeight
                $windowPositions[$i]['left'] | Should -Be (0 + $params['OffsetLeft'] + ($expectedWidth * [Math]::Floor(($i / $params['Rows']))))
                $windowPositions[$i]['top'] | Should -Be (0 + $params['OffsetHeight'] + ($expectedHeight * ($i % $params['Rows'])))
            }
        }

        It "Determines windows positioned on the 'L' monitor in 'Y' flow" {
            $params = @{
                Paths = @(
                    'c:/foo/1',
                    'c:/foo/2',
                    'c:/foo/3',
                    'c:/foo/4',
                    'c:/foo/5',
                    'c:/foo/6',
                    'c:/foo/7',
                    'c:/foo/8'
                )
                NumMonitors = 2
                DestinationMonitor = 'L'
                MainMonitorWidth = 1920
                MainMonitorHeight = 1080
                Rows = 4
                Cols = 2
                DestinationScreenWidth = 1920
                DestinationScreenHeight = 1080
                OffsetLeft = 0
                OffsetTop = 0
                Flow = 'Y'
            }

            $windowPositions = Get-WindowPositions @params 6>$null

            # Expect same number of WindowPosition objects as the number of given paths
            $windowPositions.Count | Should -Be $params['paths'].Count

            # Expect WindowPosition values to be correct
            $expectedWidth = [Math]::Floor($params['DestinationScreenWidth'] / $params['Cols'])
            $expectedHeight = [Math]::Floor($params['DestinationScreenHeight'] / $params['Rows'])
            for ($i = 0; $i -lt $windowPositions.Count; $i++) {
                $windowPositions[$i]['path'] | Should -Be $params['paths'][$i]
                $windowPositions[$i]['width'] | Should -Be $expectedWidth
                $windowPositions[$i]['height'] | Should -Be $expectedHeight
                $windowPositions[$i]['left'] | Should -Be (0 + $params['OffsetLeft'] - $params['DestinationScreenWidth'] + ($expectedWidth * [Math]::Floor(($i / $params['Rows']))))
                $windowPositions[$i]['top'] | Should -Be (0 + $params['OffsetHeight'] + ($expectedHeight * ($i % $params['Rows'])))
            }
        }

        It "Determines windows positioned on the 'R' monitor in 'Y' flow" {
            $params = @{
                Paths = @(
                    'c:/foo/1',
                    'c:/foo/2',
                    'c:/foo/3',
                    'c:/foo/4',
                    'c:/foo/5',
                    'c:/foo/6',
                    'c:/foo/7',
                    'c:/foo/8'
                )
                NumMonitors = 2
                DestinationMonitor = 'R'
                MainMonitorWidth = 1920
                MainMonitorHeight = 1080
                Rows = 4
                Cols = 2
                DestinationScreenWidth = 1920
                DestinationScreenHeight = 1080
                OffsetLeft = 0
                OffsetTop = 0
                Flow = 'Y'
            }

            $windowPositions = Get-WindowPositions @params 6>$null

            # Expect same number of WindowPosition objects as the number of given paths
            $windowPositions.Count | Should -Be $params['paths'].Count

            # Expect WindowPosition values to be correct
            $expectedWidth = [Math]::Floor($params['DestinationScreenWidth'] / $params['Cols'])
            $expectedHeight = [Math]::Floor($params['DestinationScreenHeight'] / $params['Rows'])
            for ($i = 0; $i -lt $windowPositions.Count; $i++) {
                $windowPositions[$i]['path'] | Should -Be $params['paths'][$i]
                $windowPositions[$i]['width'] | Should -Be $expectedWidth
                $windowPositions[$i]['height'] | Should -Be $expectedHeight
                $windowPositions[$i]['left'] | Should -Be (0 + $params['OffsetLeft'] + $params['MainMonitorWidth'] + ($expectedWidth * [Math]::Floor(($i / $params['Rows']))))
                $windowPositions[$i]['top'] | Should -Be (0 + $params['OffsetHeight'] + ($expectedHeight * ($i % $params['Rows'])))
            }
        }

        It "Determines windows positioned on the 'T' monitor in 'Y' flow" {
            $params = @{
                Paths = @(
                    'c:/foo/1',
                    'c:/foo/2',
                    'c:/foo/3',
                    'c:/foo/4',
                    'c:/foo/5',
                    'c:/foo/6',
                    'c:/foo/7',
                    'c:/foo/8'
                )
                NumMonitors = 2
                DestinationMonitor = 'T'
                MainMonitorWidth = 1920
                MainMonitorHeight = 1080
                Rows = 4
                Cols = 2
                DestinationScreenWidth = 1920
                DestinationScreenHeight = 1080
                OffsetLeft = 0
                OffsetTop = 0
                Flow = 'Y'
            }

            $windowPositions = Get-WindowPositions @params 6>$null

            # Expect same number of WindowPosition objects as the number of given paths
            $windowPositions.Count | Should -Be $params['paths'].Count

            # Expect WindowPosition values to be correct
            $expectedWidth = [Math]::Floor($params['DestinationScreenWidth'] / $params['Cols'])
            $expectedHeight = [Math]::Floor($params['DestinationScreenHeight'] / $params['Rows'])
            for ($i = 0; $i -lt $windowPositions.Count; $i++) {
                $windowPositions[$i]['path'] | Should -Be $params['paths'][$i]
                $windowPositions[$i]['width'] | Should -Be $expectedWidth
                $windowPositions[$i]['height'] | Should -Be $expectedHeight
                $windowPositions[$i]['left'] | Should -Be (0 + $params['OffsetLeft'] + ($expectedWidth * [Math]::Floor(($i / $params['Rows']))))
                $windowPositions[$i]['top'] | Should -Be (0 + $params['OffsetHeight'] - $params['MainMonitorHeight'] + ($expectedHeight * ($i % $params['Rows'])))
            }

        }

        It "Determines windows positioned on the 'B' monitor in 'Y' flow" {
            $params = @{
                Paths = @(
                    'c:/foo/1',
                    'c:/foo/2',
                    'c:/foo/3',
                    'c:/foo/4',
                    'c:/foo/5',
                    'c:/foo/6',
                    'c:/foo/7',
                    'c:/foo/8'
                )
                NumMonitors = 2
                DestinationMonitor = 'B'
                MainMonitorWidth = 1920
                MainMonitorHeight = 1080
                Rows = 4
                Cols = 2
                DestinationScreenWidth = 1920
                DestinationScreenHeight = 1080
                OffsetLeft = 0
                OffsetTop = 0
                Flow = 'Y'
            }

            $windowPositions = Get-WindowPositions @params 6>$null

            # Expect same number of WindowPosition objects as the number of given paths
            $windowPositions.Count | Should -Be $params['paths'].Count

            # Expect WindowPosition values to be correct
            $expectedWidth = [Math]::Floor($params['DestinationScreenWidth'] / $params['Cols'])
            $expectedHeight = [Math]::Floor($params['DestinationScreenHeight'] / $params['Rows'])
            for ($i = 0; $i -lt $windowPositions.Count; $i++) {
                $windowPositions[$i]['path'] | Should -Be $params['paths'][$i]
                $windowPositions[$i]['width'] | Should -Be $expectedWidth
                $windowPositions[$i]['height'] | Should -Be $expectedHeight
                $windowPositions[$i]['left'] | Should -Be (0 + $params['OffsetLeft'] + ($expectedWidth * [Math]::Floor(($i / $params['Rows']))))
                $windowPositions[$i]['top'] | Should -Be (0 + $params['OffsetHeight'] + $params['MainMonitorHeight'] + ($expectedHeight * ($i % $params['Rows'])))
            }

        }

    }

}
