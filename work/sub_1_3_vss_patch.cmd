:: ----------------------------------------------------------
:: 1.3. VSS / NVRAM storage patching
:: ----------------------------------------------------------
:: draft dir
@cd ./patches
@mkdir vss
@cd ..

:: Make patch file - 
@echo FFF12B8D_VSS_body
@echo 0fa9: 90 90 >./patches/vss/FFF12B8D_VSS_body.patch


:: backup
@cp -f ./patches/FFF12B8D_VSS_body.efi ./patches/vss/FFF12B8D_VSS_body.new
@xxd -g1 -c16 -r ./patches/vss/FFF12B8D_VSS_body.patch ./patches/vss/FFF12B8D_VSS_body.new

:: checking sucsess
@xxd -g1 ./patches/FFF12B8D_VSS_body.efi>./patches/old.hex
@xxd -g1 ./patches/vss/FFF12B8D_VSS_body.new>./patches/new.hex
@diff ./patches/old.hex ./patches/new.hex 
@diff ./patches/old.hex ./patches/new.hex > ./patches/vss/FFF12B8D_VSS_body.hexpatch.diff



:: clear temp files
@rm -f ./patches/*.hex

::moving result to folder build
@v -f ./patches/vss/*.new ./build
