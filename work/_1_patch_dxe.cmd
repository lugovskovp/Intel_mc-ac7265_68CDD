:: ----------------------------------------------------------
:: 1. Patching whitelists in 4 modules
@cd ./patches
@mkdir wl
@cd ..

::		Hex pattern "8680394286801113" found as "8680394286801113" in EfiCrc32GuidedSectionExtractionGuid/PE32 image section at header-offset AC4h
@call sub_1_1_wl_patch.cmd 0ac0 F6D35FBB-WLAN

::		Hex pattern "8680394286801113" found as "8680394286801113" in EfiCrc32GuidedSectionExtractionGuid/PE32 image section at header-offset 7AD4h
@call sub_1_1_wl_patch.cmd 07ad0 F6D35FBB-PlatformSetup

::		Hex pattern "8680394286801113" found as "8680394286801113" in 53984C6A-1B4A-4174-9512-A65E5BC8B278/PE32 image section at header-offset 2904h
@call sub_1_1_wl_patch.cmd 02900 53984C6A-PlatformStage1

::		Hex pattern "8680394286801113" found as "8680394286801113" in 233DF097-3218-47B2-9E09-FE58C2B20D22/PE32 image section at header-offset 3084h
@call sub_1_1_wl_patch.cmd 03080 233DF097-PlatformStage2



:: ----------------------------------------------------------
:: 2. Pach RSA checking in E64E8AEE-RSAchecker.efi
@echo -----------------------------------------------------
@cd ./patches
@mkdir rsa
@cd ..

:: Make patch file - set NOP NOP 90 90 instead JNZ 75 07
@echo E64E8AEE-RSAchecker
@echo 0fa9: 90 90 >./patches/rsa/E64E8AEE-RSAchecker.patch

:: backup
@cp -f ./patches/E64E8AEE-RSAchecker.efi ./patches/rsa/E64E8AEE-RSAchecker.new
@xxd -g1 -c16 -r ./patches/rsa/E64E8AEE-RSAchecker.patch ./patches/rsa/E64E8AEE-RSAchecker.new

:: checking sucsess
@xxd -g1 ./patches/E64E8AEE-RSAchecker.efi>./patches/old.hex
@xxd -g1 ./patches/rsa/E64E8AEE-RSAchecker.new>./patches/new.hex
@diff ./patches/old.hex ./patches/new.hex 
@diff ./patches/old.hex ./patches/new.hex > ./patches/rsa/E64E8AEE-RSAchecker.hexpatch.diff

:: clear temp files
@rm -f ./patches/*.hex

::moving result to folder build
@mv -f ./patches/rsa/*.new ./build



:: ----------------------------------------------------------
:: 3. VSS / NVRAM storage
@echo -----------------------------------------------------

@call sub_1_3_vss_patch.cmd





pause