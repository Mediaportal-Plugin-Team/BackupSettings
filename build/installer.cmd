@ECHO OFF
CLS

Title Creating BackupSettings Installer

IF "%programfiles(x86)%XXX"=="XXX" GOTO 32BIT
    :: 64-bit
    SET PROGS=%programfiles(x86)%
    GOTO CONT
:32BIT
    SET PROGS=%ProgramFiles%
:CONT

IF NOT EXIST "%PROGS%\Team MediaPortal\MediaPortal\" SET PROGS=C:

:: Get version from DLL
FOR /F "tokens=*" %%i IN ('..\Tools\Tools\sigcheck.exe /accepteula /nobanner /n "..\BackupSettings\BackupSettingsMP\BackupSettingsMP\bin\Release\BackupSettingsMP.dll"') DO (SET version=%%i)

:: Temp xmp2 file
COPY ..\MPEI\BackupSettings.xmp2 ..\MPEI\BackupSettingsTemp.xmp2

:: Build MPE1
CD ..\MPEI
"%PROGS%\Team MediaPortal\MediaPortal\MPEMaker.exe" BackupSettingsTemp.xmp2 /B /V=%version% /UpdateXML
CD ..\build

:: Cleanup
DEL ..\MPEI\BackupSettingsTemp.xmp2
