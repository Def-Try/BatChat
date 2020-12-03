@rem BatChat
@echo off
if "%~1" == "logo" goto logo
set embed=0
cls
pushd "%~dp0"
echo Current DIR: "%CD%"
if "%~1" == "talk_widget" goto talker

rem ================================================

rem ////////////////////

:menu


:splash-set

::set /a result=(%RANDOM%*6/32768)+1
set /a result=%random%%%(6-1+1)+1


if %result%==1 set splash=I am not dead!
if %result%==2 set splash=  "HUGE SUCCESS"==1
if %result%==3 set splash=It you again!
if %result%==4 set splash=Hello!
if %result%==5 set splash=  IF start NOT true : start = true
if %result%==6 set splash=Let's go!



set lm=menu
cls
echo Welcome to BatChat!
echo 			   %splash%
echo %result%
echo.
echo 1.Chat
echo 2.Settings
echo 3.Exit
echo.
set /p menu=Menu^> 
if %menu%==1 goto chat
if %menu%==2 goto settings
if %menu%==3 exit

if %menu%==developer.menu(1) goto devmenu
goto menu

:chat
cls
echo.
echo 1.Create
echo 2.Come in
echo #.Public chats(coming soon!)
echo 3.Back
echo.
set /p menu=Menu^> 
if %menu%==1 goto authcreate
if %menu%==2 goto auth
if %menu%==3 goto menu
goto chat
:authcreate
cls
echo Chat name("abc" for example):
set /p chat=^>
call :passset
echo Nick:
set /p nick=^>
set admin=1
goto passok


:chatnotexist
cls
echo Chat not exist!
pause>nul
goto menu


:auth
cls
echo Chat name("abc" for example):
set /p chat=^>
if NOT EXIST "%chat%" goto chatnotexist
echo Nick:
set /p nick=^>
if EXIST "%chat%.pass.cr" goto passtest

:passok
start call %0 talk_widget %chat% %nick%

rem ////////////////////
:listener
cls
call title "| Chat: %chat% | User: %nick% |"
if exist %chat%_history type %chat%_history
if not exist %chat% echo. 2>%chat%

:listener_loop

ping 127.0.0.1 -n 1 -w 20 > nul
set oldtext=%text%
set /p text=<%chat%
if not "%text%" == "%oldtext%" echo %text%
if EXIST "exit" (goto exitlistener)
if EXIST "%chat%.clear" (del /s /q %chat%.clear & cls)
if EXIST "%chat%.chatnotexistlistener" (del /s /q %chat%.chatnotexistlistener & cls & echo Chat deleted. & pause>nul & exit /b)


goto listener_loop
rem ////////////////////

rem ================================================

rem ////////////////////
rem // %2 - chat name //
rem // %3 - user nick //
rem ////////////////////
:talker
set chat=%~2
set nick=%~3
cls
call title "| Chat: %chat% | User: %nick% |"
call ::cs_in
echo (%TIME% %nick% connected)>%chat%
call ::cs_out
echo (%TIME% %nick% connected)>>%chat%_history
:talker-loop
cls
:talker_loop
set lm=talker_loop
set lm2=talker-loop
echo.
echo Welcome to %chat%! Type /help to get command list
echo Type message to send:
:lm3
if EXIST "%chat%.chatnotexist" (del /s /q %chat%.chatnotexist & exit)
set /p msg=Message^>
if "%msg%"=="/exit" goto exit
if "%msg%"=="/help" goto help
if "%msg%"=="/settings" goto settings
if "%msg%"=="/clear" goto clear
if "%msg%"=="/delete" goto delete
if "%msg%"=="/passshow" goto passshow
if "%msg%"=="/passset" call :passchatset
if "%msg%"=="/embed" goto embed
call ::cs_in
echo [%TIME% %nick%]: %msg%>%chat%
call ::cs_out
echo [%TIME% %nick%]: %msg%>>%chat%_history
goto talker-loop

rem ////////////////////

rem ================================================

rem ////////////////////
:cs_in
if exist "%chat%_cs" ping 127.0.0.1 -n 1 -w 50 > nul
set cs_value=%RANDOM%

:cs_in_loop
echo %cs_value%>%chat%_cs
set /p ret=<%chat%_cs
if "%ret%" == "%cs_value%" exit /b
ping 127.0.0.1 -n 1 -w 10 > nul
goto :cs_in_loop
rem ////////////////////

rem ////////////////////
:cs_out
del %chat%_cs
exit /b
rem ////////////////////

rem ================================================

:exit
set TIMEold=%time%
call ::cs_in
echo (%TIME% %nick% disconnected)>%chat%
call ::cs_out
echo (%TIME% %nick% disconnected)>>%chat%_history
echo exit>exit
exit

:exitlistener

del /s /q exit
exit /b

:settings
cls
echo.
echo Settings
echo.
echo 1.Chat Color
echo 2.Back
echo.
set /p sett=Settings^> 
if %sett%==1 goto color
if %sett%==2 goto %lm2%

:color
cls
echo.
echo Color
echo.
echo Type Color of Foreground
echo Foreground color: %fg%
echo.
echo 0 - black       8 - grey
echo 1 - blue        9 - light-blue
echo 2 - green       A - light-green
echo 3 - cyan        B - light-cyan
echo 4 - red         C - light-red
echo 5 - purple      D - light-purple
echo 6 - yellow      E - light-yellow
echo 7 - white       F - light-white
echo.
set /p fg=Color_FG^>
cls
echo.
echo Color
echo.
echo Type Color of Background
echo Background color: %bg%
echo.
echo 0 - black       8 - grey
echo 1 - blue        9 - light-blue
echo 2 - green       A - light-green
echo 3 - cyan        B - light-cyan
echo 4 - red         C - light-red
echo 5 - purple      D - light-purple
echo 6 - yellow      E - light-yellow
echo 7 - white       F - light-white
echo.
set /p bg=Color_BG^>
color %fg%%bg%
goto settings






:passset

::echo Password(Leave blank if no password is required):
::set /p password=Password^>

::if "%password%"=="" exit /b

::echo %password%>data\tmppass
::data\rc4 GDkf-JIny-GHJD-Td5f data\tmppass %chat%.pass.cr

exit /b

:passtest
cls
echo This chat has password.
echo Type "exit" to go to menu
echo.
set /p password=Password^>


::del /s /q data\tmppass
::echo .>%chat%.tmppass
data\rc4.exe GDkf-JIny-GHJD-Td5f %chat%.pass.cr data\%chat%.tmppass

for /f "Delims=" %%a in (data\%chat%tmppass) do (
	set pass=%%a
)
if %password%==exit goto menu
if %pass%==%password% goto passok
echo .>data\tmppass
goto passtest



:help
if %admin%==1 goto adminhelp
echo ============================
echo Commands:
echo settings - Settings
echo exit - Exit from chat
echo embed - open embed constructor
echo ============================
goto %lm%
:adminhelp
echo ============================
echo Commands:
echo settings - Settings
echo exit - Exit from chat
echo delete - Delete chat
echo clear - Clears chat
echo passset - Set password
echo passshow - Shows password
echo ============================
goto lm3


:clear
del /s /q %chat%_history
del /s /q %chat%
echo .>%chat%_history
echo .>%chat%
echo chatclear=1>%chat%.clear
goto talker-loop
:delete
echo Chat deleted>%chat%_history
echo Chat deleted>%chat%
del /s /q %chat%_history
del /s /q %chat%

echo chatexist=0>%chat%.chatnotexist
echo chatexist=0>%chat%.chatnotexistlistener
goto talker-loop
:passshow

for /f "Delims=" %%a in (data\tmppass) do (
	set pass=%%a
)
echo %pass%
goto lm3
:passchatset
echo Password(Leave blank if no password is required):
set /p password=Password^>

if "%password%"=="" (del /s /q %chat%.pass.cr & exit /b)

echo %password%>data\tmppass
data\rc4 GDkf-JIny-GHJD-Td5f data\tmppass %chat%.pass.cr

exit /b
	




::online
:devmenu
cls
echo devmenu

echo 3.Back
set /p devmenu=devmenu^> 

if %devmenu%==3 goto menu
goto devmenu



:embed
set title=Title
set text=Text
set littletext=text
:embedloop
cls
echo Embed constructor
echo =====================
echo %title%
echo =====================
echo %text%
echo.
echo %littletext%
echo =====================
echo.
echo.
echo Type "title, text, text2" to edit embed. Type "send" to send embed
set /p edit-embed=EmbedEdit^> 
if %edit-embed%==title (set /p title=Title^> )
if %edit-embed%==text (set /p text=Text^> )
if %edit-embed%==text2 (set /p littletext=Text 2^> )
if %edit-embed%==send goto embedsend
goto embedloop

:embedsend
echo =====================>%chat%
ping -n 1 localhost>nul
echo [%time%] %nick%
ping -n 1 localhost>nul
echo =====================>%chat%
ping -n 1 localhost>nul
echo %title%              >%chat%
ping -n 1 localhost>nul
echo =====================>%chat%
ping -n 1 localhost>nul
echo %text%               >%chat%
ping -n 1 localhost>nul
echo.>%chat%
ping -n 1 localhost>nul
echo %littletext%         >%chat%
ping -n 1 localhost>nul
echo =====================>%chat%
ping -n 1 localhost>nul
goto talker-loop




:logo
cls
echo  ‹‹‹‹‹‹‹‹‹‹  ‹‹‹‹‹‹‹‹‹‹‹ ‹‹‹‹‹‹‹‹‹‹‹ ‹‹‹‹‹‹‹‹‹‹‹ ‹         ‹ ‹‹‹‹‹‹‹‹‹‹‹ ‹‹‹‹‹‹‹‹‹‹‹ 
echo ﬁ∞∞∞∞∞∞∞∞∞∞›ﬁ∞∞∞∞∞∞∞∞∞∞∞ﬁ∞∞∞∞∞∞∞∞∞∞∞ﬁ∞∞∞∞∞∞∞∞∞∞∞ﬁ∞›       ﬁ∞ﬁ∞∞∞∞∞∞∞∞∞∞∞ﬁ∞∞∞∞∞∞∞∞∞∞∞›
echo ﬁ∞€ﬂﬂﬂﬂﬂﬂﬂ€∞ﬁ∞€ﬂﬂﬂﬂﬂﬂﬂ€∞›ﬂﬂﬂﬂ€∞€ﬂﬂﬂﬂﬁ∞€ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬁ∞›       ﬁ∞ﬁ∞€ﬂﬂﬂﬂﬂﬂﬂ€∞›ﬂﬂﬂﬂ€∞€ﬂﬂﬂﬂ 
echo ﬁ∞›       ﬁ∞ﬁ∞›       ﬁ∞›    ﬁ∞›    ﬁ∞›         ﬁ∞›       ﬁ∞ﬁ∞›       ﬁ∞›    ﬁ∞›     
echo ﬁ∞€‹‹‹‹‹‹‹€∞ﬁ∞€‹‹‹‹‹‹‹€∞›    ﬁ∞›    ﬁ∞›         ﬁ∞€‹‹‹‹‹‹‹€∞ﬁ∞€‹‹‹‹‹‹‹€∞›    ﬁ∞›     
echo ﬁ∞∞∞∞∞∞∞∞∞∞›ﬁ∞∞∞∞∞∞∞∞∞∞∞›    ﬁ∞›    ﬁ∞›         ﬁ∞∞∞∞∞∞∞∞∞∞∞ﬁ∞∞∞∞∞∞∞∞∞∞∞›    ﬁ∞›     
echo ﬁ∞€ﬂﬂﬂﬂﬂﬂﬂ€∞ﬁ∞€ﬂﬂﬂﬂﬂﬂﬂ€∞›    ﬁ∞›    ﬁ∞›         ﬁ∞€ﬂﬂﬂﬂﬂﬂﬂ€∞ﬁ∞€ﬂﬂﬂﬂﬂﬂﬂ€∞›    ﬁ∞›     
echo ﬁ∞›       ﬁ∞ﬁ∞›       ﬁ∞›    ﬁ∞›    ﬁ∞›         ﬁ∞›       ﬁ∞ﬁ∞›       ﬁ∞›    ﬁ∞›     
echo ﬁ∞€‹‹‹‹‹‹‹€∞ﬁ∞›       ﬁ∞›    ﬁ∞›    ﬁ∞€‹‹‹‹‹‹‹‹‹ﬁ∞›       ﬁ∞ﬁ∞›       ﬁ∞›    ﬁ∞›     
echo ﬁ∞∞∞∞∞∞∞∞∞∞›ﬁ∞›       ﬁ∞›    ﬁ∞›    ﬁ∞∞∞∞∞∞∞∞∞∞∞ﬁ∞›       ﬁ∞ﬁ∞›       ﬁ∞›    ﬁ∞›     
echo  ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ  ﬂ         ﬂ      ﬂ      ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ ﬂ         ﬂ ﬂ         ﬂ      ﬂ  
echo.

echo.                                                           

echo.
echo                                                               Def-Try, 2020, BatChat

pause
