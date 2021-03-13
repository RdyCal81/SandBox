@Goto K%1

:K
:K1
:K2
\Rac_Doc\EchoDate Make Uh102 Pic >> log.txt
\Compiler\NMAKE "P=HOME" Uh102.MAF
goto EndPause

@\tools\Version Uh102.Ver
@\MPLAB\MPASMWIN /q- Uh102
goto EndPause
goto EndAll


:KZ
:Kz
:K4
if exist *.	del *.
if exist *.bak	del *.bak
if exist *.exe	del *.exe
if exist *.map	del *.map
if exist *.pic	del *.pic
if exist *.lst	del *.lst
\RAC_Doc\Fbak Uh102.hex ..
\Tools\pkzip -u ..\Uh102
attrib -a *.* > NUL
goto EndPause



:KX
:Kx
:K7
@call k 4
if exist ..\Uh102%2.* goto CanNotDo
copy Uh102.Hex ..\Uh102%2.Hex
copy ..\Uh102.Zip ..\Uh102%2.Zip
Goto EndPause


:CanNotDo
Echo file Uh102%2.* already exist try another number
goto EndPause

if exist *.	del *.
if exist *.bak	del *.bak
if exist *.exe	del *.exe
if exist *.map	del *.map
if exist *.pic	del *.pic
if exist *.lst	del *.lst
\RAC_Doc\Fbak Uh102.hex ..
\Tools\pkzip -u ..\Uh102
\Tools\attr -a *.* > NUL
goto EndPause




:EndPause
pause
:EndAll



