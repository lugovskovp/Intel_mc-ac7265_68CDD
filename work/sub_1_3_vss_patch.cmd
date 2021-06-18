:: ----------------------------------------------------------
:: 1.3. VSS / NVRAM storage patching
:: ----------------------------------------------------------
:: draft dir
@cd ./patches
@mkdir vss
@cd ..


:: Make patch file - Base offset HP_Setup[0] = 4634 h
@echo FFF12B8D_VSS_body HP_Setup
:: WWLAN enable
:: HP_Setup[0x49], HP_Setup[0x4A] - WWAN enabled, installed - 01 00; 
:: Base offset 4634+49 = 467D
@echo 0467D: 01 >./patches/vss/FFF12B8D_VSS_body.patch
@echo 0467E: 01 >>./patches/vss/FFF12B8D_VSS_body.patch
:: Integrated camera enable
:: HP_Setup[0x8F], HP_Setup[0x90] - USB canera enabled, installed 
:: Base offset 4634+ 8f= 46C3
@echo 046C3: 01 >>./patches/vss/FFF12B8D_VSS_body.patch
@echo 046C4: 01 >>./patches/vss/FFF12B8D_VSS_body.patch
:: Integrated Bluetooth 2.1 disable, installed 
:: HP_Setup[0x4d], HP_Setup[0x4e] - Bluetooth  installed , NOT enabled
:: Base offset 4634+ 4d= 4680
@echo 04681: 01 >>./patches/vss/FFF12B8D_VSS_body.patch
@echo 04682: 00 >>./patches/vss/FFF12B8D_VSS_body.patch


:: backup
@cp -f ./patches/FFF12B8D_VSS_body.efi ./patches/vss/FFF12B8D_VSS_body.new
@xxd -g1 -c1 -r ./patches/vss/FFF12B8D_VSS_body.patch ./patches/vss/FFF12B8D_VSS_body.new


:: checking sucsess
@xxd -g1 ./patches/FFF12B8D_VSS_body.efi >./patches/old.hex
@xxd -g1 ./patches/vss/FFF12B8D_VSS_body.new >./patches/new.hex
@diff ./patches/old.hex ./patches/new.hex 
@diff ./patches/old.hex ./patches/new.hex >./patches/vss/FFF12B8D_VSS_body.hexpatch.diff


:: clear temp files
@rm -f ./patches/*.hex


::moving result to folder build
@mv -f ./patches/vss/*.new ./build
