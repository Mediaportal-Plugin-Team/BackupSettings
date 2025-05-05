@ECHO OFF
CLS

Title Building BackupSettings (RELEASE)

REM *************************************************************************
REM DEFINE VARIABLES
REM *************************************************************************
REM 

IF NOT "%1"=="" (
  SET ARCH=%1
) ELSE (
  SET ARCH=x86
)

for /f "tokens=*" %%a in ('git rev-list HEAD --count') do set REVISION=%%a 
set REVISION=%REVISION: =%

SET OLDVERSION=1.3.0.999
SET NEWVERSION=1.3.0.%REVISION%

REM Select program path based on current machine environment
SET progpath=%ProgramFiles%
IF NOT "%ProgramFiles(x86)%".=="". SET progpath=%ProgramFiles(x86)%

REM Define MSbuild path
SET MSFRAMEPATH=%progpath%\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe
IF NOT EXIST "%MSFRAMEPATH%" SET MSFRAMEPATH=%progpath%\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe
IF NOT EXIST "%MSFRAMEPATH%" SET MSFRAMEPATH=%progpath%\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\bin\MSBuild.exe
IF NOT EXIST "%MSFRAMEPATH%" SET MSFRAMEPATH=%progpath%\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\bin\MSBuild.exe

SET FILE_REPLACE=build\FileReplaceString.exe
REM ******************************END VARIABLES******************************

CD ..

REM *************************************************************************
REM Version Update
REM *************************************************************************

%FILE_REPLACE% "BackupSettings\BackupSettingsTV\BackupSettingsTV\BackupSettingsTV.cs" %OLDVERSION% %NEWVERSION%
%FILE_REPLACE% "BackupSettings\BackupSettingsTV\BackupSettingsTV\Properties\AssemblyInfo.cs" %OLDVERSION% %NEWVERSION%
%FILE_REPLACE% "BackupSettings\BackupSettingsTV\BackupSettingsTV\BackupSettingsExportImport.cs" %OLDVERSION% %NEWVERSION%

%FILE_REPLACE% "BackupSettings\BackupSettingsMP\BackupSettingsMP\Properties\AssemblyInfo.cs" %OLDVERSION% %NEWVERSION%

%FILE_REPLACE% "BackupSettings\BackupSettingsMP.exe\BackupSettingsMP.exe\Form1.Designer.cs" %OLDVERSION% %NEWVERSION%
%FILE_REPLACE% "BackupSettings\BackupSettingsMP.exe\BackupSettingsMP.exe\Properties\AssemblyInfo.cs" %OLDVERSION% %NEWVERSION%
%FILE_REPLACE% "BackupSettings\BackupSettingsMP.exe\BackupSettingsMP.exe\BackupSettingsExportImport.cs" %OLDVERSION% %NEWVERSION%

%FILE_REPLACE% "BackupSettings\RestartSetupTV\RestartSetupTV\Properties\AssemblyInfo.cs" %OLDVERSION% %NEWVERSION%

REM ******************** END VERSION UPDATE ********************


REM *************************************************************************
REM Compile ALL
REM *************************************************************************

CD BackupSettings

"%MSFRAMEPATH%" /target:Rebuild /property:Configuration=RELEASE /property:Platform=%ARCH% /fl /flp:logfile=BackupSettings.log;verbosity=diagnostic BackupSettings.sln

REM ******************** END COMPILE  ********************

CD ..

SET CHECKOUT=git checkout

%CHECKOUT% "BackupSettings\BackupSettingsTV\BackupSettingsTV\BackupSettingsTV.cs"
%CHECKOUT% "BackupSettings\BackupSettingsTV\BackupSettingsTV\Properties\AssemblyInfo.cs"
%CHECKOUT% "BackupSettings\BackupSettingsTV\BackupSettingsTV\BackupSettingsExportImport.cs"

%CHECKOUT% "BackupSettings\BackupSettingsMP\BackupSettingsMP\Properties\AssemblyInfo.cs"

%CHECKOUT% "BackupSettings\BackupSettingsMP.exe\BackupSettingsMP.exe\Form1.Designer.cs"
%CHECKOUT% "BackupSettings\BackupSettingsMP.exe\BackupSettingsMP.exe\Properties\AssemblyInfo.cs"
%CHECKOUT% "BackupSettings\BackupSettingsMP.exe\BackupSettingsMP.exe\BackupSettingsExportImport.cs"

%CHECKOUT% "BackupSettings\RestartSetupTV\RestartSetupTV\Properties\AssemblyInfo.cs"

CD build

PAUSE
