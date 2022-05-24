Import-Module PSReadLine

Invoke-Expression (&starship init powershell)

# auto suggestions
Set-PSReadLineOption -PredictionSource History
# Tab completion
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

Function which {
    Get-Command -ShowCommandInfo $args | Format-Table -Property Definition
}

Set-Alias -Name e -Value explorer.exe
Set-Alias -Name vi -Value vim
Set-Alias -Name wg -Value winget
Set-Alias -Name tig -Value "C:\Program Files\Git\usr\bin\tig.exe"
