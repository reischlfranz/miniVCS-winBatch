@REM miniVCS-winBatch
@REM Drag-and-Drop archiving a list of files and folders
@REM https://github.com/reischlfranz/miniVCS-winBatch
@echo off

SETLOCAL
@REM --------------------------------
@REM ---   Individual variables   ---
@REM --------------------------------
@REM Change these to your situation
SET ARCHIVEPATH=_archiv\
SET ZIPPATH="C:\Program Files\7-Zip\7z.exe"
SET ZIPPARMS= a -r 
SET ZIPEXT=.zip


SET WORKPATH=%~dp0
IF NOT EXIST %WORKPATH%%ARCHIVEPATH% mkdir %WORKPATH%%ARCHIVEPATH%

@REM YYYYMMDD
SET DT=%date:~6,4%-%date:~3,2%-%date:~0,2%
@REM HHMM
SET TM=%time:~0,2%%time:~3,2%

@REM Correct for spaces in time variable
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
		

		@REM File is directory?
		IF EXIST %%~si\* (
			@REM This is a directory: %%i
			%ZIPPATH% %ZIPPARMS% "%WORKPATH%%ARCHIVEPATH%%%~ni_%DT%-%TM%%ZIPEXT%" "%%~dpnxi"
		)
		IF NOT EXIST %%~si\* (
			@REM This is a file: %%i
			@REM '*' at the end of new file name tricks xcopy into treating the path as file, rather than ask for confirmation whether it is a file or directory
			xcopy /Q /H "%%~dpnxi" "%WORKPATH%%ARCHIVEPATH%%%~ni_%DT%-%TM%%%~xi*"
		)
	)
	
)








:end

ENDLOCAL