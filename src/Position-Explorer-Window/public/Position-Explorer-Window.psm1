$MODULE_BASE_DIR = Split-Path $MyInvocation.MyCommand.Path -Parent

# Get-ChildItem "$MODULE_BASE_DIR/classes/*.ps1" -Exclude *.Tests.ps1 | % {
#     . $_.FullName
# }

# Get-ChildItem "$MODULE_BASE_DIR/helpers/*.ps1" -Exclude *.Tests.ps1 | % {
#     . $_.FullName
# }

Get-ChildItem "$MODULE_BASE_DIR/private/*.ps1" -Exclude *.Tests.ps1 | % {
    . $_.FullName
}

Get-ChildItem "$MODULE_BASE_DIR/public/*.ps1" -Exclude *.Tests.ps1 | % {
    . $_.FullName
}
