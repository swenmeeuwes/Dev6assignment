:: Name:     	AutoDeploy.bat
:: Purpose:  	
:: Author:   	Swen Meeuwes

@echo off

:: CONFIG
SET msbuild_location="C:\Windows\Microsoft.NET\Framework\v4.0.30319\"
SET solution_location="HTTPrequester.sln"
SET nuget_location="%~dp0\"
SET mstest_location="D:\MicrosoftVisualStudio\Common7\IDE\"
SET git_location="C:\Program Files (x86)\Git\bin\"
SET artifacts_dir="..\Artifacts"
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
if "%0"=="/c" goto:git-commit
if "%0"=="/h" goto:help
if "%0"=="/i" goto:install-dependencies
if "%0"=="/p" goto:git-push
if "%0"=="/r" goto:run
if "%0"=="/t" goto:test
if "%0"=="/u" goto:update-dependencies

goto:end

:: FUNCTIONS
:build
echo Installing dependencies...
(for %%d in (%dependencies%) do (
	start /b /d %nuget_location% nuget.exe install %%d -o packages|more
)) >> %log%
echo Building solution...
%msbuild_location%MSBuild %solution_location% >> %log%
goto:while

:git-commit
echo Git: Committing...
%git_location%Git add * >> %log%
%git_location%Git commit -a -m "Commit from AutoDeploy.bat on %date:~3,10% %time:~0,2%_%time:~3,2%_%time:~6,2%" >> %log%
goto:while

:git-push
echo Git: Pushing...
%git_location%Git push --all origin >> %log%
goto:while

:help
echo Usage: AutoDeploy.bat [params]
echo Available parameters:
echo /b - Build
echo /c - Git-Commit
echo /p - Git-Push
echo /h - Help
echo /i - Install-dependencies
echo /r - Run
echo /t - Execute Unit Tests
echo /u - Update-dependencies
goto:while

:install-dependencies
echo Installing dependencies...
(for %%d in (%dependencies%) do (
	start /b /d %nuget_location% nuget.exe install %%d -o packages|more
)) >> %log%
goto:while

:run
echo Running solution...
echo Starting application %solution_location:~1,-5% >> %log%
start /b /d "%solution_location:~1,-5%\bin\Debug\" HTTPrequester.exe "http://145.24.222.160/DataFlowWebservice/api/positions?unitid=357566000058106" >> %log%
goto:while

:test
echo Executing unit tests...
%mstest_location%MSTest /testcontainer:HTTPrequesterTests\bin\Debug\HTTPrequesterTests.dll >> %log%
goto:while

:update-dependencies
echo Updating dependencies...
nuget.exe update %solution_location% >> %log%
goto:while


:end
echo Done!