REM Compile the final project and try to test it
REM These are the fourth set of tests
REM "``set x y number'' command works. Numbers can be placed into the
REM spreadsheet and printed."

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
	ECHO Testing numbers at the beginning, middle, and end of the
    ECHO spreadsheet.
	ECHO ********************************************************
	final.exe 3 2 < test4-1.txt > temp.txt
	if ERRORLEVEL 0 (
		REM Allow cells to be separated by tabs or spaces with LF/CR return statements separating the rows
		REM Check for the three test numbers in the proper locations
		findstr /R /C:"^3.14[0]*,[	 ]*,[	 ]*!CR!!LF![	 ]*,[	 ]*-13[.]*[0]*,[	 ]*6.5[0]*$" temp.txt > NUL
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
	ECHO Testing that a new number can overwrite an existing one.
	ECHO ********************************************************
	final.exe 3 2 < test4-2.txt > temp.txt
	if ERRORLEVEL 0 (
		REM Allow cells to be separated by tabs or spaces with LF/CR return statements separating the rows
		findstr /R /C:"^[	 ]*,[	 ]*,[	 ]*!CR!!LF![	 ]*,[	 ]*,[	 ]*-111.1[0]*$" temp.txt > NUL
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
	ECHO Testing that cells out of range are ignored and the
    ECHO error message ``Error: cell out of range'' is printed.
	ECHO ********************************************************
	final.exe 3 2 < test4-3.txt > temp.txt
	if ERRORLEVEL 0 (
		REM Allow cells to be separated by tabs or spaces with LF/CR return statements separating the rows
		findstr /R /C:"^Error: cell out of range!CR!!LF!Error: cell out of range!CR!!LF!Error: cell out of range!CR!!LF![	 ]*,[	 ]*,[	 ]*!CR!!LF![	 ]*,[	 ]*,[	 ]*$" temp.txt > NUL
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
	ECHO Testing that non-numeric values are ignored and the
    ECHO message ``Error: Bad input for set number'' is printed.
	ECHO ********************************************************
	final.exe 3 2 < test4-4.txt > temp.txt
	if ERRORLEVEL 0 (
		REM Allow cells to be separated by tabs or spaces with LF/CR return statements separating the rows
		findstr /R /C:"^Error: Bad input for set number!CR!!LF![	 ]*,[	 ]*,[	 ]*!CR!!LF![	 ]*,[	 ]*,[	 ]*$" temp.txt > NUL
		if ERRORLEVEL 1 (
			echo -----Failed-----
		) else (
			echo +++++Passed+++++
		)
	) else (
		echo -----Failed-----
	)
)

