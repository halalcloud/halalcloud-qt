@setlocal

@echo off

set VisualStudioInstallerFolder="%ProgramFiles(x86)%\Microsoft Visual Studio\Installer"
if %PROCESSOR_ARCHITECTURE%==x86 set VisualStudioInstallerFolder="%ProgramFiles%\Microsoft Visual Studio\Installer"

pushd %VisualStudioInstallerFolder%
for /f "usebackq tokens=*" %%i in (`vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
  set VisualStudioInstallDir=%%i
)
popd

set ToolsetArch=amd64_x86
if "%PROCESSOR_ARCHITECTURE%"=="ARM64" set ToolsetArch=arm64_x86
call "%VisualStudioInstallDir%\VC\Auxiliary\Build\vcvarsall.bat" %ToolsetArch%

set ObjectFolder="%~dp0Output\Objects\x86"
set BinaryFolder="%~dp0Output\Binaries\x86"

rem Remove the output folder for a fresh compile.
rd /s /q %ObjectFolder%
rd /s /q %BinaryFolder%

mkdir %BinaryFolder%

set PATH=%~dp0qtbase\bin;%PATH%

set CommonOptions=-G "Ninja Multi-Config"
set CommonOptions=%CommonOptions% -DCMAKE_CONFIGURATION_TYPES=Release;Debug
set CommonOptions=%CommonOptions% -DBUILD_SHARED_LIBS=ON
set CommonOptions=%CommonOptions% -DQT_BUILD_EXAMPLES=OFF
set CommonOptions=%CommonOptions% -DQT_BUILD_TESTS=OFF

mkdir %ObjectFolder%\qtbase
pushd %ObjectFolder%\qtbase
cmake ^
  -DCMAKE_INSTALL_PREFIX=%BinaryFolder% ^
  %CommonOptions% ^
  -DFEATURE_optimize_size=ON ^
  -DINPUT_openssl=no ^
  -DFEATURE_schannel=ON ^
  -DINPUT_opengl=no ^
  -DFEATURE_dbus=OFF ^
  -DFEATURE_freetype=OFF ^
  -DFEATURE_system_freetype=OFF ^
  -DFEATURE_harfbuzz=OFF ^
  -DFEATURE_system_harfbuzz=OFF ^
  -DFEATURE_system_zlib=OFF ^
  -DFEATURE_direct2d=OFF ^
  -DFEATURE_directwrite=OFF ^
  -DFEATURE_icu=OFF ^
  -DFEATURE_winsdkicu=OFF ^
  -DFEATURE_timezone=OFF ^
  -DFEATURE_timezone_locale=OFF ^
  -DFEATURE_vulkan=OFF ^
  ../../../../qtbase
if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
cmake --build . --parallel
if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
ninja install
if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
popd

mkdir %ObjectFolder%\qtsvg
pushd %ObjectFolder%\qtsvg
cmake ^
  -DCMAKE_PREFIX_PATH=%BinaryFolder% ^
  -DCMAKE_INSTALL_PREFIX=%BinaryFolder% ^
  %CommonOptions% ../../../../qtsvg
if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
cmake --build . --parallel
if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
ninja install
if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
popd

mkdir %ObjectFolder%\qttools
pushd %ObjectFolder%\qttools
cmake ^
  -DCMAKE_PREFIX_PATH=%BinaryFolder% ^
  -DCMAKE_INSTALL_PREFIX=%BinaryFolder% ^
  %CommonOptions% ../../../../../qttools
if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
cmake --build . --parallel
if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
ninja install
if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
popd

mkdir %ObjectFolder%\qttranslations
pushd %ObjectFolder%\qttranslations
cmake ^
  -DCMAKE_PREFIX_PATH=%BinaryFolder% ^
  -DCMAKE_INSTALL_PREFIX=%BinaryFolder% ^
  %CommonOptions% ../../../../qttranslations
if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
cmake --build . --parallel
if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
ninja install
if %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
popd

@endlocal