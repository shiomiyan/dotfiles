# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# ==================================
#  Custom Script on Windows machine
# ==================================

# Show path to command
function local:which {
     Get-Command -ShowCommandInfo $args | %{ $_.Definition }
}

# WSL feature switcher
function local:Switch-WslFeature {
    Param (
        [Parameter(Mandatory=$True)]
        [String]$status
    )

    $command = ""
    if ($status -eq "enable") {
        $command = "`
            dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart; `
            dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart"
        $color = "Green"
    } elseif ($status -eq "disable") {
        $command = "`
            Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName Microsoft-Windows-Subsystem-Linux; `
            Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName VirtualMachinePlatform"
        $color = "Red"
    } else {
        return
    }

    Start-Process -Wait -WindowStyle Hidden -Verb RunAs powershell.exe -Args "-executionpolicy bypass -command Set-Location \`"$PWD\`"; $command"

    # WSL feature is $status after reboot.
    Write-Host "WSL feature is " -NoNewline
    Write-Host $status -ForegroundColor $color -NoNewline
    Write-Host " after reboot."
}

# fzf style cd
function cdfz {
    Set-Location (Get-Item $(fzf)).Directory.FullName
}

function local:Invoke-GhqSetLocation {
    $ghq_root = $(ghq root)
    $repo = $(ghq list | fzf)
    Set-Location $(join-path $ghq_root $repo)
}

function local:firefox {
    Start-Process -FilePath "C:\Program Files\Mozilla Firefox\firefox.exe"
}

# ==================================
#  Aliases
# ==================================

Set-Alias -Name e -Value explorer.exe
Set-Alias -Name tig -Value "C:\Program Files\Git\usr\bin\tig.exe"
Set-Alias -Name wslfeature -Value Switch-WslFeature
Set-Alias -Name repo -Value Invoke-GhqSetLocation
Set-Alias -Name ff -Value firefox
