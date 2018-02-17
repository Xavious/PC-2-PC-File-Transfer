@echo off

set directories=Desktop Favorites Documents
set nk2Path=AppData\Roaming\Microsoft\Outlook
set pstPath=AppData\Local\Microsoft\Outlook
set chromePath=AppData\Local\Google\Chrome\User Data\Default
set firefoxPath=AppData\Roaming\Mozilla\Firefox\Profiles

:whileSourcePingFail
echo Enter the source computer name:
set /p sourceComputer=
echo Source computer set to: %sourceComputer%
echo Testing connection...
ping -n 2 %sourceComputer% > nul
if %errorlevel% neq 0 (
	echo Connection test for %sourceComputer%: FAILED
	goto whileSourcePingFail
) else (
	echo Connection test for %sourceComputer%: SUCCESSFUL
)

:whileSourceUserFail
echo Enter the source user profile name:
set /p sourceUser=
echo Source user set to: %sourceUser%
set sourcePath=\\%sourceComputer%\c$\Users\%sourceUser%
echo Source path set to: %sourcePath%
set sourceOutlookPath=\\%sourceComputer%\c$\Outlook
echo Source Outlook path set to: %sourceOutlookPath%
echo Testing directory path...
if not exist %sourcePath% ( 
	echo Path test for %sourcePath%: FAILED
	goto whileSourceUserFail
) else (
	echo Path test for %sourcePath%: SUCCESSFUL
)
	
:whileDestinationPingFail
echo Enter the destination computer name:
set /p destinationComputer=
echo Destination computer set to: %destinationComputer%
echo Testing connection...
ping -n 2 %destinationComputer% > nul
if %errorlevel% neq 0 (
	echo Connection test for %destinationComputer%: FAILED
	goto whileDestinationPingFail
) else (
	echo Connection test for %destinationComputer%: SUCCESSFUL 
)

:whileDestinationUserFail
echo Enter the destination user profile name:
set /p destinationUser=
echo Destination user set to: %destinationUser%
set destinationPath=\\%destinationComputer%\c$\Users\%destinationUser%
echo Destination path set to: %destinationPath%
set destinationOutlookPath=\\%destinationComputer%\c$\Outlook
echo Desintation Outlook path set to: %destinationOutlookPath%
echo Testing directory path...
if not exist %destinationPath% (
	echo Path test for %destinationPath%: FAILED
	goto whileDestinationUserFail
) else (
	echo Path test for %destinationPath%: SUCCESSFUL
)
	
(for %%a in (%directories%) do (
	robocopy %sourcePath%\%%a %destinationPath%\%%a /E /IS /V /job:exclusions.rcj
))

if exist "%sourcePath%\%chromePath%\Bookmarks" (
	robocopy "%sourcePath%\%chromePath%" "%destinationPath%\%chromePath%" Bookmarks /IS /V
) else (
	echo -----No Chrome bookmarks found-----
)

for /F "tokens=* USEBACKQ" %%F in (`dir %sourcePath%\%firefoxPath% /b`) do (
	set firefoxSourceProfile=%%F
)

for /F "tokens=* USEBACKQ" %%F in (`dir %destinationPath%\%firefoxPath% /b`) do (
	set firefoxDesintationProfile=%%F
)

echo %sourcePath%\%firefoxPath%\%firefoxSourceProfile%\places.sqlite
echo %destinationPath%\%firefoxPath%\%firefoxDestinationProfile%\places.sqlite

if exist "%sourcePath%\%firefoxPath%\%firefoxSourceProfile%\places.sqlite" (
	robocopy "%sourcePath%\%firefoxPath%\%firefoxSourceProfile%" "%destinationPath%\%firefoxPath%\%firefoxDesintationProfile%" places.sqlite /IS /V
) else (
	echo -----No Firefox bookmarks found-----
)

for /R %sourcePath%\%nk2Path% %%f in (*.NK2) do ( 
	robocopy %%~dpf %destinationPath%\%nk2Path% %%~nxf /E /IS /V
)

for /R %sourcePath%\%pstPath% %%f in (*.pst) do (
	robocopy %%~dpf %destinationPath%\%pstPath% %%~nxf /E /IS /V
)

if exist %sourceOutlookPath% (
	robocopy %sourceOutlookPath% %destinationOutlookPath% /E /IS /V
)

pause