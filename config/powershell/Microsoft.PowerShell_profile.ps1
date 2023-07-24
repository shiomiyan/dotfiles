# Command only works for Windows machine
if ($PSVersionTable.Platform -eq "Win32NT") {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

    # Import custom script for Windows
    Import-Module Windows
}

Import-Module PSReadLine

Invoke-Expression (&starship init powershell)
Invoke-Expression (& {
    (zoxide init --hook pwd powershell | Out-String)
})
$prompt = ""
function Invoke-Starship-PreCommand {
    $current_location = $executionContext.SessionState.Path.CurrentLocation
    if ($current_location.Provider.Name -eq "FileSystem") {
        $ansi_escape = [char]27
        $provider_path = $current_location.ProviderPath -replace "\\", "/"
        $prompt = "$ansi_escape]7;file://${env:COMPUTERNAME}/${provider_path}$ansi_escape\"
    }
    $host.ui.Write($prompt)
}

# Command completions
try {
    if (Get-Command gh -ErrorAction SilentlyContinue) {
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
