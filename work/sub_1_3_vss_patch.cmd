:: ----------------------------------------------------------
:: 1.3. VSS / NVRAM storage patching
:: ----------------------------------------------------------
:: draft dir
@cd ./patches
@mkdir vss
@cd ..

:: Make patch file - set NOP NOP 90 90 instead JNZ 75 07
@echo FFF12B8D_VSS_body
@echo 0fa9: 90 90 >./patches/vss/FFF12B8D_VSS_body.patch



::FFF12B8D_VSS_body.bin




