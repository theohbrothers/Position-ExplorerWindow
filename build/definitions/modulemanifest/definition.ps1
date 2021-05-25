# - Initial setup: Fill in the GUID value. Generate one by running the command 'New-GUID'. Then fill in all relevant details.
# - Ensure all relevant details are updated prior to publishing each version of the module.
# - To simulate generation of the manifest based on this definition, run the included development entrypoint script Invoke-PSModulePublisher.ps1.
# - To publish the module, tag the associated commit and push the tag.
@{
    RootModule = 'Position-ExplorerWindow.psm1'
    # ModuleVersion = ''                            # Value will be set for each publication based on the tag ref. Defaults to '0.0.0' in development environments and regular CI builds
    GUID = 'c9a2d63b-d56c-4c11-83ad-60ad86eb7dbd'
    Author = 'The Oh Brothers'
    CompanyName = 'The Oh Brothers'
    Copyright = '(c) 2017 The Oh Brothers'
    Description = 'Opens, resizes, and arranges multiple `Explorer` windows at specified paths in a grid fashion to fit a screen, or multiple screens.'
    PowerShellVersion = '2.0'
    # PowerShellHostName = ''
    # PowerShellHostVersion = ''
    # DotNetFrameworkVersion = ''
    # CLRVersion = ''
    # ProcessorArchitecture = ''
    # RequiredModules = @()
    # RequiredAssemblies = @()
    # ScriptsToProcess = @()
    # TypesToProcess = @()
    # FormatsToProcess = @()
    # NestedModules = @()
    FunctionsToExport = @()
    CmdletsToExport = @(
        'Position-ExplorerWindow'
    )
    VariablesToExport = @()
    AliasesToExport = @()
    # DscResourcesToExport = @()
    # ModuleList = @()
    # FileList = @()
    PrivateData = @{
        # PSData = @{           # Properties within PSData will be correctly added to the manifest via Update-ModuleManifest without the PSData key. Leave the key commented out.
            Tags = @(
                'automation'
                'explorer'
                'grid'
                'module'
                'organization'
                'position'
                'powershell'
                'pwsh'
                'windows'
                'windows-explorer'
            )
            LicenseUri = 'https://raw.githubusercontent.com/theohbrothers/Position-ExplorerWindow/master/LICENSE'
            ProjectUri = 'https://github.com/theohbrothers/Position-ExplorerWindow'
            # IconUri = ''
            # ReleaseNotes = ''
            # Prerelease = ''
            # RequireLicenseAcceptance = $false
            # ExternalModuleDependencies = @()
        # }
        # HelpInfoURI = ''
        # DefaultCommandPrefix = ''
    }
}
