# Command only works for Windows machine
if ($PSVersionTable.Platform -eq "Win32NT") {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

    # Import custom script for Windows
    Import-Module winscript
}

Import-Module PSReadLine

Invoke-Expression (&starship init powershell)
Invoke-Expression (& {
    (zoxide init --hook pwd powershell | Out-String)
})

# Command completions
try {
    if (Get-Command gh) {
        Invoke-Expression -Command $(gh completion -s powershell | Out-String)
    }
} catch {}

Set-PSReadlineOption -BellStyle None # No more beep
Set-PSReadlineOption -HistoryNoDuplicates
Set-PSReadLineOption -PredictionSource History # Auto suggestions
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete # Show Tab completion menu
Set-PSReadLineKeyHandler -Key Ctrl+n -Function TabCompleteNext
Set-PSReadLineKeyHandler -Key Ctrl+p -Function TabCompletePrevious
