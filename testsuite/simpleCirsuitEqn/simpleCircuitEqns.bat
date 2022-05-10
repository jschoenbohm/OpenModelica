@echo off
set PATH=;D:/Programme/OpenModelica/build/bin/;%PATH%;
set ERRORLEVEL=
call "%CD%/simpleCircuitEqns.exe" %*
set RESULT=%ERRORLEVEL%

exit /b %RESULT%
