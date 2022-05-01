Invoke-Expression (&starship init powershell)

Function which {
    Get-Command -ShowCommandInfo $args | Format-Table -Property Definition
}

Set-Alias -Name e -Value explorer.exe
Set-Alias -Name vi -Value vim
Set-Alias -Name wg -Value winget
Set-Alias -Name tig -Value "C:\Program Files\Git\usr\bin\tig.exe"
