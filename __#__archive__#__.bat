@REM Archiving of files
@REM Drop list of files onto this batch file
@rem echo off

SETLOCAL
SET WORKPATH=%~dp0
SET ARCHIVEPATH=_archiv\
IF NOT EXIST %WORKPATH%%ARCHIVEPATH% mkdir %WORKPATH%%ARCHIVEPATH%

@REM YYYYMMDD
SET DT=%date:~6,4%-%date:~3,2%-%date:~0,2%
SET TM=%time:~0,2%%time:~3,2%
SET TM=%TM: =0%


@REM pause
@REM For each file dropped onto batch file
@REM echo on
for %%i in (%*) do (
	IF  EXIST %%i (
	
		@REM Variable funktioniert nicht??
		@rem echo %%~ni_%DT%-%TM%%%~xi
		@rem SET NEWFILE=%%~ni_%DT%-%TM%%%~xi
		@rem echo %NEWFILE%

		@REM echo file + ext: %%~nxi
		@REM echo file - ext: %%~ni
		@REM echo ext only  : %%~xi
		@REM echo full path : %%~pi
		@REM echo file path : %%~dpnxi
		
		@REM '*' at the end of new file name tricks xcopy into treating the path as file, rather than ask for confirmation whether it is a file or directory
		xcopy /Q /H %%~dpnxi %WORKPATH%%ARCHIVEPATH%%%~ni_%DT%-%TM%%%~xi*
	)
)

:end

ENDLOCAL


