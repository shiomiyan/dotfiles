Set-ExecutionPolicy RemoteSigned -Scope CurrentUser


Import-Module PSReadLine
Import-Module zoxide


Invoke-Expression (&starship init powershell)

# No more beep
Set-PSReadlineOption -BellStyle None

Set-PSReadlineOption -HistoryNoDuplicates
# Auto suggestions
Set-PSReadLineOption -PredictionSource History
# Show Tab completion menu
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

Function which {
    Get-Command -ShowCommandInfo $args | Format-Table -Property Definition
}

Function wsl-feature {
    param (
        $condition
    )

    if ($condition -eq "enable") {
        dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    }
    elseif ($condition -eq "disable") {
        Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName Microsoft-Windows-Subsystem-Linux
        Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName VirtualMachinePlatform
    }
}

Set-Alias -Name e -Value explorer.exe
Set-Alias -Name vi -Value vim
Set-Alias -Name wg -Value winget
Set-Alias -Name tig -Value "C:\Program Files\Git\usr\bin\tig.exe"
