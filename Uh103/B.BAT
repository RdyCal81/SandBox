
@CLS
@echo off
@set BM=END
goto R%1

:R
:RB
:Rb
@C:\RAC_DOC\BAT_MENU 1 BAT_MENU.TXT 0
goto R%BM%

; --------- Item 0 - 0 - 0
:R0
if .%2==. goto Rz0
s:\re MAIN.C %2
goto end
:Rz0
s:\re MAIN.C Rndy
goto end

; --------- Item 1 - 1 - 1
:R1
s:\re Z_SYS1.ASM %2
goto end

; --------- Item 2 - 2 - 2
:R2
s:\re Z_SYS.ASM %2
goto end

; --------- Item 3 - 3 - 3
:R3
s:\re FB_DIAG.C %2
goto end

; --------- Item 4 - 4 - 4
:R4
if .%2==. goto Rx4
s:\re PG14_ASM.ASM %2
goto end
:Rx4
s:\re PG14_ASM.ASM Rndy
goto end

; --------- Item 5 - 5 - 5
:R5
if .%2==. goto Rx5
s:\re MAIN14X.C %2
goto end
:Rx5
s:\re MAIN14X.C Rndy
goto end

; --------- Item 6 - 6 - 6
:R6
s:\re FB_PEDIT.C %2
goto end

; --------- Item 7 - 7 - 7
:R7
s:\re FB_MDESC.C %2
goto end

; --------- Item 8 - 8 - 8
:R8
s:\re FB_systm.C %2
goto end

; --------- Item 9 - 9 - 9
:R9
s:\re Z_DNLD.ASM %2
goto end


; --------- Item 10 - 10 - 10
:RA
:R10
if .%2==. goto Rx10
s:\re FB_DNLD.C %2
goto end
:Rx10
s:\re FB_DNLD.C Rndy
goto end

; --------- Item 11 - 11 - 11
:R11
if .%2==. goto Rx11
s:\re B.BAT %2
goto end
:Rx11
s:\re B.BAT Rndy
goto end


:RR
rem tpi100/1f \hex\rx_85250.hex

@TPI_RAC/1FJ C:\HEX\RX_85250.HEX	> S

goto end


:RX
fbak t:\rex\*.exe \tpi_doc
fbak \hex\rx_85250.hex t:\rex
maxdate \hex\rx_85250.hex t:\rex\BUDAPEST.HEX > NUL
if not errorlevel 1 goto NoBASE
msg/3d4d5d2c /                         Backing up "BUDAPEST"
COPY \hex\rx_85250.hex t:\rex\BUDAPEST.hex > NUL
COPY \hex\rx_85250.hex p:\tom_d\BUDAPEST.hex > NUL
COPY \hex\rx_85250.hex T:\BONE\RANDY\CALLAWAY\FRE_BASE\EA\LATEST\SOFTWARE.HEX > NUL
msg/5d4d3d
:NoBASE
set RET=000
if not exist yak goto RT

:RxTag
if not exist yak%RET% goto RxOk
RET
goto RxTag
:RxOk
copy yak yak%RET%
del yak

:RT
@103 RANDY
goto end

:RS
:Rs
if exist output\*.%2 goto RSOK
echo output\*.%2 does not exist
goto end

:RSOK
mapper output\fb_pg1.%2 pg1
mapper output\fb_pg2.%2 pg2
mapper output\fb_pg3.%2 pg3
mapper output\fb_pg4.%2 pg4
mapper output\fb_pg5.%2 pg5
mapper output\fb_pg6.%2 pg6
mapper output\fb_pg7.%2 pg7
mapper output\fb_pg8.%2 pg8
mapper output\fb_pg9.%2 pg9
mapper output\fb_pg10.%2 pg10
mapper output\fb_pg11.%2 pg11
mapper output\fb_pg12.%2 pg12
mapper output\fb_pg13.%2 pg13
mapper output\fb_pg14.%2 pg14
goto end


:RP
:Rp
\mplab\promate\promate 
goto end



@echo off
if .%1==.b goto old
if .%1==.B goto old
if .%1==.c goto docopy
rem fbak \hex\rx_85250.hex t:\
copy \hex\rx_85250.hex \tpi100\085250a.hex
cd \tpi100
tpi-100
s:rcd fre_base
goto end
:docopy
if .%2==. goto nocopy
if exist t:\develop\base*.hex erase t:\develop\base*.hex
copy \hex\rx_85250.hex t:\develop\base%2.hex
dir t:\develop\base*.hex
goto end
:nocopy 
msg/2c /   You must give me a number...
goto end
:old
rem tpi_rac/1f \hex\rx_85250.hex > s
tpi100/1f \hex\rx_85250.hex
rem tpi_rac/1f 085250f.hex
rem tpi100/1f t:\release\085267c.hex
rem tpi100/2f \hex\085250a.hex
rem tpi100/1f s:\085250.hex
if .%2==.a new_esf/2d a
:end
