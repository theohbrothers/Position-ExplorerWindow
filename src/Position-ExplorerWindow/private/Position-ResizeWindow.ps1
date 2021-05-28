function Position-ResizeWindow {
    [CmdletBinding()]
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

    # NOTE: No longer using UIAutomation Module.
    # Get UIA object from process id, and manipulate its position and size
    #$w = Get-UiaWindow -ProcessId $processId
    #if ($w.CanMove -and $w.CanResize) {
    #    $w.move($left, $top) | Out-Null
    #    $w.Resize($width, $height) | Out-Null
    #    $True
    #}

    # Using PInvoke:
    # http://www.pinvoke.net/default.aspx/user32.getwindowrect
    # http://www.pinvoke.net/default.aspx/user32.getclientrect
    # http://www.pinvoke.net/default.aspx/user32.movewindow
    # https://gist.github.com/coldnebo/1148334
    $added = Add-Type '
        using System;
        using System.Runtime.InteropServices;

        public class Win32 {
            [DllImport("user32.dll")]
            [return: MarshalAs(UnmanagedType.Bool)]
            public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

            [DllImport("user32.dll")]
            [return: MarshalAs(UnmanagedType.Bool)]
            public static extern bool GetClientRect(IntPtr hWnd, out RECT lpRect);

            [DllImport("user32.dll")]
            [return: MarshalAs(UnmanagedType.Bool)]
            public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
        }

        public struct RECT
        {
            public int Left;        // x position of upper-left corner
            public int Top;         // y position of upper-left corner
            public int Right;       // x position of lower-right corner
            public int Bottom;      // y position of lower-right corner
        }
    ' -PassThru

    if (!$added) {
        throw "Failed to load assemblies: System; System.Runtime.InteropServices"
    }

    # Keep trying to move the window until we are successful.
    "`t`tAttempting to move window......" | Write-Verbose
    $result = $null
    $loopCount = 0
    $SleepMilliseconds = 10
    while (!$result) {
        $loopCount++

        # Get the process handle
        $process = Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.Id -eq $ProcessId } | Select-Object -First 1
        if ($process) {
            $handle = $process.MainWindowHandle

            # Debug
            "`t`Getting window handle......" | Write-Verbose
            "`t`tProcessId: $ProcessId handle: $handle" | Write-Verbose
            $window = New-Object RECT
            $client = New-Object RECT
            [Win32]::GetWindowRect($handle, [ref]$window) > $null
            [Win32]::GetClientRect($handle, [ref]$client) > $null
            "`t`twindow Left: $($window.Left), Top: $($window.Top), Right: $($window.Right), Bottom: $($window.Bottom)" | Write-Verbose
            "`t`tclient Left: $($client.Left), Top: $($client.Top), Right: $($client.Right), Bottom: $($client.Bottom)" | Write-Verbose

            # Draw it once far away, then draw it on its location. This makes the flicker less apparent
            $result = [Win32]::MoveWindow($handle, $Left, ($Top - 10000), $Width, $Height, $true) -and [Win32]::MoveWindow($handle, $Left, $Top, $Width, $Height, $true)
            if ($result) {
                # Successfully moved and sized window
                return $true
            }
        }

        Start-Sleep -Milliseconds $SleepMilliseconds

        # Stop looping if we failed too many times
        if ($loopCount -eq 100) {
            "We took too many loops ($loopCount) and $( $loopCount * $SleepMilliseconds )ms to position and resize a window." | Write-Verbose
            break
        }
    }
    if (!$result) {
        "Failed to get window handle! Loop count: $loopCount" | Write-Verbose
    }

    $false
}
