function Position-ExplorerWindow {
    <#
    .SYNOPSIS
    Opens, resizes, and arranges multiple Explorer Windows at specified paths in a grid fashion to fit a screen, or multiple screens.

    .DESCRIPTION
    Opens, resizes, and arranges multiple Explorer Windows at specified paths in a grid fashion to fit a screen, or multiple screens.

    .PARAMETER Paths
    # Defines the paths (folders) the Explorer windows should show.

    .PARAMETER ModeEasy
    # Simple Mode. In this mode, most defaults are used.
    # If you hate configurations, simply use this with -Paths

    .PARAMETER DestinationScreenWidth
    # Resolution of the Destination Screen (think of this as block of pixels, and not necesarily a Monitor's resolution) where the Explorer windows will reside.
    # For Single-Monitor setups, in most cases should match your Monitor's resolution.
    # For Multi-Monitor setups, you may also think of this a pooling of a block of pixels spanning your screen(s). You may use 3840 x 1080 to pool multiple monitor pixels together, or use 640 x 480 to select a smaller pool

    .PARAMETER DestinationScreenHeight
    # Resolution of the Destination Screen (think of this as block of pixels, and not necesarily a Monitor's resolution) where the Explorer windows will reside.
    # For Single-Monitor setups, in most cases should match your Monitor's resolution.
    # For Multi-Monitor setups, you may also think of this a pooling of a block of pixels spanning your screen(s). You may use 3840 x 1080 to pool multiple monitor pixels together, or use 640 x 480 to select a smaller pool

    .PARAMETER DestinationMonitor
    # Physical position of the Destination Monitor where the Explorer windows will open
    # NOTE:
    #  This is ignored if you have only 1 monitor.
    # Possible values: 'M', L', 'R', 'T', 'B'
    # E.g. 'M' - Destination Monitor is the Main Monitor
    # E.g. 'L' - Destination Monitor is to the left of the Main Monitor
    # E.g. 'R' - Destination Monitor is to the right of the Main Monitor
    # E.g. 'T' - Destination Monitor is to the top of the Main Monitor
    # E.g. 'B' - Destination Monitor is to the bottom of the Main Monitor
    # Default: 'M'

    .PARAMETER Rows
    # Define the number of rows of Explorer instances
    # E.g. 4 - a maximum of four explorer instances will be stacked vertically in a column. The 5th-8th windows will be stacked on the next column to the right of the previous column. And so on.
    # Default: 4

    .PARAMETER Cols
    # Define the number of columns of Explorer instances
    # If a value greater than 1 is specified, columns of x windows will stack horizontally (where x is a defined in $Rows)
    # E.g. A value of 2 means that 2 columns of x explorer instances will be stacked horizontally
    # Default: 2

    .PARAMETER OffsetLeft
    # How many pixels left/right the Explorer instances should be shifted from the Top-Left Corner(0,0) of the Destination Monitor. Useful in the case of multiple-monitor setups.
    # Best to be left as default (left-most of Destination screen)
    # E.g. Single Monitor setups:
    #         0 positions the windows on the Main monitor, starting from its leftmost edge
    # E.g. Multi-Monitor setups:
    #         0 positions the windows on the Destination monitor, starting from its leftmost edge.
    #         x the windows the windows on the Destination Monitor, x pixels right of its leftmost edge.
    #         -x positions the windows on the Destination Monitor, x pixels left of its leftmost edge.
    # Default: 0

    .PARAMETER OffsetTop
    # How many pixels up/down the Explorer instances should be shifted from the Top-Left Corner(0,0) of the Destination Monitor. Useful in the case of multiple-monitor setups.
    # Best to be left as default (The very top of destination screen)
    # E.g. Single Monitor setups:
    #         0 positions the windows on the Main monitor, starting from its topmost edge
    # E.g. Multi-Monitor setups:
    #         0 positions the windows on the Destination monitor, starting from its topmost edge.
    #         y the windows the windows on the Destination Monitor, x pixels down of its topmost edge.
    #         -y positions the windows on the Destination Monitor, x pixels up of its topmost edge.
    # Default: 0

    .PARAMETER Flow
    # Arrangement of Explorer Windows
    # Whether windows should flow left-to-right, or top-down fashion
    # 'X' - Left-to-Right fashion.
    #       ---------
    #       | 1 | 2 |
    #       ---------
    #       | 3 | 4 |
    #       ---------
    # 'Y' - Top-Down fashion
    #       ---------
    #       | 1 | 3 |
    #       ---------
    #       | 2 | 4 |
    #       ---------
    # Default: 'Y'

    .EXAMPLE
    Example 1a: This opens 4 windows: all 4 windows stacked vertically, occupying a total of half your Main full-HD Screen.
    Position-ExplorerWindow -paths @('D:\My Data Folder\Data1', 'D:\My Data Folder\Data2', '\\MYSERVER\public', '\\192.168.0.1\share') -DestinationScreenWidth 1920 -DestinationScreenHeight 1080 -DestinationMonitor 'M' -Rows 4 -Cols 2 -Flow 'Y'

    Example 1b: This is the same as Example 1, except instead of stacking vertically, windows flow in a zig-zag fashion: the first 2 windows are stacked horizontally in one row, then the next 2 are stacked horintally on the next row below. Each window's width is 1/2 the screen's width, and height 1/4 the screen's height.
    Position-ExplorerWindow -paths @('D:\My Data Folder\Data1', 'D:\My Data Folder\Data2', '\\MYSERVER\public', '\\192.168.0.1\share') -DestinationScreenWidth 1920 -DestinationScreenHeight 1080 -DestinationMonitor 'M' -Rows 4 -Cols 2 -Flow 'X'

    Example 2: This opens 4 windows: 3 windows stacked vertically on the left half of your Main full-HD Screen, and 1 window on the top occupying 1/3 of the right half of your Main full-HD Screen.
    Position-ExplorerWindow -paths @('D:\My Data Folder\Data1', 'D:\My Data Folder\Data2', '\\MYSERVER\public', '\\192.168.0.1\share') -DestinationScreenWidth 1920 -DestinationScreenHeight 1080 -DestinationMonitor 'M' -Rows 3 -Cols 2 -OffsetLeft 0 -OffsetTop 0 -Flow 'X'

    Example 3: This is the same as Example 1a, except the windows are on your Left Monitor.
    Position-ExplorerWindow -paths @('D:\My Data Folder\Data1', 'D:\My Data Folder\Data2', '\\MYSERVER\public', '\\192.168.0.1\share') -DestinationScreenWidth 1920 -DestinationScreenHeight 1080 -DestinationMonitor 'L' -Rows 4 -Cols 2 -Flow 'Y'

    Example 4: This is the same as Example 2, except the windows are on your Right Monitor.
    Position-ExplorerWindow -paths @('D:\My Data Folder\Data1', 'D:\My Data Folder\Data2', '\\MYSERVER\public', '\\192.168.0.1\share') -DestinationScreenWidth 1920 -DestinationScreenHeight 1080 -DestinationMonitor 'R' -Rows 3 -Cols 2 -OffsetLeft 0 -OffsetTop 0 -Flow 'X'

    Example 5: This is a nice hack if you have 2 screens. You want the windows to span two screens, rather than being confined to a single screen.
                Assumes your second screen is to the left of your Main Monitor.
                This will open 4 windows: 2 your Left Monitor, 2 on your Main monitor,  arranged horizontally, each taking up 1/2 the width and 1/2 the height of each screen
    Position-ExplorerWindow -paths @('D:\My Data Folder\Data1', 'D:\My Data Folder\Data2', '\\MYSERVER\public', '\\192.168.0.1\share') -DestinationScreenWidth 3840 -DestinationScreenHeight 1080 -DestinationMonitor 'L' -Rows 2 -Cols 4 -OffsetLeft 1920 -OffsetTop 0 -Flow 'X'

    Example 6: This is a nice hack if you have 3 screens. You want the windows to span three screens, rather than being confined to a single screen.
                Assumes your second screen is to the left of your Main Monitor, and the third is to the right of your Main Monitor.
                This will open 6 windows: There will be on the first row, 2 windows your Left Monitor, 2 on your Main monitor, 2 on your Right Monitor, arranged horizontally, each taking up 1/3 the width and 1/3 the height of each screen
    Position-ExplorerWindow -paths @('D:\My Data Folder\Data1', 'D:\My Data Folder\Data2', 'D:\My Data Folder\Data3', 'D:\My Data Folder\Data\', '\\MYSERVER\public', '\\192.168.0.1\share') -DestinationScreenWidth 5760 -DestinationScreenHeight 1080 -DestinationMonitor 'L' -Rows 3 -Cols 3 -OffsetLeft 3840 -OffsetTop 0 -Flow 'X'


    .NOTES
    ################################################################################################################################
    # Dependencies:                                                                                                                #
    # - UIAutomation PS module: https://uiautomation.codeplex.com/wikipage?title=Getting%20a%20window&referringTitle=Documentation #
    ################################################################################################################################
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$False,Position=0)]
        [switch]$ModeEasy
    ,
        [Parameter(Mandatory=$True,Position=1)]
        [String[]]$Paths
    ,
        [Parameter(Mandatory=$False,Position=2)]
        #[ValidateRange(640, [int]::MaxValue)]
        [Int]$DestinationScreenWidth
    ,
        [Parameter(Mandatory=$False,Position=3)]
        #[ValidateRange(360, [int]::MaxValue)]
        [Int]$DestinationScreenHeight
    ,
        [Parameter(Mandatory=$False,Position=4)]
        [ValidateSet('M', 'L', 'R', 'T', 'B')]
        [String]$DestinationMonitor = 'M'
    ,
        [Parameter(Mandatory=$False,Position=5)]
        #[ValidateRange(1, [int]::MaxValue)]
        [Int]$Rows = 4
    ,
        [Parameter(Mandatory=$False,Position=6)]
        #[ValidateRange(1, [int]::MaxValue)]
        [Int]$Cols = 2
    ,
        [Parameter(Mandatory=$False,Position=7)]
        #[ValidateRange(0, [int]::MaxValue)]
        [Int]$OffsetLeft = 0
    ,
        [Parameter(Mandatory=$False,Position=8)]
        #[ValidateRange(0, [int]::MaxValue)]
        [Int]$OffsetTop = 0
    ,
        [Parameter(Mandatory=$False,Position=9)]
        [ValidateSet('X', 'Y')]
        [String]$Flow = 'Y'
    )

    begin {
        # NOTE: No longer using UIAutomation Module.
        # Import Dependency - UIAutomation Module
        # try {
        #    Import-Module UIAutomation -ErrorAction Stop
        #    [UIAutomation.Preferences]::HighlightParent = $False
        #    [UIAutomation.Preferences]::Highlight = $False
        # }catch {
        #    throw $_.Exception.Message
        # }
    }
    process {
        try {
            # Validate powershell version
            if ((Get-PowershellVersion -Major) -gt 5) {
                throw "Module is only supported on Powershell v5 or lower."
            }

            # Validate paths
            foreach ($path in $paths) {
                if (! (Test-Path $path) ) {
                    Write-Warning "Path $path does not exist. Ignoring path." -ErrorAction Continue
                }
            }
            if ($Paths.Count -gt ($Rows * $Cols)) {
                throw "Number of paths is greater than rows*cols ($Rows*$Cols). Increase the number of rows and columns."
            }

            # Get all main monitors resolution
            # Doesn't work for Windows 7 PSv2
            #$mainMonitor = Get-Wmiobject Win32_Videocontroller
            #$mainMonitorWidth = $mainMonitor.CurrentHorizontalResolution
            #$mainMonitorHeight = $mainMonitor.CurrentVerticalResolution

            # Get all main monitors resolution
            # From: https://stackoverflow.com/questions/7967699/get-screen-resolution-using-wmi-powershell-in-windows-7/7968063#7968063
            # The returned screen objects appears to be in order of the physical position of the monitors, from left to right,
            #  regardless of what the monitor's ID in Control Panel's / Settings 'Identify' feature shows.
            if (Add-Type -AssemblyName System.Windows.Forms -PassThru) {
                $screens = @(
                    Get-AllScreens
                )
            }else {
                throw "Failed to load assembly: System.Windows.Forms"
            }

            # Detect get the Main Monitor's resolution
            "`n[Detecting Main Monitor Resolution]" | Write-Verbose
            $mainMonitor = $screens | Where-Object { $_.Primary } | Select-Object -First 1
            if (!$mainMonitor) {
                $DestinationScreenWidth = $mainMonitorWidth = 1920
                $DestinationScreenHeight = $mainMonitorHeight = 1080
                Write-Warning "Unable to auto-detect main monitor's resolution. Assuming 1920 x 1080."
            }else {
                # Use working area instead of bounds
                #$mainMonitorWidth = $mainMonitor.Bounds.Width
                #$mainMonitorHeight = $mainMonitor.Bounds.Height
                $mainMonitorWidth = $mainMonitor.WorkingArea.Width
                $mainMonitorHeight = $mainMonitor.WorkingArea.Height
                "Main Monitor Resolution: $mainMonitorWidth x $mainMonitorHeight" | Write-Verbose

                # In simple mode, consider the destination screen (i.e. pixel pool) to be the same as the main monitor's resolution
                if ($ModeEasy) {
                    $DestinationScreenWidth = $mainMonitorWidth
                    $DestinationScreenHeight = $mainMonitorHeight
                }
            }

            # Determine number of monitors
            $numMonitors = if ($screens) { $screens.Count } else { 1 }
            # Doesn't work on Windows 7 PSv2
            #$numMonitors = (Get-WmiObject WmiMonitorID -Namespace root\wmi).Count

            "[Position-ExplorerWindow options]" | Write-Verbose
            "Paths: " | Write-Verbose
            $Paths | ForEach-Object { " $($_.Trim())" } | Write-Verbose
            "DestinationScreenWidth: $DestinationScreenWidth" | Write-Verbose
            "DestinationScreenHeight: $DestinationScreenHeight" | Write-Verbose
            "DestinationMonitor: $DestinationMonitor" | Write-Verbose
            "Rows: $Rows" | Write-Verbose
            "Cols: $Cols" | Write-Verbose
            "ForegroundColor: $OffsetLeft" | Write-Verbose
            "OffsetTop: $OffsetTop" | Write-Verbose
            "Flow: $Flow" | Write-Verbose

            # Determine the Window Group Starting Position, each window's dimension
            "`n[Calculating Window Group Starting Position, each window's dimension]" | Write-Verbose

            $params = @{
                Paths = $Paths
                NumMonitors = $NumMonitors
                DestinationMonitor = $DestinationMonitor
                MainMonitorWidth = $mainMonitorWidth
                MainMonitorHeight = $mainMonitorHeight
                Rows = $Rows
                Cols = $Cols
                DestinationScreenWidth = $DestinationScreenWidth
                DestinationScreenHeight = $DestinationScreenHeight
                OffsetLeft = $OffsetLeft
                OffsetTop = $OffsetTop
                Flow = $Flow
            }
            $windowPositions = Get-WindowPositions @params
            foreach ($windowPosition in $windowPositions) {
                # Path count
                "[Opening Windows]" | Write-Verbose

                # Debug
                "My Coordinates (left, top): ($( $windowPosition['left'] ), $( $windowPosition['top'] )))" | Write-Verbose
                "My Dimensions (width, height): $( $windowPosition['width'] ) x $( $windowPosition['height'] )" | Write-Verbose

                # We are going to use difference objects of explorer.exe

                #################
                # Start-Process #
                #################
                # Start-Process: https://ss64.com/ps/start-process.html
                # explorer.exe: https://ss64.com/nt/explorer.html
                # Note: A newly started explorer.exe subsequently spawns a child explorer.exe before killing itself.
                # Start a new explorer.exe process and get its pid
                "Starting Explorer process..." | Write-Verbose
                $parent = Start-Process -FilePath explorer -ArgumentList "/separate,`"$( $windowPosition['path'] )`"" -PassThru
                $parentPid = $parent.Id

                # Skip over this path if we didn't get a newly started explorer.exe
                if (!$parentPid) {
                    Write-Warning "Could not find parent explorer.exe. Skipping."
                    continue
                }

                # Get the explorer processes before launching
                "Getting Explorer processes..." | Write-Verbose

                # Skip over this path if we didn't get any explorer instances.
                $processesPrev = Get-Process -Name explorer -ErrorAction SilentlyContinue
                if (!$processesPrev) {
                    Write-Warning "Could not find parent explorer.exe. Skipping.";
                    continue
                }
                $processesPrev | Format-Table | Out-String | % { $_.Trim() } | Write-Verbose

                # Get the pid of the spawned child explorer.exe. This is achieved by getting a diff-object of explorer.exe processes until we find the spawned child's pid
                "Getting spawned child process..." | Write-Verbose

                # Loop count
                $childPid = $null
                $loopCount = 0
                $SleepMilliseconds = 10
                while ($null -eq $childPid) {
                    $loopCount++

                    # Get explorer processes after starting the new explorer process
                    "`t`tGetting Explorer processes..." | Write-Verbose
                    $processesAfter = Get-Process -Name explorer -ErrorAction SilentlyContinue
                    $processesAfter | Format-Table | Out-String | Write-Verbose

                    # Get the child process id from the difference object between two collections of explorer.exe
                    # E.g.
                    #  Loop 0: $NULL
                    #  Loop 1: 7972
                    $diff = Compare-Object $processesPrev $processesAfter -Property Id  | Where-Object { $_.SideIndicator -eq '=>'} | Select-Object -First 1
                    if ($diff) {
                        $childPid = $diff.Id
                    }
                    "`t`t >Diff: $childPid" | Write-Verbose

                    # Successfully found a child process id. Print a message
                    if ($childPid) {
                        "`tWe took $loopCount loops to get the child process id: $childPid" | Write-Verbose
                        "`tWe found the child process" | Write-Verbose
                    }else {
                        Start-Sleep -Milliseconds $SleepMilliseconds

                        # Stop looping if we can't find it
                        if ($loopCount -eq 100) {
                            "We took too many loops($loopCount) and $( $loopCount * $SleepMilliseconds )ms and to find the child explorer process." | Write-Verbose
                            break
                        }
                    }
                }

                if ($childPid) {
                    # Give some time before positioning and resizing window
                    Start-Sleep -Milliseconds 100

                    # Try and reposition and resize Window
                    "`tRepositioning and Resizing window..." | Write-Verbose

                    $success = Position-ResizeWindow -ProcessId $childPid -Left $windowPosition['left'] -Top $windowPosition['top'] -Width $windowPosition['width'] -Height $windowPosition['height']
                    if ($success) {
                        "`tSuccessfully repositioned and resized window." | Write-Verbose

                        # increment cursor
                        $i++
                    }else {
                        Write-Warning "Failed to reposition and resize window. The window is not movable or not resizable."
                    }
                }else {
                    Write-Warning "Could not find a child explorer.exe instance. Unable to position and resize a new Explorer window for path: $Path"
                }
            } # End paths loop
        }catch {
            if ($ErrorActionPreference -eq 'Stop') {
                throw
            }else {
                Write-Error -ErrorRecord $_
            }
        }
    }
    # End process #
}
