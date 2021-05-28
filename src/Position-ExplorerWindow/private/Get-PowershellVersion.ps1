function Get-PowershellVersion {
    [CmdletBinding()]
    param (
        [switch]
        $Major
    )

    if ($Major) {
        $PSVersionTable.PSVersion.Major
    }else {
        $PSVersionTable.PSVersion
    }
}
