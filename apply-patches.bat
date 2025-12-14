@setlocal

@echo off

set PatchesFolder="%~dp0Patches"
set QtBaseFolder="%~dp0qtbase"

pushd %QtBaseFolder%
git am %PatchesFolder%\MileWindowsUniCrtIntegration.patch
if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
git am %PatchesFolder%\QWindowsFontDatabaseWithoutDirectWrite.patch
if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
git am %PatchesFolder%\QMakeVisualStudio2026Support.patch
if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
popd

@endlocal