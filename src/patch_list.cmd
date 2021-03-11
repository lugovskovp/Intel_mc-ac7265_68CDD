rem patchig modules with WiFi cadrs IDs
bincmp File_DXE_driver_5EE86B35-0839-4A21-8845-F1ACB0F688AB_WLAN.ffs -patch 5EE86B35-0839-4A21-8845-F1ACB0F688AB_patch.txt
bincmp File_DXE_driver_PlatformSetup_PlatformSetup.ffs -patch F6D35FBB-63EA-4B25-81A5-5E62B4886292_PlatformSetup_patch.txt
bincmp File_PEI_module_233DF097-3218-47B2-9E09-FE58C2B20D22_PlatformStage2.ffs -patch 233DF097-3218-47B2-9E09-FE58C2B20D22_PlatformStage2_patch.txt
bincmp File_PEI_module_53984C6A-1B4A-4174-9512-A65E5BC8B278_PlatformStage1.ffs -patch 53984C6A-1B4A-4174-9512-A65E5BC8B278_PlatformStage1_patch.txt
rem patch PE32 section RSA checking module 
bincmp Section_PE32_image_E64E8AEE-0C78-4D9D-86A9-40C97845A3D4_SecureUpdating_body.efi -patch E64E8AEE-0C78-4D9D-86A9-40C97845A3D4_SecureUpdating_body_patch.txt
rem to see result
pause

