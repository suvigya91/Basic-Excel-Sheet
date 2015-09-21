REM Compile the final project and try to test it
REM This tests the tenth requirement
REM "Function cells update their values when the appropriate
REM non-string cells change their values"

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
	ECHO Testing that a min and max function update their values
	ECHO ********************************************************
	final.exe 2 3 < test7-1.txt > temp.txt
	if ERRORLEVEL 0 (
		REM Allow cells to be separated by tabs or spaces with LF/CR return statements separating the rows
		findstr /R /C:"^1.6[0]*,[ 	]*2.4[0]*!CR!!LF!2.4[0]*,[ 	]*1.6[0]*!CR!!LF!1.6[0]*,[ 	]*2.4[0]*$" temp.txt > NUL
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
	ECHO Testing that functions update their values even when
    ECHO depending upon cascading changes. For example, A depends
    ECHO on B and B depends on C.
	ECHO ********************************************************
	final.exe 2 3 < test7-2.txt > temp.txt
	if ERRORLEVEL 0 (
		REM Allow cells to be separated by tabs or spaces with LF/CR return statements separating the rows
		findstr /R /C:"^1.6[0]*,[ 	]*2.4[0]*!CR!!LF!2.4[0]*,[ 	]*1.6[0]*!CR!!LF!1.6[0]*,[ 	]*2.4[0]*$" temp.txt > NUL
		if ERRORLEVEL 1 (
			echo -----Failed-----
		) else (
			echo +++++Passed+++++
		)
	) else (
		echo -----Failed-----
	)
	
)

