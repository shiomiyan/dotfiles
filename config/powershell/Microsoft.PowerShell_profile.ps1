# load windows specific modules on windows
if ($PSVersionTable.Platform -eq "Win32NT") {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    Import-Module Windows
}

Import-Module PSReadLine

# starship
if (Get-Command starship -errorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
    $Env:STARSHIP_LOG = "error"
}

# zoxide

if (Get-Command zoxide -errorAction SilentlyContinue) {
    Invoke-Expression (& {
        (zoxide init --hook pwd powershell | Out-String)
    })
}

Set-PSReadlineOption -BellStyle None # No more beep
Set-PSReadlineOption -HistoryNoDuplicates
Set-PSReadLineOption -PredictionSource History # Auto suggestions
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete # Show Tab completion menu
Set-PSReadLineKeyHandler -Key Ctrl+n -Function TabCompleteNext
Set-PSReadLineKeyHandler -Key Ctrl+p -Function TabCompletePrevious
