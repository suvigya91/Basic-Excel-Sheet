REM Compile the final project and try to test it
REM These are the second set of tests
REM "An empty spreadsheet of the specified size is created at
REM startup. The ``print'' command works, bad commands are ignored"

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
	ECHO Testing print command with a 2 by 3 sheet
	ECHO ********************************************************
	final.exe 2 3 < test2-1.txt > temp.txt
	if ERRORLEVEL 0 (
		REM Allow cells to be separated by tabs or spaces with LF/CR return statements separating the rows
		REM This checks for one commas occuring in three lines
		findstr /R /C:"^[	 ]*,[	 ]*!CR!!LF![	 ]*,[	 ]*!CR!!LF![	 ]*,[	 ]*$" temp.txt > NUL
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
	ECHO Testing print command with a 3 by 2 sheet
	ECHO ********************************************************
	final.exe 3 2 < test2-1.txt > temp.txt
	if ERRORLEVEL 0 (
		REM Allow cells to be separated by tabs or spaces with LF/CR return statements separating the rows
		REM This checks for two commas on two separate lines
		findstr /R /C:"^[	 ]*,[	 ]*,[	 ]*!CR!!LF![	 ]*,[	 ]*,[	 ]*$" temp.txt > NUL
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
	ECHO Testing that "Error: unknown command" is printed when
    ECHO bad commands are given. Also checking that the cells
    ECHO remain unmodified.
	ECHO ********************************************************
	final.exe 3 2 < test2-2.txt > temp.txt
	if ERRORLEVEL 0 (
		REM Allow cells to be separated by tabs or spaces with LF/CR return statements separating the rows
		REM This checks for two commas on two separate lines
		findstr /R /C:"^Error: unknown command!CR!!LF![	 ]*,[	 ]*,[	 ]*!CR!!LF![	 ]*,[	 ]*,[	 ]*!CR!!LF!Error: unknown command$" temp.txt > NUL
		if ERRORLEVEL 1 (
			echo -----Failed-----
		) else (
			echo +++++Passed+++++
		)
	) else (
		echo -----Failed-----
	)
)

