REM Compile the final project and try to test it
REM These are the third set of tests
REM "``set x y string'' command works. Strings can be placed into the spreadsheet
REM and printed."

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
	ECHO Testing strings at the beginning, middle, and end of the
    ECHO spreadsheet.
	ECHO ********************************************************
	final.exe 3 2 < test3-1.txt > temp.txt
	if ERRORLEVEL 0 (
		REM Allow cells to be separated by tabs or spaces with LF/CR return statements separating the rows
		REM Check for the three test strings in the proper locations
		findstr /R /C:"^first string*,[	 ]*,[	 ]*!CR!!LF![	 ]*,[	 ]*middle,[	 ]*last string at the end$" temp.txt > NUL
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
	ECHO Testing that a new string can overwrite an existing one.
	ECHO ********************************************************
	final.exe 3 2 < test3-2.txt > temp.txt
	if ERRORLEVEL 0 (
		REM Allow cells to be separated by tabs or spaces with LF/CR return statements separating the rows
		REM This checks for two commas on two separate lines
		findstr /R /C:"^[	 ]*,[	 ]*,[	 ]*!CR!!LF![	 ]*,[	 ]*,[	 ]*replacement text$" temp.txt > NUL
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
	final.exe 3 2 < test3-3.txt > temp.txt
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
)

