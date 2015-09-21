REM Compile the final project and try to test it
REM These are the sixth set of tests, comprising the seventh, eigth and ninth
REM requirements.
REM ``min'' function cell works
REM ``max'' function cell works
REM ``mean'' function cell works

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
	ECHO Testing min function cell on two subranges of two
    ECHO different rows
	ECHO ********************************************************
	final.exe 3 2 < test6-1.txt > temp.txt
	if ERRORLEVEL 0 (
		REM Allow cells to be separated by tabs or spaces with LF/CR return statements separating the rows
		findstr /R /C:"^4.1[0]*,[ 	]*4.1[0]*,[	 ]*!CR!!LF!4.5[0]*,[ 	]*5[.0]*,[ 	]*4.1[0]*$" temp.txt > NUL
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
	ECHO Testing min function cell by applying the min function
    ECHO to the two function cells from the previous test
	ECHO ********************************************************
	final.exe 3 2 < test6-2.txt > temp.txt
	if ERRORLEVEL 0 (
		findstr /R /C:"^4.1[0]*,[ 	]*5.1[0]*,[ 	]*4.1[0]*!CR!!LF!4.1[0]*,[ 	]*5.1[0]*,[ 	]*6.1[0]*$" temp.txt > NUL
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
	ECHO Testing that the min function ignores non-numeric cells
	ECHO ********************************************************
	final.exe 25 2 < test6-3.txt > temp.txt
	if ERRORLEVEL 0 (
		findstr /R /C:"^4.1[0]*,[ 	,]*!CR!!LF!4.1[0]*,[ 	]*5.1[0]*,[ 	]*not a number[ 	,]*$" temp.txt > NUL
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
	ECHO Testing that the min yields "not a number" when there
    ECHO are no numeric cells in its range
	ECHO ********************************************************
	final.exe 3 1 < test6-4.txt > temp.txt
	if ERRORLEVEL 0 (
		findstr /R /C:"^[^,]*QNAN[^,]*,[ 	]*,[ 	]*$" temp.txt > NUL
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
	ECHO Testing max function (copying tests 6-1 through 6-3)
	ECHO ********************************************************
	final.exe 4 2 < test6-5.txt > temp.txt
	if ERRORLEVEL 0 (
		findstr /R /C:"^6.1[0]*,[ 	]*5.1[0]*,[ 	]*not a number,[ 	]*6.1[0]*!CR!!LF!4.1[0]*,[ 	]*5.1[0]*,[ 	]*6.1[0]*,[ 	]*$" temp.txt > NUL
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
	ECHO Testing mean function (copying tests 6-1 through 6-3)
	ECHO ********************************************************
	final.exe 4 2 < test6-6.txt > temp.txt
	if ERRORLEVEL 0 (
		findstr /R /C:"^5.1[0]*,[ 	]*4.6[0]*,[ 	]*not a number,[ 	]*4.85[0]*!CR!!LF!4.1[0]*,[ 	]*5.1[0]*,[ 	]*6.1[0]*,[ 	]*$" temp.txt > NUL
		if ERRORLEVEL 1 (
			echo -----Failed-----
		) else (
			echo +++++Passed+++++
		)
	) else (
		echo -----Failed-----
	)
	
)

