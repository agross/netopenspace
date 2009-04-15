@echo off
cls

tools\NAnt\NAnt.exe -buildfile:default.build %1 %2
pause
build.bat %1 %2