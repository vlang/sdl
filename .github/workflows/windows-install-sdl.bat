@echo off

@echo off
REM change directory to the main sdl directory
setlocal
SET cwd=%cd%
SET mypath=%~dp0
if "%mypath:~0,-1%"=="%cwd%" (
	powershell -executionpolicy remotesigned -File "install_dependencies.ps1"
) else (
	if exist ".github\workflows\install_dependencies.ps1" (
		powershell -executionpolicy remotesigned -File ".github\workflows\install_dependencies.ps1" 
	) else (
		powershell -Command Write-Host "ERROR - The script must be called from either %mypath:\.github\workflows\=% or %mypath:~0,-1%" -foreground "Red"
	)
)
endlocal
pause
