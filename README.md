# Position-ExplorerWindow

[![github-actions](https://github.com/theohbrothers/Position-ExplorerWindow/workflows/ci-master-pr/badge.svg)](https://github.com/theohbrothers/Position-ExplorerWindow/actions)
[![github-release](https://img.shields.io/github/v/release/theohbrothers/Position-ExplorerWindow?style=flat-square)](https://github.com/theohbrothers/Position-ExplorerWindow/releases/)
[![powershell-gallery-release](https://img.shields.io/powershellgallery/v/Position-ExplorerWindow?logo=powershell&logoColor=white&label=PSGallery&labelColor=&style=flat-square)](https://www.powershellgallery.com/packages/Position-ExplorerWindow/)

Opens, resizes, and arranges multiple `Explorer` windows at specified paths in a grid fashion to fit a screen, or multiple screens.

![Demo](https://github.com/theohbrothers/Position-ExplorerWindow/raw/master/images/preview-demo.gif "Demo of Position-ExplorerWindow")

## Install

Open [`powershell`](https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/install/installing-windows-powershell?view=powershell-5.1) or [`pwsh`](https://github.com/powershell/powershell#-powershell) and type:

```powershell
Install-Module -Name Position-ExplorerWindow -Repository PSGallery -Scope CurrentUser -Verbose
```

If prompted to trust the repository, hit `Y` and `enter`.

## Usage

```powershell
Import-Module Position-ExplorerWindow

# Simply use -ModeEasy with a list of -Paths
Position-ExplorerWindow -ModeEasy -Paths 'C:/path/to/folder1', 'C:/path/to/folder2', 'C:/path/to/folder3', 'C:/path/to/folder4'
```

## Usage (advanced)

```powershell
Import-Module Position-ExplorerWindow

# Configure to your liking
$params = @{
    'Paths' = 'C:/path/to/folder1', 'C:/path/to/folder2', 'C:/path/to/folder3', 'C:/path/to/folder4', 'D:/path/to/folder1', 'D:/path/to/folder2', 'D:/path/to/folder3', 'D:/path/to/folder4'
    'DestinationScreenWidth' = 1920
    'DestinationScreenHeight' = 1080
    'DestinationMonitor' = 'M'
    'Rows' = 4
    'Cols' = 2
    'OffsetLeft' = 0
    'OffsetTop' = 0
    'Flow' = 'Y'
    'DebugLevel' = 0
}
# Call with params splatting
Position-ExplorerWindow @params
```

Use `Get-Help Position-ExplorerWindow -Detailed` to see many good examples.

## FAQ

Q: System requirements?

- Windows 7 and up
- Powershell v2

Q: I want to open multiple sets of windows quickly. How do I do that?

Simply make a copy of the usage script above for each set of `Explorer` windows you want to open. Configure each script with a set of `Paths`. Keep the scripts on your Desktop. You can now easily run those scripts, by right-clicking and selecting `Run with Powershell`.

Alternatively, as seen in this demo, you can pin `Powershell` onto your Taskbar, then pin your scripts by dragging and dropping over the Powershell on the Taskbar. Now you can easily run them by right-clicking on Powershell, and clicking the script.

![Pin Demo](https://github.com/theohbrothers/Position-ExplorerWindow/raw/master/images/pin-demo.gif "Demo of Position-ExplorerWindow")

Q: Help! the Taskbar is overlapping some of my Explorer windows!

You are probably an advanced user, and are not using `-ModeEasy`. A Taskbar with a single row of icons is often 40 pixels high (if at top or bottom) or 62 pixels wide (if at left or right). So:

- If your Taskbar is on the **bottom**, reduce the `-DestinationScreenHeight` by 40. <br />
- If your Taskbar is on the **top**, reduce the `-DestinationScreenHeight` by 40, and increase `-OffsetTop` by 40. <br />
- If your Taskbar is on the **left**, reduce the `-DestinationScreenWidth` by 62, and increase `-OffsetLeft` by 62.  <br />
- If your Taskbar is on the **right**, reduce the `-DestinationScreenWidth` by 62, and reduce `-OffsetLeft` by 62.


p.s. If your Taskbar is has *two or more rows* of icons, then change the above by multiples of 40 or 62.

Q: Why are there gaps between windows?

It's likely you have Windows Aero active, since it is turned on by default on Windows 7 and above. When Aero is active, a window's dimensions includes window borders and shadow effects. Aero theme makes shadow regions around a window transparent, hence creating "gaps".

## Background

An `Explorer` window cannot be opened at a specified coordinate on the screen through its command line. Because the author could not find any working solution that could conveniently open multiple Explorer windows in specified folders arranged in a predictable and orderly fashion on the screen, there had to be a tool that could do this.
