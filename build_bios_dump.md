# Сборка содержимого UEFI flash и прошивка

## Used SW

- [BinCmp2](https://sourceforge.net/projects/bincmp/files/bincmp2/bincmp%202.9.0/) - сравнение файлов, поиск и замена бинарных данных из коммандной строки
- [UEFI Tool 0.28](https://github.com/LongSoft/UEFITool/releases/tag/0.28.0) - старый движок, но полнофункциональный билдер.
- PhoenixTool v.2.66.


## Modules patching

В отдельном каталоге сейчас всё, что необходимо для патча, **&gt; dir /b**

		233DF097-3218-47B2-9E09-FE58C2B20D22_PlatformStage2_patch.txt
		53984C6A-1B4A-4174-9512-A65E5BC8B278_PlatformStage1_patch.txt
		5EE86B35-0839-4A21-8845-F1ACB0F688AB_patch.txt
		bincmp.exe
		E64E8AEE-0C78-4D9D-86A9-40C97845A3D4_SecureUpdating_body_patch.txt
		F6D35FBB-63EA-4B25-81A5-5E62B4886292_PlatformSetup_patch.txt
		File_DXE_driver_5EE86B35-0839-4A21-8845-F1ACB0F688AB_WLAN.ffs
		File_DXE_driver_PlatformSetup_PlatformSetup.ffs
		File_PEI_module_233DF097-3218-47B2-9E09-FE58C2B20D22_PlatformStage2.ffs
		File_PEI_module_53984C6A-1B4A-4174-9512-A65E5BC8B278_PlatformStage1.ffs
		patch_list.cmd
		Section_PE32_image_E64E8AEE-0C78-4D9D-86A9-40C97845A3D4_SecureUpdating_body.efi

При запуске **patch_list.cmd** по каждому файлу вывод примерно такой:

		   >bincmp Section_PE32.efi -patch patch_7AF8h.txt
			>  00007AF8:  86  86  ; skip (old 86 == new 86)
			>  00007AF9:  80  80  ; skip (old 80 == new 80)
			>  00007AFA:  39  5A  ; done
			>  00007AFB:  42  09  ; done
			>  00007AFC:  86  86  ; skip (old 86 == new 86)
			>  00007AFD:  80  80  ; skip (old 80 == new 80)
			>  00007AFE:  16  10  ; done
			>  00007AFF:  13  90  ; done


## Сборка BIOS в UEFI Tool 0.28

Загружаю копию образа оригинального содержимого flash. Быстро перейти к нужным модулям - поиском Hex pattern "8680394286801613". Выбираю родительский модуль РЕ32 секции, на которую приводит поиск, и заменяю её Replace as is соответствующим пропатченным модулем.

![2021-03-11_12-56-17.png](/pix/2021-03-11_12-56-17.png)

Раскрываю новую секцию (Action - Replace) и дочернему элементу вручную назначаю действие Rebuild. Иначе замена пройдет, но CRC32 не пересчитается. Это только для 2х модулей из DXE тома.

![2021-03-11_13-21-06.png](/pix/2021-03-11_13-21-06.png)

После замены 4 модулей, осталось заменить RSA проверку. Ищу по началу GUID E64E8AEE-. Заменяю тело Replace body патченным.

И тут у меня возникают некоторые сомнения - размеры не совпадают. Почему - понятно, тело в BIOS запаковано. На остальных модулях тома появилась действие Rebase и как оно скажется на работоспособности - неизвестно.

![2021-03-11_13-01-49.png](/pix/2021-03-11_13-01-49.png)

Далее меню File - Save image file, добавляю к имени patched. Соглашаюсь с предложением @Open reconstructed file".



## Сборка BIOS в PhoenixTool v.2.66.

48000: HP BB BFR OKU
Blood Flow Restriction, Big Ffff...flying Rocket, Brominated Flame Retardants, 





