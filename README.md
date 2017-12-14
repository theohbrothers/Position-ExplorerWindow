# Position-Explorer-Window

Opens, resizes, and arranges multiple `Explorer` windows at specified paths in a *grid* fashion to fit a screen, or multiple screens.

## Requirements:
- Windows environment
- Powershell v2
- [UIAutomation Powershell Module](https://uiautomation.codeplex.com/releases/view/125358 "UIAutomation Powershell Module Download")
    - [.NET Framework 3.5](https://www.microsoft.com/en-sg/download/details.aspx?id=21 "Microsoft .NET Framework 3.5 Download")

## Demo
![Demo](https://github.com/leojonathanoh/Position-Explorer-Window/raw/master/images/preview-demo.gif "Demo of Position-Explorer-Window")

## How to use
`Position-Explorer-Window` can be used as a *script*, or a *module*.
### As a Script
This is the simplest method.
1. Open `Position-Explorer-Window.ps1` in your favourite text editor and edit the script settings at the very top. If you hate configuration, be sure to add the paths, and then to set `$ModeEasy` to `1`:

    ```powershell
    # Enter one path per line. Edit between the @' and '@
    $Paths = @'
    D:\My Data Folder\Data1
    D:\My Data Folder\Data2
    D:\My Data Folder\Data3
    D:\My Data Folder\Data4
    \\MYSERVER\public
    \\192.168.0.1\\share
    ....
    ....
    '@

    # Easy Mode
    # If you hate configurations, simply set this to 1, and forget about everything below
    # 0 - Easy mode OFF
    # 1 - Easy mode ON
    # Default: 1
    $ModeEasy = 1
    ```


2. Run the script: Right click on the script in `Explorer` and select <code>Run with Powershell</code>. (should be present on Windows 7 and up). Alternatively, open `Command Prompt` in the script directory, and run <code>Powershell .\Position-Explorer-Window.ps1</code>

3. You can now make copies of the script, each with its own *set* of `Explorer` windows you want to open.

### As a Module
This method is only for advanced users.
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
Because of the pipelining nature of `Powershell`, the `stdout` is used for returning objects. To capture streams that output the script's progress, capture them with `*>&1` operator:
```powershell
# If using as a module
Position-Explorer-Window -ConfigAsString $myConfig -Verbose *>&1 | Out-File -FilePath ./output.log

# If using as a script
Powershell .\Position-Explorer-Window.ps1 *>&1 > output.log
```

## FAQ 
### WinNT
Q: I want to open multiple sets of windows quickly. How do I do that?
- Simply make copies of this script for each set of `Explorer` windows you want to open. Configure each script with a set of `$Paths`. Keep the scripts on your Desktop. You can now easily run those scripts, by right-clicking and selecting *Run with Powershell*.
Alternatively, as seen in this demo, you can *pin Powershell onto your Taskbar*, then *pin those scripts* by dragging and dropping over the Powershell on the Taskbar. Now you can easily run them by right-clicking on Powershell, and clicking the script. 
![Pin Demo](https://github.com/leojonathanoh/Position-Explorer-Window/raw/master/images/pin-demo.gif "Demo of Position-Explorer-Window")
    

Q: Help! I am getting an error <code>'File C:\...Position-Explorer-Window.ps1 cannot be loaded because the execution of scripts is disabled on this system. Please see "get-help about_signing" for more details.'</code>
- You need to allow the execution of unverified scripts. Open Powershell as administrator, type <code>Set-ExecutionPolicy Unrestricted -Force</code> and press ENTER. Try running the script again. You can easily restore the security setting back by using <code>Set-ExecutionPolicy Undefined -Force</code>.

Q: Help! Upon running the script I am getting a warning <code>'Execution Policy change. The execution policy helps protect you from scripts that you do not trust. Changing the execution policy might expose you to the security risks described in the about_Execution_Policies help topic at http://go.microsoft.com/?LinkID=135170. Do you want to change the execution policy?</code>
- You need to allow the execution of unverified scripts. Type <code>Y</code> for yes and press enter. You can easily restore the security setting back opening Powershell as administrator, and using the code <code>Set-ExecutionPolicy Undefined -Force</code>.

Q: Help! While running a script, an I am getting an error `import-module : Could not load file or assembly 'file:///C:\Users\user\Documents\WindowsPowerShell\Modules\UIAutomation\UIAutomation.dll' or one of its dependencies.
Operation is not supported. (Exception from HRESULT: 0x80131515)`
- You need to install [.NET Framework 3.5](https://www.microsoft.com/en-sg/download/details.aspx?id=21 "Microsoft .NET Framework 3.5 Download"), which is required by the `UIAutomation` module that this script relies on. Once installed, try again.
## Known issues
- Nil

## Background
An `Explorer` window cannot be opened at a specified coordinate on the screen through its command line. Because the author could not find any working solution that could conveniently open multiple Explorer windows in specified folders arranged in a predictable and orderly fashion on the screen, there had to be a tool that could do this.