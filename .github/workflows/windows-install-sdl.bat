@echo off

setlocal
if exist ".github\workflows\install_dependencies.ps1" (
	powershell -executionpolicy remotesigned -File ".github\workflows\install_dependencies.ps1" 
) else (
	powershell -Command Write-Host "ERROR - The script must be called from the root SDL folder" -foreground "Red"
)
endlocal
pause
