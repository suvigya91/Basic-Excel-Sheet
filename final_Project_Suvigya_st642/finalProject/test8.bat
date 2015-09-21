REM Compile the final project and try to test it
REM This tests the extra credit requirements
REM Function cells continue using the same cells after addrow commands move their position or the position of the row the function cell's value is based upon.
REM Function cells continue using the same cells after removerow commands move their position or the position of the row the function cell's value is based upon. If the row being used for the source value is deleted then the function cell's value become NaN.

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
	ECHO Testing that functions works despite addrow commands
	ECHO ********************************************************
	final.exe 2 2 < test8-1.txt > temp.txt
	if ERRORLEVEL 0 (
		REM Allow cells to be separated by tabs or spaces with LF/CR return statements separating the rows
		findstr /R /C:"^[ 	]*,[ 	]!CR!!LF!0.25[0]*,[ 	]*2.75[0]*!CR!!LF![ 	]*,[ 	]!CR!!LF!1.5[0]*,[ 	]*0.25[0]*$" temp.txt > NUL
		if ERRORLEVEL 1 (
			echo -----Failed-----
		) else (
			echo +++++Passed+++++
		)
	) else (
		echo -----Failed-----
	)
	
	ECHO.
	ECHO ********************************************************
	ECHO Testing function cells with addrow and removerow commands.
	ECHO If a row is deleted function cells that depend upon it
	ECHO should change to NAN values.
	ECHO ********************************************************
	final.exe 2 2 < test8-2.txt > temp.txt
	if ERRORLEVEL 0 (
		REM Allow cells to be separated by tabs or spaces with LF/CR return statements separating the rows
		REM findstr /R /C:"^[^,]*QNAN.*,[ 	]*3[.0]*!CR!!LF!1.5[0]*,[ 	]*4.5[0]*!CR!!LF![^,]*QNAN.*,[ 	]*,[^,]*QNAN.*$" temp.txt > NUL
		findstr /R /C:"^[^,]*QNAN.*,[ 	]*3[.0]*!CR!!LF!1.5[0]*,[ 	]*4.5[0]*!CR!!LF!.*QNAN.*,.*QNAN" temp.txt > NUL
		if ERRORLEVEL 1 (
			echo -----Failed-----
		) else (
			echo +++++Passed+++++
		)
	) else (
		echo -----Failed-----
	)
	
)

