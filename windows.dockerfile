FROM mcr.microsoft.com/windows:20H2

WORKDIR /users/ContainerAdministrator/

COPY ./src ./.dotfiles
COPY ./install.ps1 /users/ContainerAdministrator/

RUN powershell.exe -executionpolicy bypass ./install.ps1