REM Compile the final project and try to test it

setlocal enableDelayedExpansion

@ECHO OFF

REM Set up carriage return and linefeed for findstr
REM as described at ss64.com and stackoverflow
REM Credit to Dave Benham
REM Define LF variable containing a linefeed (0x0A)
set LF=^


REM The above 2 blank lines are critical for defining the line feed

REM Define CR variable containing a carriage return (0x0D)
for /f %%a in ('copy /Z "%~dpf0" nul') do set "CR=%%a"

ECHO "Attempting to compile the final project..."
REM Compile all cpp files in this directory,
REM output into "final.exe" and enable exception unwinding
cl /Fefinal.exe /EHsc *.cpp

REM Check if compiling succeeded
if %ERRORLEVEL% GEQ 1 (
	ECHO Program failed to compile!
) else (
	ECHO Compiled program, starting testing
	
	ECHO.
	ECHO ********************************************************
	ECHO Testing return value of 1 when given too few arguments
	ECHO ********************************************************
	final.exe 1 > temp.txt
	if ERRORLEVEL 1 (
		echo +++++Passed+++++
	) else (
		echo -----Failed-----
	)
	
	ECHO.
	ECHO ********************************************************
	ECHO Testing return value of 1 when given 0-value arguments
	ECHO ********************************************************
	final.exe 5 0 > temp.txt
	if ERRORLEVEL 1 (
		echo +++++Passed+++++
	) else (
		echo -----Failed-----
	)
	
	ECHO.
	ECHO ********************************************************
	ECHO Testing return value of 1 when given non-numeric arguments
	ECHO ********************************************************
	final.exe a b > temp.txt
	if ERRORLEVEL 1 (
		echo +++++Passed+++++
	) else (
		echo -----Failed-----
	)
	
	ECHO.
	ECHO ********************************************************
	ECHO Testing return value of 0 when given "quit" command
	ECHO ********************************************************
	final.exe 2 3 < test1.txt > temp.txt
	if ERRORLEVEL 0 (
		echo +++++Passed+++++
	) else (
		echo -----Failed-----
	)
)

