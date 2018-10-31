@Echo off
:1
menu %1 %2 %3 %4 %5
if not exist play.bat goto end
call play.bat
goto 1

:end