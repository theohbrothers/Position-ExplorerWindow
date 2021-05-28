function Get-WindowPositions {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string[]]$Paths
    ,
        [Parameter(Mandatory=$true)]
        [int]$NumMonitors
    ,
        [Parameter(Mandatory=$false)]
        [string]$DestinationMonitor
    ,
        [Parameter(Mandatory=$false)]
        [int]$MainMonitorWidth
    ,
        [Parameter(Mandatory=$false)]
        [int]$MainMonitorHeight
    ,
        [Parameter(Mandatory=$false)]
        [int]$Rows
    ,
        [Parameter(Mandatory=$false)]
        [int]$Cols
    ,
        [Parameter(Mandatory=$false)]
        [int]$DestinationScreenWidth
    ,
        [Parameter(Mandatory=$false)]
        [int]$DestinationScreenHeight
    ,
        [Parameter(Mandatory=$false)]
        [int]$OffsetLeft
    ,
        [Parameter(Mandatory=$false)]
        [int]$OffsetTop
    ,
        [Parameter(Mandatory=$true)]
        [string]$Flow
    ,
        [Parameter(Mandatory=$false)]
        [int]$DebugLevel
    )

    process {
        if (! (($Flow -eq 'X') -or ($Flow -eq 'Y')) ) {
            throw "Flow must be 'X' or 'Y'."
        }

        # Determine Window Group Starting Position - Get (x,y) coordinates, where the origin (0,0) is the Top-Left Corner of the Main Monitor
        if ($numMonitors -eq 1) {
            # Single-Monitor
            # Calculate left
            $left = 0 + $OffsetLeft

            # Calculate top
            $top = 0 + $OffsetTop
        }elseif ($numMonitors -gt 1) {
            # Multi-Monitor
            switch ($DestinationMonitor) {
                'M' {
                    # Its just like Single-Monitor
                    # Calculate left
                    $left = 0 + $OffsetLeft

                    # Calculate top
                    $top = 0 + $OffsetTop
                }
                'L' {
                    # Calculate left
                    $left = 0 - $DestinationScreenWidth + $OffsetLeft

                    # Calculate top
                    $top = 0 + $OffsetTop
                }
                'R' {
                    # Calculate left
                    $left = 0 + $MainMonitorWidth + $OffsetLeft

                    # Calculate top
                    $top = 0 + $OffsetTop

                }
                'T' {
                    # Calculate left
                    $left = 0 + $OffsetLeft

                    # Calculate top
                    $top = 0 - $DestinationScreenHeight + $OffsetTop
                }
                'B' {
                    # Calculate left
                    $left = 0 + $OffsetLeft

                    # Calculate top
                    $top = 0 + $MainMonitorHeight + $OffsetTop
                }
                default {
                    throw "Invalid monitor'. Specify one of the following: 'M', 'L', 'R', 'T', 'B'"
                }
            }
        }
        # Ensure they are integers, or UIAutomation won't position them correctly
        $left = [math]::Floor($left)
        $top = [math]::Floor($top)

        # Determine each window's dimension
        $my_width = [math]::Floor( $DestinationScreenWidth / $Cols )   # e.g. 1920 / 2
        $my_height = [math]::Floor( $DestinationScreenHeight / $Rows ) # e.g. 1080 / 4
        "NOTE: Origin (0, 0) is the Top-Left Corner of your Main Monitor." | Write-Verbose
        "Starting Coordinates (left, top): ($left, $top)" | Write-Verbose
        "Window Dimensions (width x height): $my_width x $my_height" | Write-Verbose

        # WindowPosition collection
        $windowPositions = @()
        $c = 0 # Flow Cursor
        $my_left = $left
        $my_top = $top
        foreach ($path in $Paths) {
            # WindowPosition Configuration object
            $windowPosition = @{
                path = $path
                width = $my_width
                height = $my_height
            }

            # Determine window position
            switch ($Flow) {
                'Y' {
                    'Flow is Y. Calculating coordinates for this window...' | Write-Verbose
                    # Top-Down
                    # If reached max number of rows: reset the cursor to Starting Position y coordinate, and get next left position
                    if ($c -eq $Rows) {
                        $c = 0
                        $my_left += $my_width
                    }
                    $my_top = $top + ($my_height * $c)
                }
                'X' {
                   'Flow is Y. Calculating coordinates for this window...' | Write-Verbose
                    # Left-to-Right
                    # If reached max number of cols: reset the cursor to Starting Position x coordinate, and get next top position
                    if ($c -eq $Cols) {
                        $c = 0
                        $my_top += $my_height
                    }
                    $my_left = $left + ($my_width * $c)
                }
            }

            # Populate the object
            $windowPosition['left'] = $my_left
            $windowPosition['top'] = $my_top

            # Add it to our collection
            $windowPositions += $windowPosition

            $c++
        }

        # Return the collection
        ,$windowPositions
    }
}
