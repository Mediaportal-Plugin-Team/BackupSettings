REM *************************************************************************
REM DEFINE VARIABLES
REM *************************************************************************
REM 

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

REM SET FILE_REPLACE=..\FileReplaceString.exe
SET FILE_REPLACE=FileReplaceString.exe
REM ******************************END VARIABLES******************************


REM *************************************************************************
REM Version Update
REM *************************************************************************

%FILE_REPLACE% "BackupSettings.Source\BackupSettingsTV\BackupSettingsTV\BackupSettingsTV.cs" %OLDVERSION% %NEWVERSION%
%FILE_REPLACE% "BackupSettings.Source\BackupSettingsTV\BackupSettingsTV\Properties\AssemblyInfo.cs" %OLDVERSION% %NEWVERSION%
%FILE_REPLACE% "BackupSettings.Source\BackupSettingsTV\BackupSettingsTV\BackupSettingsExportImport.cs" %OLDVERSION% %NEWVERSION%

%FILE_REPLACE% "BackupSettings.Source\BackupSettingsMP\BackupSettingsMP\Properties\AssemblyInfo.cs" %OLDVERSION% %NEWVERSION%

%FILE_REPLACE% "BackupSettings.Source\BackupSettingsMP.exe\BackupSettingsMP.exe\Form1.Designer.cs" %OLDVERSION% %NEWVERSION%
%FILE_REPLACE% "BackupSettings.Source\BackupSettingsMP.exe\BackupSettingsMP.exe\Properties\AssemblyInfo.cs" %OLDVERSION% %NEWVERSION%
%FILE_REPLACE% "BackupSettings.Source\BackupSettingsMP.exe\BackupSettingsMP.exe\BackupSettingsExportImport.cs" %OLDVERSION% %NEWVERSION%

%FILE_REPLACE% "BackupSettings.Source\Install\Install\InstallSetup.Designer.cs" %OLDVERSION% %NEWVERSION%
%FILE_REPLACE% "BackupSettings.Source\Install\Install\Properties\AssemblyInfo.cs" %OLDVERSION% %NEWVERSION%

%FILE_REPLACE% "BackupSettings.Source\RestartSetupTV\RestartSetupTV\Properties\AssemblyInfo.cs" %OLDVERSION% %NEWVERSION%

%FILE_REPLACE% BackupSettings.Source\MPEI\BackupSettings.xmp2 %OLDVERSION% %NEWVERSION%

REM ******************** END VERSION UPDATE ********************


REM *************************************************************************
REM Compile ALL
REM *************************************************************************

CD BackupSettings.Source

"%MSFRAMEPATH%" BackupSettingsTV\BackupSettingsTV.sln /p:Configuration=Release

"%MSFRAMEPATH%" BackupSettingsMP\BackupSettingsMP.sln /p:Configuration=Release
"%MSFRAMEPATH%" BackupSettingsMP.exe\BackupSettingsMP.exe.sln /p:Configuration=Release

"%MSFRAMEPATH%" Install\Install.sln /p:Configuration=Release

REM ******************** END COMPILE  ********************


REM *************************************************************************
REM release All
REM *************************************************************************

CD BackupSettings.Source

COPY /Y "Install\Install\bin\Release\Install.exe" "..\BackupSettings.Release\Install.exe"
COPY /Y "RestartSetupTV\RestartSetupTV\bin\Release\RestartSetupTV.exe" "..\BackupSettings.Release\RestartSetupTV.exe"

COPY /Y "BackupSettingsMP\BackupSettingsMP\bin\Release\BackupSettingsMP.dll" "..\BackupSettings.Release\BackupSettingsMP\BackupSettingsMP.dll"
COPY /Y "BackupSettingsMP.exe\BackupSettingsMP.exe\bin\Release\BackupSettingsMP.exe" "..\BackupSettings.Release\BackupSettingsMP.exe"

COPY /Y "BackupSettingsTV\BackupSettingsTV\bin\Release\BackupSettingsTV.dll"    "..\BackupSettings.Release\BackupSettingsTV\BackupSettingsTV.dll"

REM ******************** END RELEASE ********************

CD ..

SET CHECKOUT=git checkout

%CHECKOUT% "BackupSettings.Source\BackupSettingsTV\BackupSettingsTV\BackupSettingsTV.cs"
%CHECKOUT% "BackupSettings.Source\BackupSettingsTV\BackupSettingsTV\Properties\AssemblyInfo.cs"
%CHECKOUT% "BackupSettings.Source\BackupSettingsTV\BackupSettingsTV\BackupSettingsExportImport.cs"

%CHECKOUT% "BackupSettings.Source\BackupSettingsMP\BackupSettingsMP\Properties\AssemblyInfo.cs"

%CHECKOUT% "BackupSettings.Source\BackupSettingsMP.exe\BackupSettingsMP.exe\Form1.Designer.cs"
%CHECKOUT% "BackupSettings.Source\BackupSettingsMP.exe\BackupSettingsMP.exe\Properties\AssemblyInfo.cs"
%CHECKOUT% "BackupSettings.Source\BackupSettingsMP.exe\BackupSettingsMP.exe\BackupSettingsExportImport.cs"

%CHECKOUT% "BackupSettings.Source\Install\Install\InstallSetup.Designer.cs"
%CHECKOUT% "BackupSettings.Source\Install\Install\Properties\AssemblyInfo.cs"

%CHECKOUT% "BackupSettings.Source\RestartSetupTV\RestartSetupTV\Properties\AssemblyInfo.cs"

%CHECKOUT% BackupSettings.Source\MPEI\BackupSettings.xmp2
