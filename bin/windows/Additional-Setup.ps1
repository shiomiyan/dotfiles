# ==== Keyboard Settings ==== #
# remap CapsLock to Ctrl
$hexified = "00,00,00,00,00,00,00,00,02,00,00,00,1d,00,3a,00,00,00,00,00".Split(',') | % { "0x$_"};
$kbLayout = 'HKLM:\System\CurrentControlSet\Control\Keyboard Layout';
New-ItemProperty -Path $kbLayout -Name "Scancode Map" -PropertyType Binary -Value ([byte[]]$hexified);

# key repeat interval
Set-ItemProperty -LiteralPath "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Value 0
Set-ItemProperty -LiteralPath "HKCU:\Control Panel\Keyboard" -Name "keyboardSpeed" -Value 31


# ==== Optimize Windows services ==== #
$services = @(
    "AxInstSV",
    "tzautoupdate",
    "bthserv",
    "dmwappushservice",
    "MapsBroker",
    "lfsvc",
    "SharedAccess",
    "lltdsvc",
    "AppVClient",
    "NetTcpPortSharing",
    "CscService",
    "PhoneSvc",
    "Spooler",
    "PrintNotify",
    "QWAVE",
    "RmSvc",
    "RemoteAccess",
    "SensorDataService",
    "SensrSvc",
    "SensorService",
    "ShellHWDetection",
    "SCardSvr",
    "ScDeviceEnum",
    "SSDPSRV",
    "WiaRpc",
    "TabletInputService",
    "upnphost",
    "UserDataSvc",
    "UevAgentService",
    "WalletService",
    "FrameServer",
    "stisvc",
    "wisvc",
    "icssvc",
    "WSearch",
    "XblAuthManager",
    "XblGameSave"
) | % { Set-Service $_ -StartupType Disabled }
