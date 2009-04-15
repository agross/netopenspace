@echo off
cls

tools\NAnt\NAnt.exe -buildfile:production.build %target%
pause
build-deploy-production.bat %target%