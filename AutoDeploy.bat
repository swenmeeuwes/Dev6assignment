:: Name:     	AutoDeploy.bat
:: Purpose:  	
:: Author:   	Swen Meeuwes

@echo off

:: CONFIG
SET webservice_url="http://145.24.222.160/DataFlowWebservice/api/positions?unitid=357566000058106"
SET msbuild_location="C:\Windows\Microsoft.NET\Framework\v4.0.30319\"
SET solution_location="HTTPrequester.sln"
SET nuget_location="%~dp0\"
SET mstest_location="D:\MicrosoftVisualStudio\Common7\IDE\"
SET artifacts_dir="artifacts"
SET dependencies=Newtonsoft.Json Moq

:: VARIABLES
SET log="%artifacts_dir%\log %date:~3,10% %time:~0,2%_%time:~3,2%_%time:~6,2%.txt"

:: MAIN
if not exist "%artifacts_dir%" mkdir %artifacts_dir%
echo AutoDeploy.bat Log > %log%
echo %time:~0,8% %date% >> %log%
echo ---------------------------------------------- >> %log%

if "%1"=="" goto:help

:while
shift
if "%0"=="/b" goto:build
if "%0"=="/h" goto:help
if "%0"=="/i" goto:install-dependencies
if "%0"=="/t" goto:test
if "%0"=="/u" goto:update-dependencies
if "%0"=="/r" goto:run

goto:end

:: FUNCTIONS
:build
call:install-dependencies
echo Building solution...
%msbuild_location%\MSBuild %solution_location% >> %log%
goto:while

:install-dependencies
echo Installing dependencies...
(for %%d in (%dependencies%) do (
	start /b /d %nuget_location% nuget.exe install %%d -o packages|more
)) >> %log%
goto:while

:test
echo Executing unit tests...
cd /D %msbuild_location%
MSTest /testcontainer:HTTPrequesterTests\bin\Debug\HTTPrequesterTests.dll
goto:while

:update-dependencies
echo Updating dependencies...
nuget.exe update %solution_location% >> %log%
goto:while

:run
echo Running solution...
echo Sending a http request to %webservice_url%.
echo Starting application %solution_location:~1,-5% >> %log%
start /b /d "%solution_location:~1,-5%\bin\Debug\" HTTPrequester.exe %webservice_url% >> %log%
goto:while

:help
echo Usage: AutoDeploy.bat [params]
echo Available parameters:
echo /b - Build
echo /h - Help
echo /i - Install-dependencies
echo /r - Run
echo /u - Update-dependencies
goto:while

:end
echo Done!