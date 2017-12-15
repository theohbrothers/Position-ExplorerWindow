#########################################################################################################
# Dependencies:                                                                                       
# UIAutomation PS module: https://uiautomation.codeplex.com/wikipage?title=Installation&referringTitle=Documentation
# - To install it UIAutomation, download the module from that link, extract the contents in the .zip into the folder C:\Users\Me\Documents\WindowsPowerShell\Modules\UiAutomation\
# - The directory structure should now look like:
#    C:\Users\Me\Documents\WindowsPowerShell\Modules\UiAutomation\
#       +-- Castle.Core.dll
#       +-- Castle.Core.xml
#       +-- ....
#       +-- ....
# - Next, install .NET framework 3.5: https://www.microsoft.com/en-sg/download/details.aspx?id=21 (required for UIAutomation)
# - Now, allow execution of Powershell scripts. Open Powershell as Administrator, and paste the following and press ENTER:
#     Set-ExecutionPolicy Bypass -Force
# - Now you're all set.
#########################################################################################################

################################################################## 
#                    Configure script settings                   #
##################################################################

# Defines the paths (folders) the Explorer windows should show.
# Enter one path per line. Edit between the single-quotes.
# E.g.  $Paths = @'
#           D:\My Data Folder\Data1
#           D:\My Data Folder\Data2
#           D:\My Data Folder\Data3
#           D:\My Data Folder\Data4
#           \\MYSERVER\public
#           \\192.168.0.1\\share
#       '@
$Paths = @'
D:\My Data Folder\Data1
D:\My Data Folder\Data2
D:\My Data Folder\Data3
D:\My Data Folder\Data4
\\MYSERVER\public
\\192.168.0.1\\share
'@

# Easy Mode
# If you hate configurations, simply set this to 1, and forget about everything below
# 0 - Easy mode OFF
# 1 - Easy mode ON
# Default: 1
$ModeEasy =  1

#########################
##  Advanced section   ##
#########################
# Any options from this point on are only used when $ModeEasy is 0
# This section is needed for more fine-grained tuning of the number, position, and arrangement of the Explorer Windows.

# Resolution of the Destination Screen (think of this as block of pixels, and not necesarily a Monitor's resolution) where the Explorer windows will reside. 
# For Single-Monitor setups, in most cases should match your Monitor's resolution.
# For Multi-Monitor setups, you may also think of this a pooling of a block of pixels spanning your screen(s). You may use 3840 x 1080 to pool two full-HD monitor pixels together, or use 640 x 480 to select a smaller pool
$DestinationScreenWidth = 1920
$DestinationScreenHeight = 1080

# Physical position of the Destination Monitor where the Explorer windows will start opening in
# NOTE: 
#  This is ignored if you have only 1 monitor.
# Possible values: 'M', L', 'R', 'T', 'B'
# E.g. 'M' - Destination Monitor is the Main Monitor
# E.g. 'L' - Destination Monitor is to the left of the Main Monitor
# E.g. 'R' - Destination Monitor is to the right of the Main Monitor
# E.g. 'T' - Destination Monitor is to the top of the Main Monitor
# E.g. 'B' - Destination Monitor is to the bottom of the Main Monitor
# Default: 'M'
$DestinationMonitor = 'M'

# Define the number of rows of Explorer instances 
# E.g. 4 - a maximum of four explorer instances will be stacked vertically in a column. The 5th-8th windows will be stacked on the next column to the right of the previous column. And so on.
# Default: 4
$Rows = 4

# Define the number of columns of Explorer instances
# If a value greater than 1 is specified, columns of x windows will stack horizontally (where x is a defined in $Rows)
# E.g. A value of 2 means that 2 columns of x explorer instances will be stacked horizontally
# Default: 2
$Cols = 2

# How many pixels left/right the Explorer instances should be shifted from the Top-Left Corner(0,0) of the Destination Monitor. Useful in the case of multiple-monitor setups.
# Best to be left as default (left-most of Destination screen)
# E.g. Single Monitor setups:
#         0 positions the windows on the Main monitor, starting from its leftmost edge
# E.g. Multi-Monitor setups:
#         0 positions the windows on the Destination monitor, starting from its leftmost edge.
#         x the windows the windows on the Destination Monitor, x pixels right of its leftmost edge.
#         -x positions the windows on the Destination Monitor, x pixels left of its leftmost edge.
# Default: 0
$OffsetLeft = 0

# How many pixels up/down the Explorer instances should be shifted from the Top-Left Corner(0,0) of the Destination Monitor. Useful in the case of multiple-monitor setups.
# Best to be left as default (The very top of destination screen)
# E.g. Single Monitor setups:
#         0 positions the windows on the Main monitor, starting from its topmost edge
# E.g. Multi-Monitor setups:
#         0 positions the windows on the Destination monitor, starting from its topmost edge.
#         y the windows the windows on the Destination Monitor, x pixels down of its topmost edge.
#         -y positions the windows on the Destination Monitor, x pixels up of its topmost edge.
# Default: 0
$OffsetTop = 0

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
$Flow = 'Y'

# Debug level
# 0 - Off
# 1 - On
$DebugLevel = 0

###################################################################
function Position-Explorer-Window {
    <#
    .SYNOPSIS
    Opens, resizes, and arranges multiple Explorer Windows at specified paths in a grid fashion to fit a screen, or multiple screens.
    
    .DESCRIPTION
    This script / module has the ability to quickly open multiple Explorer Windows at specified paths in an grid, arranging them to fit a screen, or multiple screens (no limit, really), in a predictable and orderly fashion. 
    All you have to do is to add the folders into the script config, and run the script, and you get a grid of Explorer windows.
    This is most useful when working with half a dozen or more folders simultaneously, because it saves time and effort rearranging and fitting Explorer Windows into a nice and orderly fashion, so that they can be easily accessed.
    
    Background: An Explorer window cannot be opened at a specified coordinate on the screen through its command line. Because the author could not find any working solution that could conveniently open multiple Explorer windows in specified folders arranged in a predictable and orderly fashion on the screen, there had to be a tool that could do this.

    .PARAMETER Paths
    # Defines the paths (folders) the Explorer windows should show.
    # Enter one path per line. Edit between the single-quotes.
    # E.g.  $Paths = '
    #           D:\My Data Folder\Data1
    #           D:\My Data Folder\Data2
    #           D:\My Data Folder\Data3
    #           D:\My Data Folder\Data4
    #           \\MYSERVER\public
    #           \\192.168.0.1\\share
    #       '
    
    .PARAMETER ModeEasy
    # Simple Mode. In this mode, most defaults are used.
    # If you hate configurations, simply set this to 1 and you're done.
    # Default: 0

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
    
    .PARAMETER DebugLevel
    # Debug level
    # 0 - Off
    # 1 - On

    .EXAMPLE
    Example 1a: This opens 4 windows: all 4 windows stacked vertically, occupying a total of half your Main full-HD Screen.
    Position-Explorer-Window -paths @('D:\My Data Folder\Data1', 'D:\My Data Folder\Data2', '\\MYSERVER\public', '\\192.168.0.1\share') -DestinationScreenWidth 1920 -DestinationScreenHeight 1080 -DestinationMonitor 'M' -Rows 4 -Cols 2 -Flow 'Y'
    
    Example 1b: This is the same as Example 1, except instead of stacking vertically, windows flow in a zig-zag fashion: the first 2 windows are stacked horizontally in one row, then the next 2 are stacked horintally on the next row below. Each window's width is 1/2 the screen's width, and height 1/4 the screen's height.
    Position-Explorer-Window -paths @('D:\My Data Folder\Data1', 'D:\My Data Folder\Data2', '\\MYSERVER\public', '\\192.168.0.1\share') -DestinationScreenWidth 1920 -DestinationScreenHeight 1080 -DestinationMonitor 'M' -Rows 4 -Cols 2 -Flow 'X'

    Example 2: This opens 4 windows: 3 windows stacked vertically on the left half of your Main full-HD Screen, and 1 window on the top occupying 1/3 of the right half of your Main full-HD Screen.
    Position-Explorer-Window -paths @('D:\My Data Folder\Data1', 'D:\My Data Folder\Data2', '\\MYSERVER\public', '\\192.168.0.1\share') -DestinationScreenWidth 1920 -DestinationScreenHeight 1080 -DestinationMonitor 'M' -Rows 3 -Cols 2 -OffsetLeft 0 -OffsetTop 0 -Flow 'X'
   
    Example 3: This is the same as Example 1a, except the windows are on your Left Monitor.
    Position-Explorer-Window -paths @('D:\My Data Folder\Data1', 'D:\My Data Folder\Data2', '\\MYSERVER\public', '\\192.168.0.1\share') -DestinationScreenWidth 1920 -DestinationScreenHeight 1080 -DestinationMonitor 'L' -Rows 4 -Cols 2 -Flow 'Y'

    Example 4: This is the same as Example 2, except the windows are on your Right Monitor.
    Position-Explorer-Window -paths @('D:\My Data Folder\Data1', 'D:\My Data Folder\Data2', '\\MYSERVER\public', '\\192.168.0.1\share') -DestinationScreenWidth 1920 -DestinationScreenHeight 1080 -DestinationMonitor 'R' -Rows 3 -Cols 2 -OffsetLeft 0 -OffsetTop 0 -Flow 'X'

    Example 5: This is a nice hack if you have 2 screens. You want the windows to span two screens, rather than being confined to a single screen. 
                Assumes your second screen is to the left of your Main Monitor. 
                This will open 4 windows: 2 your Left Monitor, 2 on your Main monitor,  arranged horizontally, each taking up 1/2 the width and 1/2 the height of each screen
    Position-Explorer-Window -paths @('D:\My Data Folder\Data1', 'D:\My Data Folder\Data2', '\\MYSERVER\public', '\\192.168.0.1\share') -DestinationScreenWidth 3840 -DestinationScreenHeight 1080 -DestinationMonitor 'L' -Rows 2 -Cols 4 -OffsetLeft 1920 -OffsetTop 0 -Flow 'X'

    Example 6: This is a nice hack if you have 3 screens. You want the windows to span three screens, rather than being confined to a single screen. 
                Assumes your second screen is to the left of your Main Monitor, and the third is to the right of your Main Monitor. 
                This will open 6 windows: There will be on the first row, 2 windows your Left Monitor, 2 on your Main monitor, 2 on your Right Monitor, arranged horizontally, each taking up 1/3 the width and 1/3 the height of each screen
    Position-Explorer-Window -paths @('D:\My Data Folder\Data1', 'D:\My Data Folder\Data2', 'D:\My Data Folder\Data3', 'D:\My Data Folder\Data\', '\\MYSERVER\public', '\\192.168.0.1\share') -DestinationScreenWidth 5760 -DestinationScreenHeight 1080 -DestinationMonitor 'L' -Rows 3 -Cols 3 -OffsetLeft 3840 -OffsetTop 0 -Flow 'X'

    
    .NOTES
    ################################################################################################################################
    # Dependencies:                                                                                                                #
    # - UIAutomation PS module: https://uiautomation.codeplex.com/wikipage?title=Getting%20a%20window&referringTitle=Documentation #
    ################################################################################################################################
    #>
    [CmdletBinding()]
	Param(
        [Parameter(Mandatory=$False,Position=0)]
        [int]$ModeEasy = 0
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
	,
        [Parameter(Mandatory=$False,Position=10)]
		#[ValidateRange(0, 1)]
        [Int]$DebugLevel = 0
    )
    
    begin {
        # Import-Module
        try {
            Import-Module UIAutomation -ErrorAction Stop
            [UIAutomation.Preferences]::HighlightParent = $False
            [UIAutomation.Preferences]::Highlight = $False
        }catch {
            throw $_.Exception.Message
        }

        # Error preference
        $callerEA = $ErrorActionPreference
        $ErrorActionPreference = 'Stop'

        # Get all main monitors resolution
        # Doesn't work for Windows 7 PSv2
        #$mainMonitor = Get-Wmiobject Win32_Videocontroller
        #$mainMonitorWidth = $mainMonitor.CurrentHorizontalResolution
        #$mainMonitorHeight = $mainMonitor.CurrentVerticalResolution

        # Get all main monitors resolution
        # From: https://stackoverflow.com/questions/7967699/get-screen-resolution-using-wmi-powershell-in-windows-7/7968063#7968063
        # The returned screen objects appears to be in order of the physical position of the monitors, from left to right, 
        #  regardless of what the monitor's ID in Control Panel's / Settings 'Identify' feature shows.
        Add-Type -AssemblyName System.Windows.Forms
        $screens = [System.Windows.Forms.Screen]::AllScreens
        # Lets get the Main Monitor's resolution
        Write-Host "`n[Detecting Main Monitor Resolution]" -ForegroundColor Cyan
        $mainMonitor = $screens | Where-Object { $_.Primary } | Select-Object -First 1
        if (!$mainMonitor) {
            Write-Warning "Unable to auto-detect main monitor's resolution."
            throw "Unable to auto-detect main monitor's resolution."
        }
        # Use working area instead of bounds
        #$mainMonitorWidth = $mainMonitor.Bounds.Width
        #$mainMonitorHeight = $mainMonitor.Bounds.Height
        $mainMonitorWidth = $mainMonitor.WorkingArea.Width
        $mainMonitorHeight = $mainMonitor.WorkingArea.Height

        Write-Host "Main Monitor Resolution: $mainMonitorWidth x $mainMonitorHeight" -ForegroundColor Green

        # If using simple mode, then consider the destination screen (i.e. pixel pool) to be the same as the main monitor's resolution
        if ($ModeEasy) {
            $DestinationScreenWidth = $mainMonitorWidth
            $DestinationScreenHeight = $mainMonitorHeight
        }
        
        # Determine number of monitors
        $numMonitors = $screens.Count
        # Doesn't work on Windows 7 PSv2
        #$numMonitors = (Get-WmiObject WmiMonitorID -Namespace root\wmi).Count

    }
    process {
        try {
            Write-Host "[Position-Explorer-Window options]" -ForegroundColor Cyan
            Write-Host "Paths: " -ForegroundColor Green
            $Paths | ForEach-Object { Write-Host " $($_.Trim())" -ForegroundColor Green }
            Write-Host "DestinationScreenWidth: $DestinationScreenWidth" -ForegroundColor Green
            Write-Host "DestinationScreenHeight: $DestinationScreenHeight" -ForegroundColor Green
            Write-Host "DestinationMonitor: $DestinationMonitor" -ForegroundColor Green
            Write-Host "Rows: $Rows" -ForegroundColor Green
            Write-Host "Cols: $Cols" -ForegroundColor Green
            Write-Host "ForegroundColor: $OffsetLeft" -ForegroundColor Green
            Write-Host "OffsetTop: $OffsetTop" -ForegroundColor Green
            Write-Host "Flow: $Flow" -ForegroundColor Green
            Write-Host "Debug: $DebugLevel" -ForegroundColor Green

            # Determine the Window Group Starting Position, each window's dimension
            Write-Host "`n[Calculating Window Group Starting Position, each window's dimension]" -ForegroundColor Cyan
            # Determine Window Group Starting Position - Get (x,y) coordinates, where the origin (0,0) is the Top-Left Corner of the Main Monitor
            if ($numMonitors -eq 1) {
                # Single-Monitor
                # Calculate left
                $left = 0 + $OffsetLeft

                # Calculate top
                $top = 0 + $OffsetTop
            }elseif ($numMonitors -gt 1) {
                # Multi-Monitor
                Switch ($DestinationMonitor) {
                    'M' {
                        # Its just like Single-Monitor
                        # Calculate left
                        $left = 0 + $OffsetLeft

                        # Calculate top
                        $top = 0 + $OffsetTop
                    } 
                    'L' {
                        # Calculate left
                        $startingPoint = 0 - $DestinationScreenWidth
                        $left = $startingPoint + $OffsetLeft

                        # Calculate top
                        $top = 0 + $OffsetTop
                    }
                    'R' {
                        # Calculate left
                        $startingPoint = 0 + $mainMonitorWidth
                        $left = $startingPoint + $OffsetLeft

                        # Calculate top
                        $top = 0 + $OffsetTop

                    }
                    'T' {

                        # Calculate left
                        $left = 0 + $OffsetLeft

                        # Calculate top
                        $startingPoint = 0 - $DestinationScreenHeight
                        $top = $startingPoint + $OffsetTop 
                    }
                    'B' {
                        # Calculate left
                        $left = 0 + $OffsetLeft

                        # Calculate top
                        $startingPoint = 0 + $DestinationScreenHeight
                        $top = $startingPoint + $OffsetTop 
                    }
                }
            }
            # Ensure they are integers, or UIAutomation won't position them correctly
            $left = [math]::Round($left)
            $top = [math]::Round($top)

            # Determine each window's dimension
            $my_width = $DestinationScreenWidth / $Cols   # e.g. 1920 / 2
            $my_height = $DestinationScreenHeight / $Rows # e.g. 1080 / 4
            Write-Host "NOTE: Origin (0, 0) is the Top-Left Corner of your Main Monitor." -ForegroundColor Green

            Write-Host "Starting Coordinates (left, top): ($left, $top)" -ForegroundColor Green
            Write-Host "Window Dimensions (width x height): $my_width x $my_height" -ForegroundColor Green

            # Flow Cursor
            $i = 0
            # Path count
            $p = 0
            Write-Host "`n[Opening Windows]" -ForegroundColor Cyan
            $my_left = $left
            $my_top = $top
            foreach ($Path in $Paths) {
                # Debug
                Write-Host "`nPath: $Path" -ForegroundColor Cyan
                $p++

                Try {
                    if (! (Test-Path -Path $Path -ErrorAction Stop)) {
                        Write-Warning "Path does not exist: $Path. Skipping opening a window for this path."
                        continue
                    }
                }Catch {
                    Write-Warning "Invalid path specified: $Path. Illegal charcters used in path. Skipping opening a window for this path."
                    continue
                }

                if ( $p -gt ($Rows * $Cols) ) {
                        Write-Warning "Number of windows exceeded rows*cols = $($Rows*$Cols). Increase the number of rows and columns."
                        Write-Warning "Skipping opening a windows for path: $Path"
                        continue
                }


                # Determine window position
                Switch ($Flow) {
                    'Y' {
                        if ($DebugLevel -band 1) { Write-Host '`tFlow is Y. Calculating coordinates for this window...' }
                        # Top-Down
                        # If reached max number of rows: reset the cursor to Starting Position y coordinate, and get next left position
                        if ($i -eq $Rows) {
                            $i = 0
                                $my_left += $my_width
                        }
                        $my_top = $top + ($my_height * $i)
                    }
                    'X' {
                        if ($DebugLevel -band 1) { Write-Host '`tFlow is Y. Calculating coordinates for this window...' }
                        # Left-to-Right
                        # If reached max number of cols: reset the cursor to Starting Position x coordinate, and get next top position
                        if ($i -eq $Cols) {
                            $i = 0
                            $my_top += $my_height
                        }
                        $my_left = $left + ($my_width * $i)
                    }
                }

                # Debug
                Write-Host "`tMy Coordinates (left, top): ($my_left, $my_top)"
                if ($DebugLevel -band 1) { Write-Host "`tMy Dimensions (width, height): $my_width x $my_height" }

                # We are going to use difference objects of explorer.exe

                #################
                # Start-Process #
                #################
                # Start-Process: https://ss64.com/ps/start-process.html
                # explorer.exe: https://ss64.com/nt/explorer.html
                # Note: A newly started explorer.exe subsequently spawns a child explorer.exe before killing itself. 
                # Start a new explorer.exe process and get its pid
                Write-Host "`tStarting Explorer process..." -ForegroundColor Yellow
                $parent = Start-Process -FilePath explorer -ArgumentList "/separate,`"$Path`"" -PassThru
                $parent_pid = $parent.Id
            
                # Skip over this path if we didn't get a newly started explorer.exe
                if (!$parent_pid) { Write-Warning "Could not find parent explorer.exe. Skipping."; Continue }

                # Get the explorer processes before launching
                Write-Host "`tGetting Explorer processes..." -ForegroundColor Yellow
                $processes_prev = Get-Process explorer
                
                # Skip over this path if we didn't get any explorer instances.
                if (!$processes_prev) { Write-Warning "No explorer.exe instances found. Quitting."; Exit }
                if ($DebugLevel -band 1) { $processes_prev | Format-Table | Out-String | % { Write-Host $_.Trim() } }


                # Get the pid of the spawned child explorer.exe. This is achieved by getting a diff-object of explorer.exe processes until we find the spawned child's pid
                Write-Host "`tGetting spawned child process..." -ForegroundColor Yellow
                
                # Loop count
                $x = 0
                $child_pid = $NULL
                while($child_pid -eq $NULL) {
                    $x++

                    # Get explorer processes after starting the new explorer process
                    if ($DebugLevel -band 1) { Write-Host "`t`tGetting Explorer processes..." -ForegroundColor Yellow }
                    $processes_after = Get-Process explorer
                    if ($DebugLevel -band 1) { $processes_prev | Format-Table | Out-String | Write-Host }

                    # Get the child process id from the difference object between two collections of explorer.exe 
                    # E.g.
                    #  Loop 0: $NULL
                    #  Loop 1: 7972
                    $child_pid = $(Compare-Object $processes_prev $processes_after -Property Id  | Where-Object { $_.sideindicator -eq '=>'}).Id
                    if ($DebugLevel -band 1) { Write-Host "`t`t >Diff: $child_pid" }

                    # Successfully found a child process id. Print a message
                    if ($child_pid) { 
                        if ($DebugLevel -band 1) { Write-Host "`tWe took $x loops to get the child process id: $child_pid" -ForegroundColor Green }
                        Write-Host "`tWe found the child process" -ForegroundColor Green 
                    }

                    $SleepMilliseconds = 10
                    # Stop looping if we can't find it
                    if ($x -gt 100) { 
                        if ($DebugLevel -band 1) { 
                            Write-Host "We took too many loops($x) and $( $x * $SleepMilliseconds )ms and to find the child explorer process." -ForegroundColor Yellow
                        }
                        break 
                    }
                    Start-Sleep -Milliseconds $SleepMilliseconds
                }

                if ($child_pid) {
                    # Give some time before positioning and resizing window
                    Start-Sleep -Milliseconds 100

                    # Try and reposition and resize Window
                    Write-Host "`tRepositioning and Resizing window..." -ForegroundColor Green
                        
                    $success = Position-Resize-Window -ProcessId $child_pid -Left $my_left -Top $my_top -Width $my_width -Height $my_height
                    if ($success) {
                        Write-Host "`tSuccessfully repositioned and resized window." -ForegroundColor Green

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
            Write-Error "Error occured running script: $($_.Exception.Message)" -ErrorAction $CallerEA
        }
    }
    # End process #
}

function Position-Resize-Window {
    Param(
        [Parameter(Mandatory=$True,Position=0)]
		#[ValidateRange(0, [int]::MaxValue)]
        [int]$ProcessId
    ,
        [Parameter(Mandatory=$True,Position=1)]
		#[ValidateRange([int]::MinValue, [int]::MaxValue)]
        [int]$Left
    ,
        [Parameter(Mandatory=$True,Position=2)]
		#[ValidateRange([int]::MinValue, [int]::MaxValue)]
        [int]$Top
    ,
        [Parameter(Mandatory=$True,Position=3)]
		#[ValidateRange([int]::MinValue, [int]::MaxValue)]
        [int]$Width
    ,
        [Parameter(Mandatory=$True,Position=4)]
		#[ValidateRange([int]::MinValue, [int]::MaxValue)]
        [int]$Height
    )

    # Get UIA object from process id, and manipulate its position and size
    $w = Get-UiaWindow -ProcessId $processId
    if ($w.CanMove -and $w.CanResize) {
        $w.move($left, $top) | Out-Null
        $w.Resize($width, $height) | Out-Null  
        $True
    }
    $False
}
<# END MODULE #>

# Split those paths, removing empty entries
$Paths = $Paths.Split("`n`r") | Where-Object { $_.Trim() } 

# Entry point
$params = @{
    'ModeEasy' = $ModeEasy
    'Paths' = $Paths
    'DestinationScreenWidth' = $DestinationScreenWidth
    'DestinationScreenHeight' = $DestinationScreenHeight
    'DestinationMonitor' = $DestinationMonitor
    'Rows' = $Rows
    'Cols' = $Cols
    'OffsetLeft' = $OffsetLeft
    'OffsetTop' = $OffsetTop
    'Flow' = $Flow
    'DebugLevel' = $DebugLevel
}
Position-Explorer-Window @params