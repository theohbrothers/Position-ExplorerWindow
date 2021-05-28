function Get-AllScreens {
    [CmdletBinding()]
    param ()

    [System.Windows.Forms.Screen]::AllScreens
}
