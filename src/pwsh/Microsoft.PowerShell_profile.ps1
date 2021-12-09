Invoke-Expression (&starship init powershell)

fnm env --use-on-cd | Out-String | Invoke-Expression

Set-Alias -Name ls -Value lsd
Set-Alias -Name e -Value explorer.exe
Set-Alias -Name vi -Value vim
Set-Alias -Name tig -Value "C:\Program Files\Git\usr\bin\tig.exe"
