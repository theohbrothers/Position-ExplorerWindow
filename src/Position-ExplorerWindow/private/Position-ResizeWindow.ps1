function Position-ResizeWindow {
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
    Add-Type '
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
    '

    # Keep trying to move the window until we are successful.
    if ($DebugLevel -band 1) { Write-Host "`t`tAttempting to move window......" -ForegroundColor Yellow }
    $x = 0
    while (!$result) {
        $SleepMilliseconds = 10
        $x++

        # Get et the process handle
        $handle = (Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.Id -eq $ProcessId } | Select-Object -First 1).MainWindowHandle
        if ($handle) {
            # Debug
            if ($DebugLevel -band 1) {
                Write-Host "`t`Getting window handle......" -ForegroundColor Yellow
                Write-Host "`t`tProcessId: $ProcessId handle: $handle"
                $window = New-Object RECT
                $client = New-Object RECT
                [Win32]::GetWindowRect($handle, [ref]$window) | Out-Null
                [Win32]::GetClientRect($handle, [ref]$client) | Out-Null
                Write-Host "`t`twindow Left: $($window.Left), Top: $($window.Top), Right: $($window.Right), Bottom: $($window.Bottom)"
                Write-Host "`t`tclient Left: $($client.Left), Top: $($client.Top), Right: $($client.Right), Bottom: $($client.Bottom)"
            }

            # Draw it once far away, then draw it on its location. This makes the flicker less apparent
            $result = [Win32]::MoveWindow($handle, $Left, ($Top - 10000), $Width, $Height, $true) -and [Win32]::MoveWindow($handle, $Left, $Top, $Width, $Height, $true)
            if ($result) {
                # Successfully moved and sized window
                return $true
            }

            # Stop looping if we failed too many times
            if ($x -gt 100) {
                if ($DebugLevel -band 1) {
                    Write-Host "We took too many loops($x) and $( $x * $SleepMilliseconds )ms to position and resize a window." -ForegroundColor Yellow
                }
                break
            }
        }
        Start-Sleep -Milliseconds $SleepMilliseconds
    }
    if (!$result) {
        Write-Host "Failed to get window handle! Loop count: $x"
    }

    $false
}
