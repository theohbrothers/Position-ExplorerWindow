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

Q: Help! When I right-click the script and click *'Run with Powershell'*, it opens and closes in a split second. What's going on?
- You probably are seeing a *red colored error message* in the window just before it disappears. You need to allow the execution of unverified scripts. Open Powershell as administrator, type `Set-ExecutionPolicy Unrestricted -Force` and press ENTER. Try running the script again. You can easily restore the security setting back by using `Set-ExecutionPolicy Undefined -Force`.

Q: I want to open multiple sets of windows quickly. How do I do that?
- Simply make a copy of the usage script above for each set of *Explorer* windows you want to open. Configure each script with a set of `$Paths`. Keep the scripts on your Desktop. You can now easily run those scripts, by right-clicking and selecting *'Run with Powershell'*.
Alternatively, as seen in this demo, you can *pin Powershell onto your Taskbar*, then *pin those scripts* by dragging and dropping over the Powershell on the Taskbar. Now you can easily run them by right-clicking on Powershell, and clicking the script.
![Pin Demo](https://github.com/theohbrothers/Position-ExplorerWindow/raw/master/images/pin-demo.gif "Demo of Position-ExplorerWindow")

Q: Help! the Taskbar is overlapping some of my Explorer windows!
- You are probably an advanced user, using `$ModeEasy = 0`. A Taskbar with a single row of icons is often 40 pixels high (if at top or bottom) or 62 pixels wide (if at left or right). So:
    > If your Taskbar is on the **bottom**, reduce the `$DestinationScreenHeight` by 40. <br />
    If your Taskbar is on the **top**, reduce the `DestinationScreenHeight` by 40, and increase `$OffsetTop` by 40. <br />
    If your Taskbar is on the **left**, reduce the `DestinationScreenWidth` by 62, and increase `$OffsetLeft` by 62.  <br />
    If your Taskbar is on the **right**, reduce the `DestinationScreenWidth` by 62, and reduce `$OffsetLeft` by 62.
    >
    p.s. If your Taskbar is has *two or more rows* of icons, then change the above by multiples of 40 or 62.

Q: Help! Upon running the script I am getting an error <code>'File C:\...Position-ExplorerWindow.ps1 cannot be loaded because the execution of scripts is disabled on this system. Please see "get-help about_signing" for more details.'</code>
- You need to allow the execution of unverified scripts. Open Powershell as administrator, type <code>Set-ExecutionPolicy Unrestricted -Force</code> and press ENTER. Try running the script again. You can easily restore the security setting back by using <code>Set-ExecutionPolicy Undefined -Force</code>.

Q: Help! Upon running the script I am getting an error <code>File C:\...Position-ExplorerWindows.ps1 cannot be loaded. The file C:\...\Position-ExplorerWindows.ps1 is not digitally signed. You cannot run this script on the current system. For more information about running scripts and setting execution policy, see about_Execution_Policies at http://go.microsoft.com/fwlink/?LinkID=135170.</code>
- You need to allow the execution of unverified scripts. Open Powershell as administrator, type <code>Set-ExecutionPolicy Unrestricted -Force</code> and press ENTER. Try running the script again. You can easily restore the security setting back by using <code>Set-ExecutionPolicy Undefined -Force</code>.

Q: Help! Upon running the script I am getting a warning <code>'Execution Policy change. The execution policy helps protect you from scripts that you do not trust. Changing the execution policy might expose you to the security risks described in the about_Execution_Policies help topic at http://go.microsoft.com/?LinkID=135170. Do you want to change the execution policy?</code>
- You need to allow the execution of unverified scripts. Type <code>Y</code> for yes and press enter. You can easily restore the security setting back opening Powershell as administrator, and using the code <code>Set-ExecutionPolicy Undefined -Force</code>.

## Background

An `Explorer` window cannot be opened at a specified coordinate on the screen through its command line. Because the author could not find any working solution that could conveniently open multiple Explorer windows in specified folders arranged in a predictable and orderly fashion on the screen, there had to be a tool that could do this.
