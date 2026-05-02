# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
# chocolaty end

function local:which {
     Get-Command -ShowCommandInfo $args | %{ $_.Definition }
}

Set-Alias -Name e -Value explorer.exe
Set-Alias -Name tig -Value "C:\Program Files\Git\usr\bin\tig.exe"
