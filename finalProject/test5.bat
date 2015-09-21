REM Compile the final project and try to test it
REM These are the fifth set of tests, comprising the fifth and sixth requirements
REM ``addrow'' command works. New rows are created and existing cells retain their values
REM ``removerow'' command works. New rows are created and existing cells retain their values

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
	ECHO Testing addrow command. Starting with 1 row, adding 1
    ECHO value, inserting two new rows, insert values into the
    ECHO middle row, and finally adding a new first row
	ECHO ********************************************************
	final.exe 3 1 < test5-1.txt > temp.txt
	if ERRORLEVEL 0 (
		REM Allow cells to be separated by tabs or spaces with LF/CR return statements separating the rows
		findstr /R /C:"^[ 	]*,[	 ]*,[	 ]*!CR!!LF![	 ]*,[	 ]*,[	 ]*!CR!!LF![ 	]*,[	 ]*-13.1[0]*,[	 ]*test!CR!!LF!3.14[0]*,[	 ]*,[	 ]*$" temp.txt > NUL
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
	ECHO Testing removerow command. Starting with 2 rows, adding
    ECHO three values (1 in first row, 2 in the second)
    ECHO and finally removing the first row.
	ECHO ********************************************************
	final.exe 3 2 < test5-2.txt > temp.txt
	if ERRORLEVEL 0 (
		REM Allow cells to be separated by tabs or spaces with LF/CR return statements separating the rows
		findstr /R /C:"^[	 ]*,[	 ]*-13.1[0]*,[	 ]*test$" temp.txt > NUL
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
	ECHO Testing that trying to add or remove rows outside of the
    ECHO spreadsheet range results in the error message
    ECHO "Error: row out of range" being printed.
	ECHO ********************************************************
	final.exe 3 2 < test5-3.txt > temp.txt
	if ERRORLEVEL 0 (
		REM Allow cells to be separated by tabs or spaces with LF/CR return statements separating the rows
		findstr /R /C:"^Error: row out of range!CR!!LF!Error: row out of range!CR!!LF![	 ]*,[	 ]*,[	 ]*!CR!!LF![	 ]*,[	 ]*,[	 ]*$" temp.txt > NUL
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
	ECHO Testing that trying to add or remove rows given
    ECHO non-numeric locations results in the error message
    ECHO "Error: row out of range" being printed.
	ECHO ********************************************************
	final.exe 3 2 < test5-4.txt > temp.txt
	if ERRORLEVEL 0 (
		REM Allow cells to be separated by tabs or spaces with LF/CR return statements separating the rows
		findstr /R /C:"^Error: row out of range!CR!!LF!Error: row out of range!CR!!LF![	 ]*,[	 ]*,[	 ]*!CR!!LF![	 ]*,[	 ]*,[	 ]*$" temp.txt > NUL
		if ERRORLEVEL 1 (
			echo -----Failed-----
		) else (
			echo +++++Passed+++++
		)
	) else (
		echo -----Failed-----
	)
)

