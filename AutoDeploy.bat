:: Name:     	AutoDeploy.bat
:: Purpose:  	
:: Author:   	Swen Meeuwes

@echo off

:: CONFIG
SET webservice_url="http://145.24.222.160/DataFlowWebservice/api/positions?unitid=357566000058106"
SET msbuild_location="C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild.exe"
SET solution_location=HTTPrequester.sln
SET artifacts_dir="artifacts"

:: VARIABLES
SET log="%artifacts_dir%\log %date:~3,10% %time:~0,2%_%time:~3,2%_%time:~6,2%.txt"

:: MAIN
if not exist "%artifacts_dir%" mkdir %artifacts_dir%
echo AutoDeploy.bat Log > %log%
echo %time:~0,8% %date% >> %log%
echo ---------------------------------------------- >> %log%

if "%1"=="" goto:help

:while
if "%1"=="/b" goto:build
if "%1"=="/u" goto:update-dependencies
if "%1"=="/r" goto:run
if "%1"=="/h" goto:help

goto:end

:: FUNCTIONS
:build
echo Building solution...
start /b %msbuild_location% %solution_location% /p:Configuration=Release /p:Platform="Any CPU"
shift
goto:while

:update-dependencies
echo Updating dependencies...
nuget.exe update %solution_location%
shift
goto:while

:run
echo Running solution...
pushd "%solution_location:~0,-4%\bin\Debug\"
echo Sending a http request to %webservice_url%.
HTTPrequester.exe %webservice_url%
shift
goto:while

:help
echo Usage: AutoDeploy.bat [params]
echo Available parameters:
echo /b - Build
echo /h - Help
echo /r - Run
echo /u - Update-dependencies
goto:while

:end
echo Done!