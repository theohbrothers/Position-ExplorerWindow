# Position-Explorer-Window

Opens, resizes, and arranges multiple `Explorer` windows at specified paths in a *grid* fashion to fit a screen, or multiple screens.

## Requirements:
- Windows 7 and up
- Powershell v2

## Demo
![Demo](https://github.com/leojonathanoh/Position-Explorer-Window/raw/master/images/preview-demo.gif "Demo of Position-Explorer-Window")

## Usage

### As a Module

1. [Install](https://msdn.microsoft.com/en-us/library/dd878350(v=vs.85).aspx) the `Position-Explorer-Window.psm1` module into **any** of the following directories:
    ```powershell
    %Windir%\System32\WindowsPowerShell\v1.0\Modules

    %UserProfile%\Documents\WindowsPowerShell\Modules

    %ProgramFiles%\WindowsPowerShell\Modules
    ```


2. Import the module, then pipe the config into the module:
    ```powershell
    Import-Module Position-Explorer-Window

    # Build the params
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
    # Call with params splatting
    Position-Explorer-Window @params
    ```

## Advanced information
### Module Command line
```powershell
SYNTAX
    Position-Explorer-Window [[-ModeEasy] <Int32>] [-Paths] <String[]> [[-DestinationScreenWidth] <Int32>] [[-DestinationScreenHeight] <Int32>] [[-DestinationMonitor] <String>] [[-Rows] <Int32>] [[-Cols]
    <Int32>] [[-OffsetLeft] <Int32>] [[-OffsetTop] <Int32>] [[-Flow] <String>] [[-DebugLevel] <Int32>] [<CommonParameters>]

PARAMETERS
    -ModeEasy <Int32>
        In this mode, most defaults are used.

    -Paths <String[]>
        The paths (folders) the Explorer windows should show.

    -DestinationScreenWidth <Int32>
        Width of resolution of the Destination Screen (think of this as block of pixels, and not necesarily a Monitor's resolution) where the Explorer windows will reside.

    -DestinationScreenHeight <Int32>
        Height of resolution of the Destination Screen (think of this as block of pixels, and not necesarily a Monitor's resolution) where the Explorer windows will reside.

    -DestinationMonitor <String>
        Physical position of the Destination Monitor where the Explorer windows will open

    -Rows <Int32>
        The number of rows of Explorer instances

    -Cols <Int32>
        The number of columns of Explorer instances

    -OffsetLeft <Int32>
        How many pixels left/right the Explorer instances should be shifted from the Top-Left Corner(0,0) of the Destination Monitor. Useful in the case of multiple-monitor setups.

    -OffsetTop <Int32>
        How many pixels up/down the Explorer instances should be shifted from the Top-Left Corner(0,0) of the Destination Monitor. Useful in the case of multiple-monitor setups.

    -Flow <String>
        Arrangement of Explorer Windows: Whether windows should flow left-to-right, or top-down fashion

    -DebugLevel <Int32>
        Debug level

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).
```

### Capturing output
Because of the pipelining nature of `Powershell`, the `stdout` is used for returning objects.
To capture streams that output the script's progress, use `*>&1` operator when calling `Position-Explorer-Window` as a *module*, or `>` when calling `Position-Explorer-Window` as a *script*.
```powershell
# If using as a module
Position-Explorer-Window -ConfigAsString $myConfig -Verbose *>&1 | Out-File -FilePath ./output.log

# If using as a script
Powershell .\Position-Explorer-Window.ps1 > output.log
```

## FAQ

### WinNT
Q: Help! When I right-click the script and click *'Run with Powershell'*, it opens and closes in a split second. What's going on?
- You probably are seeing a *red colored error message* in the window just before it disappears. You need to allow the execution of unverified scripts. Open Powershell as administrator, type `Set-ExecutionPolicy Unrestricted -Force` and press ENTER. Try running the script again. You can easily restore the security setting back by using `Set-ExecutionPolicy Undefined -Force`.

Q: I want to open multiple sets of windows quickly. How do I do that?
- Simply make a copy of this script for each set of *Explorer* windows you want to open. Configure each script with a set of `$Paths`. Keep the scripts on your Desktop. You can now easily run those scripts, by right-clicking and selecting *'Run with Powershell'*.
Alternatively, as seen in this demo, you can *pin Powershell onto your Taskbar*, then *pin those scripts* by dragging and dropping over the Powershell on the Taskbar. Now you can easily run them by right-clicking on Powershell, and clicking the script.
![Pin Demo](https://github.com/leojonathanoh/Position-Explorer-Window/raw/master/images/pin-demo.gif "Demo of Position-Explorer-Window")

Q: Help! the Taskbar is overlapping some of my Explorer windows!
- You are probably an advanced user, using `$ModeEasy = 0`. A Taskbar with a single row of icons is often 40 pixels high (if at top or bottom) or 62 pixels wide (if at left or right). So:
    > If your Taskbar is on the **bottom**, reduce the `$DestinationScreenHeight` by 40. <br />
    If your Taskbar is on the **top**, reduce the `DestinationScreenHeight` by 40, and increase `$OffsetTop` by 40. <br />
    If your Taskbar is on the **left**, reduce the `DestinationScreenWidth` by 62, and increase `$OffsetLeft` by 62.  <br />
    If your Taskbar is on the **right**, reduce the `DestinationScreenWidth` by 62, and reduce `$OffsetLeft` by 62.
    >
    p.s. If your Taskbar is has *two or more rows* of icons, then change the above by multiples of 40 or 62.

Q: Help! Upon running the script I am getting an error <code>'File C:\...Position-Explorer-Window.ps1 cannot be loaded because the execution of scripts is disabled on this system. Please see "get-help about_signing" for more details.'</code>
- You need to allow the execution of unverified scripts. Open Powershell as administrator, type <code>Set-ExecutionPolicy Unrestricted -Force</code> and press ENTER. Try running the script again. You can easily restore the security setting back by using <code>Set-ExecutionPolicy Undefined -Force</code>.

Q: Help! Upon running the script I am getting an error <code>File C:\...Position-Explorer-Windows.ps1 cannot be loaded. The file C:\...\Position-Explorer-Windows.ps1 is not digitally signed. You cannot run this script on the current system. For more information about running scripts and setting execution policy, see about_Execution_Policies at http://go.microsoft.com/fwlink/?LinkID=135170.</code>
- You need to allow the execution of unverified scripts. Open Powershell as administrator, type <code>Set-ExecutionPolicy Unrestricted -Force</code> and press ENTER. Try running the script again. You can easily restore the security setting back by using <code>Set-ExecutionPolicy Undefined -Force</code>.


Q: Help! Upon running the script I am getting a warning <code>'Execution Policy change. The execution policy helps protect you from scripts that you do not trust. Changing the execution policy might expose you to the security risks described in the about_Execution_Policies help topic at http://go.microsoft.com/?LinkID=135170. Do you want to change the execution policy?</code>
- You need to allow the execution of unverified scripts. Type <code>Y</code> for yes and press enter. You can easily restore the security setting back opening Powershell as administrator, and using the code <code>Set-ExecutionPolicy Undefined -Force</code>.

## Known issues
- Nil

## Background
An `Explorer` window cannot be opened at a specified coordinate on the screen through its command line. Because the author could not find any working solution that could conveniently open multiple Explorer windows in specified folders arranged in a predictable and orderly fashion on the screen, there had to be a tool that could do this.
