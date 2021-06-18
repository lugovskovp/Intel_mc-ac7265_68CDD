
:: . make copy orig instead backup
::     copy hp_bios_orig.bin hp_bios_patched.bin

rm -f -r ./efi
rm -f  ./*.efi

:: . extract file bod1es -- _Utils\UEFITool A58>UEFIExtract.exe


@echo off
::  -- 5EE86B35-0839-4A21-8845-F1ACB0F688AB -- WLAN
::
@echo -------------------------------------------------------
@echo WLAN
"../../_Utils/UEFITool A58/UEFIExtract.exe" hp_bios.bin 5EE86B35-0839-4A21-8845-F1ACB0F688AB -o efi -m body -t 10
@mv -f ./efi/body.bin .
@ren body.bin 5EE86B35-WLAN.efi
@rm -f -r ./efi

@echo -------------------------------------------------------
@echo PlatformStage1
::  53984C6A-1B4A-4174-9512-A65E5BC8B278  -- PlatformStage1
"../../_Utils/UEFITool A58/UEFIExtract.exe" hp_bios.bin 53984C6A-1B4A-4174-9512-A65E5BC8B278 -o efi -m body -t 10
mv -f ./efi/body.bin .
ren body.bin 53984C6A-PlatformStage1.efi
rm -f -r ./efi

@echo -------------------------------------------------------
@echo PlatformStage2
::  53984C6A-1B4A-4174-9512-A65E5BC8B278  -- PlatformStage1
"../../_Utils/UEFITool A58/UEFIExtract.exe" hp_bios.bin 233DF097-3218-47B2-9E09-FE58C2B20D22 -o efi -m body -t 10
mv -f ./efi/body.bin .
ren body.bin 233DF097-PlatformStage2.efi
rm -f -r ./efi


@echo -------------------------------------------------------
@echo PlatformSetup
:: F6D35FBB-63EA-4B25-81A5-5E62B4886292B  -- 
::
::		"../../_Utils/UEFITool A58/UEFIExtract.exe" hp_bios.bin F6D35FBB-63EA-4B25-81A5-5E62B4886292B -o efi -m body -t 10
::		mv -f ./efi/body.bin .
::		ren body.bin F6D35FBB-PlatformSetup.efi
::		rm -f -r ./efi
::// so, in my bios 2 different files with same guids:
::GUID pattern "F6D35FBB-....-....-....-............" found as "BB5FD3F6EA63254B81A55E62B4886292" in EfiFirmwareFileSystemGuid/PlatformSetup at header-offset 00h
::GUID pattern "F6D35FBB-....-....-....-............" found as "BB5FD3F6EA63254B81A55E62B4886295" in EfiFirmwareFileSystemGuid/F6D35FBB-63EA-4B25-81A5-5E62B4886295 at header-offset 00h
:::::: and i made F6D35FBB-PlatformSetup.handle_extracted saved from from UefiTool
cp -f F6D35FBB-PlatformSetup.handle_extracted.bin F6D35FBB-PlatformSetup.efi






@echo -------------------------------------------------------
@echo RCA check module
:: RCA check module
"../../_Utils/UEFITool A58/UEFIExtract.exe" hp_bios.bin E64E8AEE-0C78-4D9D-86A9-40C97845A3D4 -o efi -m body -t 10
mv -f ./efi/body.bin .
ren body.bin E64E8AEE-RSAchecker.efi
rm -f -r ./efi



@echo -------------------------------------------------------
@echo VSS/NVRAM filesystem
:: "../../_Utils/UEFITool A58/UEFIExtract.exe" hp_bios.bin FFF12B8D-7696-4C8B-A985-2747075B4F50 -o efi -m body -t 10
:: err: Guid FFF12B8D-7696-4C8B-A985-2747075B4F50 failed with 8 code!
:::::: and i made F6D35FBB-PlatformSetup.handle_extracted saved from from UefiTool
cp -f FFF12B8D_VSS_body.handle_extracted.bin FFF12B8D_VSS_body.efi


@echo -------------------------------------------------------
@echo Freeform_PlatformAcpiTablefreeform
:: 7E374E25-8E01-4FEE-87F2-390C23C606CD
:: "../../_Utils/UEFITool A58/UEFIExtract.exe" hp_bios.bin 7E374E25-8E01-4FEE-87F2-390C23C606CD -o efi -m body -t 10
:: mv -f ./efi/body.bin .
cp -f 7E374E25_PlatformAcpiTable.handle_extracted.bin 7E374E25_PlatformAcpiTable.efi






mv -f ./*.efi ./patches
@echo -------------------------------------------------------
@echo -------------------------------------------------------
@echo Result files list:
@echo ---
@ls -b -c1 ./patches
pause
