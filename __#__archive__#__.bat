:: miniVCS-winBatch
:: Drag-and-Drop archiving a list of files and folders
:: https://github.com/reischlfranz/miniVCS-winBatch
@echo off

SETLOCAL
:: --------------------------------
:: ---   Individual variables   ---
:: --------------------------------
:: Change these to your situation
SET ARCHIVEPATH=_archiv\
SET ZIPEXT=.zip

:: Set to ZIP to Zip single files, set to COPY to just copy them
SET FILEACTION=COPY

:: Set to PS to use PowerShell Zip functionality
:: Set to ZIP to use external zip tool (see below)
SET USEZIP=PS

:: Path to and parameters of external ZIP utility
SET ZIPPATH="C:\Program Files\7-Zip\7z.exe"
SET ZIPPARMS= a -r 

:: No parameters given - print help
IF NOT EXIST %%0 GOTO help

:: Check for parameter '/?'
for %%i in (%*) do (
  IF (%%i EQU "/?") goto help
)

SET "WORKPATH=%~dp0"
IF NOT EXIST "%WORKPATH%%ARCHIVEPATH%" mkdir "%WORKPATH%%ARCHIVEPATH%"

:: YYYYMMDD
SET DT=%date:~6,4%-%date:~3,2%-%date:~0,2%
:: HHMM
SET TM=%time:~0,2%%time:~3,2%

:: Correct for spaces in time variable
SET TM=%TM: =0%

:: For each file dropped onto batch file
for %%i in (%*) do (
  IF  EXIST %%i (
  
    :: File is directory?
    IF EXIST %%~si\* (
      
      :: This is a directory: %%i
      IF %USEZIP% EQU PS (
        powershell -command "Compress-Archive -Path '%%~dpnxi' -CompressionLevel Optimal -DestinationPath '%WORKPATH%%ARCHIVEPATH%%%~ni_%DT%-%TM%%ZIPEXT%'"
      )
      
      
      IF %USEZIP% EQU ZIP (
        %ZIPPATH% %ZIPPARMS% "%WORKPATH%%ARCHIVEPATH%%%~ni_%DT%-%TM%%ZIPEXT%" "%%~dpnxi"
      )
      
      :: Put archived zip-file in read-only mode
      attrib +R "%WORKPATH%%ARCHIVEPATH%%%~ni_%DT%-%TM%%ZIPEXT%"
      
    )
    IF NOT EXIST %%~si\* (
      :: This is a file: %%i
      IF %FILEACTION% EQU ZIP (
        echo Trying to zip...
        IF %USEZIP% == PS (
          powershell -command "Compress-Archive -Path '%%~dpnxi' -CompressionLevel Optimal -DestinationPath '%WORKPATH%%ARCHIVEPATH%%%~ni_%%~xi.%DT%-%TM%%ZIPEXT%'"
          
          :: Put archived zip-file in read-only mode
          attrib +R "%WORKPATH%%ARCHIVEPATH%%%~ni_%%~xi.%DT%-%TM%%ZIPEXT%"
        )
        IF %USEZIP% EQU ZIP (
          %ZIPPATH% %ZIPPARMS% "%WORKPATH%%ARCHIVEPATH%%%~ni_%%~xi.%DT%-%TM%%ZIPEXT%" "%%~dpnxi"
        )
      )
      IF %FILEACTION% EQU COPY (
        :: '*' at the end of new file name tricks xcopy into treating the path as file, rather than ask for confirmation whether it is a file or directory
        xcopy /Q /H "%%~dpnxi" "%WORKPATH%%ARCHIVEPATH%%%~ni_%DT%-%TM%%%~xi*"
        
        :: (Optional) "Touch" the archived file to update the time stamp
        copy /B "%WORKPATH%%ARCHIVEPATH%%%~ni_%DT%-%TM%%%~xi"+,, "%WORKPATH%%ARCHIVEPATH%%%~ni_%DT%-%TM%%%~xi" /Y
        
        :: Put archived file in read-only mode
        attrib +R "%WORKPATH%%ARCHIVEPATH%%%~ni_%DT%-%TM%%%~xi"
        
      )
    )
  )
  
)
GOTO end

:help

echo Saves and archives copies of files complete with current timestamp into archive directory.
echo.
echo %~nx0 [file1 [file2 file3 ...]]
echo.
echo.  /?         Display this help message
echo.
echo How to use:
echo Drag-and-Drop files and directory in Windows Explorer onto this batch file.
echo Alternatively, use in terminal with above given syntax.
echo. 
echo Settings:
echo Change these lines with a text editor to suit your situation:
echo.   ...
echo.   :: Change these to your situation
echo.   SET ARCHIVEPATH=_archiv\
echo.   SET ZIPEXT=.zip
echo.   
echo.   :: Set to ZIP to Zip single files, set to COPY to just copy them
echo.   SET FILEACTION=COPY
echo.   
echo.   :: Set to PS to use PowerShell Zip functionality
echo.   :: Set to ZIP to use external zip tool (see below)
echo.   SET USEZIP=PS
echo.   
echo.   :: Path to and parameters of external ZIP utility
echo.   SET ZIPPATH="C:\Program Files\7-Zip\7z.exe"
echo.   SET ZIPPARMS= a -r 
echo.   ...


pause
GOTO end

:end

ENDLOCAL

