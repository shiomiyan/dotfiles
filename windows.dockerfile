FROM mcr.microsoft.com/windows:20H2

WORKDIR /users/ContainerAdministrator/

COPY ./src/setup.ps1 .

RUN powershell.exe -executionpolicy bypass ./setup.ps1
