
@echo on
goto K%1

:K
:K2

if exist ERROR ERASE ERROR
\rac_doc\EchoDate Make UH103 Pic >> log.txt
\Compiler\NMAKE "P=HOME" UH103.MAF
goto end


:KRel
if .%2==. goto xNoHist
if exist ..\Uh103%2.* goto xGotIt
if exist *.	del *.
if exist *.bak	del *.bak
if exist *.exe	del *.exe
if exist *.map	del *.map
if exist *.lst	del *.lst
\Ultron\Tools\pkzip -u ..\UH103
copy ..\UH103.ZIP ..\UH103%2.ZIP
copy    UH103.Hex ..\UH103%2.Hex
echo Updated Uh103%2.ZIP dude
goto end
:xNoHist
echo You must HIST rev dude
goto end
:xGotIt
echo Already have Uh103%2.* dude
goto end














:KCMP
:Kcmp
call \SetDest
cls
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo Compareing  ..\uh103 %DEST%\ultron\uh103
@echo.
@echo.
@echo.
pause
fcmp ..\uh103 %DEST%\ultron\uh103
goto end


:KZ
:Kz
if exist *.	del *.
if exist *.bak	del *.bak
if exist *.exe	del *.exe
if exist *.cod	del *.cod
if exist *.lst	del *.lst
\tools\pkzip -u ..\Uh103
\rac_doc\attr -a *.* > NUL
goto end


:Kr
:KR
call k Z
echo Archiving/Releasing ..\Uh103%2.zip
if exist ..\Uh103%2.zip goto CantCpyIt
if exist ..\Uh103%2.hex goto CantCpyIt
copy ..\Uh103.Zip ..\Uh103%2.zip
copy    Uh103.Hex ..\Uh103%2.Hex
goto end
:CantCpyIt
echo ..\Uh103%2.zip or ..\Uh103%2.hex Already Exist
goto end

:Kbk
:KBK
call K Z
call \SetDest
fbak *.* %DEST%\Ultron\Uh103
fbak ..\*.* %DEST%\Ultron
goto end



rem --------------------------------------------------------------------------
rem --------------------------------------------------------------------------
rem --------------------------------------------------------------------------
rem --------------------------------------------------------------------------
rem --------------------------------------------------------------------------
rem --------------------------------------------------------------------------

:KC
:Kc
rem fbak *.hex a:\
list *.ver
ck_sum Uh118.hex 10000 ff
pause
new_esf/g uh118.hex
goto end


:KE
:Ke
list *.lst
goto end

:Kr
:KR
ECHO WHAT ?
goto end


:KD
:Kd
\tools\pkzip -d \archive\Uh118 %2
goto end

:KG
:Kg
\tools\pkunzip -n \archive\Uh118 %2
goto end

:KU
:Ku
\tools\pkunzip -n \archive\Uh118
goto end


:K1
goto end

if .%2==. goto Kx2
se state_0.asm
goto end
:Kx2
se state_0.asm Rndy
goto end

:K3
if .%2==. goto Kx3
se 
goto end
:Kx3
se Rndy
goto end


:K4
if .%2==. goto Kx4
se %2
goto end
:Kx4
se Rndy
goto end



:Kb
:KB
if exist *.	del *.
if exist *.bak	del *.bak
if exist *.exe	del *.exe
if exist *.cod	del *.cod
if exist *.lst	del *.lst
\tools\pkzip -u ..\Uh118

if exist ..\Uh118%REV%.zip goto CantCpyIt
copy ..\Uh118.Zip ..\Uh118%REV%.zip
goto end
:CantCpyIt
echo ..\Uh118%REV%.zip Already Exist

goto end


:end

pause
